defmodule Notso.API do
  @moduledoc """
  Low-level utilities for interacting with the Notion API. Most of this comes
  from the `stripity_stripe` library.
  """

  @type method :: :get | :post | :delete | :patch
  @type headers :: %{String.t() => String.t()} | %{}
  @type body :: iodata() | {:multipart, list()}
  @typep http_success :: {:ok, integer, [{String.t(), String.t()}], String.t()}
  @typep http_failure :: {:error, term}

  @pool_name __MODULE__

  @default_max_attempts 3
  @default_base_backoff 500
  @default_max_backoff 2_000

  @spec supervisor_children() :: nil | list()
  def supervisor_children do
    if use_pool?() do
      [:hackney_pool.child_spec(@pool_name, get_pool_options())]
    end
  end

  @spec get_pool_options() :: Keyword.t()
  defp get_pool_options do
    Application.get_env(:notso, :pool_options)
  end

  @spec use_pool?() :: boolean()
  defp use_pool? do
    Application.get_env(:notso, :use_connection_pool)
  end

  defp retry_config() do
    Application.get_env(:notso, :retries, [])
  end

  @spec get_base_url() :: String.t()
  defp get_base_url() do
    Application.get_env(:notso, :api_base_url)
  end

  def request(body, method, endpoint, headers, opts) do
    base_url = get_base_url()
    req_url = "#{base_url}#{endpoint}"

    req_body = Jason.encode!(body)

    perform_request(req_url, method, req_body, headers, opts)
  end

  def should_retry?(response, attempts \\ 0, config \\ []) do
    max_attempts = Keyword.get(config, :max_attempts) || @default_max_attempts

    if attempts >= max_attempts do
      false
    else
      retry_response?(response)
    end
  end

  @spec add_default_headers(headers) :: headers
  defp add_default_headers(existing_headers) do
    Map.merge(existing_headers, %{
      "Accept" => "application/json; charset=utf8",
      "Accept-Encoding" => "gzip",
      "Connection" => "keep-alive",
      "Content-Type" => "application/json"
    })
  end

  defp add_auth_header(existing_headers, token) do
    token = fetch_token(token)
    Map.put(existing_headers, "Authorization", "Bearer #{token}")
  end

  defp fetch_token(token) do
    case token do
      key when is_binary(key) -> key
      _ -> Application.get_env(:notso, :integration_token, "")
    end
  end

  defp add_default_options(opts) do
    [:with_body | opts]
  end

  defp add_pool_option(opts) do
    if use_pool?() do
      [{:pool, @pool_name} | opts]
    else
      opts
    end
  end

  defp add_options_from_config(opts) do
    if is_list(Application.get_env(:notso, :hackney_opts)) do
      opts ++ Application.get_env(:notso, :hackney_opts)
    else
      opts
    end
  end

  defp perform_request(req_url, method, body, headers, opts) do
    {integration_token, opts} = Keyword.pop(opts, :integration_token)

    req_headers =
      headers
      |> add_default_headers()
      |> add_auth_header(integration_token)
      |> Map.to_list()

    req_opts =
      opts
      |> add_default_options()
      |> add_pool_option()
      |> add_options_from_config()

    do_perform_request(method, req_url, req_headers, body, req_opts)
  end

  defp do_perform_request(method, url, headers, body, opts) do
    do_perform_request_and_retry(method, url, headers, body, opts, {:attempts, 0})
  end

  defp do_perform_request_and_retry(_method, _url, _headers, _body, _opts, {:response, response}) do
    handle_response(response)
  end

  defp do_perform_request_and_retry(method, url, headers, body, opts, {:attempts, attempts}) do
    IO.inspect(body)
    response = :hackney.request(method, url, headers, body, opts)

    do_perform_request_and_retry(
      method,
      url,
      headers,
      body,
      opts,
      add_attempts(response, attempts, retry_config())
    )
  end

  defp add_attempts(response, attempts, retry_config) do
    if should_retry?(response, attempts, retry_config) do
      attempts
      |> backoff(retry_config)
      |> :timer.sleep()

      {:attempts, attempts + 1}
    else
      {:response, response}
    end
  end

  def backoff(attempts, config) do
    base_backoff = Keyword.get(config, :base_backoff) || @default_base_backoff
    max_backoff = Keyword.get(config, :max_backoff) || @default_max_backoff

    (base_backoff * :math.pow(2, attempts))
    |> min(max_backoff)
    |> backoff_jitter()
    |> max(base_backoff)
    |> trunc()
  end

  defp backoff_jitter(n) do
    # Apply some jitter by randomizing the value in the range of (n / 2) to n
    n * (0.5 * (1 + :rand.uniform()))
  end

  @spec retry_response?(http_success | http_failure) :: boolean
  # 409 conflict
  defp retry_response?({:ok, 409, _headers, _body}), do: true
  # Destination refused the connection, the connection was reset, or a
  # variety of other connection failures. This could occur from a single
  # saturated server, so retry in case it's intermittent.
  defp retry_response?({:error, :econnrefused}), do: true
  # Retry on timeout-related problems (either on open or read).
  defp retry_response?({:error, :connect_timeout}), do: true
  defp retry_response?({:error, :timeout}), do: true
  defp retry_response?(_response), do: false

  defp handle_response({:ok, status, headers, body}) when status >= 200 and status <= 299 do
    decoded_body =
      body
      |> decompress_body(headers)
      |> Jason.decode!()

    {:ok, decoded_body}
  end

  defp decompress_body(body, headers) do
    headers_dict = :hackney_headers.new(headers)

    case :hackney_headers.get_value("Content-Encoding", headers_dict) do
      "gzip" -> :zlib.gunzip(body)
      "deflate" -> :zlib.unzip(body)
      _ -> body
    end
  end
end

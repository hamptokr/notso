defmodule Notso.Request do
  @moduledoc """
  A module for working with the requests to the Notion API.

  Intended to be used internally and as an "escape hatch" for end-users to work
  around missing endpoints.
  """
  alias Notso.API

  defstruct opts: [],
            endpoint: nil,
            headers: nil,
            method: nil,
            params: %{}

  @type t :: %__MODULE__{
          opts: Keyword.t() | nil,
          endpoint: String.t() | nil,
          headers: map() | nil,
          method: API.method() | nil,
          params: map()
        }

  @doc """
  Initializes a new Request.

  Optionally accepts options for the request, such as overriding the API key
  specific to this request.
  """
  @spec new(Keyword.t(), map()) :: t()
  def new(opts \\ [], headers \\ %{}) do
    headers = Keyword.get(opts, :headers, %{}) |> Map.merge(headers)

    %__MODULE__{opts: opts, headers: headers}
  end

  @doc """
  Specifies an endpoint for the request
  """
  @spec endpoint(t(), String.t()) :: t()
  def endpoint(%__MODULE__{} = request, endpoint) do
    %{request | endpoint: endpoint}
  end

  @doc """
  Specifies a method for the request
  """
  @spec method(t(), API.method()) :: t()
  def method(%__MODULE__{} = request, method) when method in [:get, :post, :delete, :patch] do
    %{request | method: method}
  end

  @doc """
  Specifies parameters to be used for the request body, for POST requests, this
  is encoded into the request body.

  Calling this function multiple times will merge parameters, not replace.
  """
  @spec params(t(), map()) :: t()
  def params(%__MODULE__{params: params} = request, new_params) do
    %{request | params: Map.merge(params, new_params)}
  end

  @doc """
  Perform the provided configured request
  """
  @spec make_request(t()) :: {:ok, map()}
  def make_request(%__MODULE__{
        params: params,
        method: method,
        endpoint: endpoint,
        headers: headers,
        opts: opts
      }) do
    API.request(params, method, endpoint, headers, opts)
  end
end

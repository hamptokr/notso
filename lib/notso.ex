defmodule Notso do
  @moduledoc """
  A HTTP client for Notion. Heavily inspired by the fantastic `stripity_stripe`
  library. Thank you so much Code Corps team, you saved me a ton of time setting
  up low-level functionality!
  
  ## Configuration
  
  ### API Access
  
  For internal integrations you simply need to set your integration token in
  your application configuration. Typically this is done in `config/config.exs`
  or a similar file. For example:
  
      config :notso, integration_token: "secret_abcdefghijklmnopqrstuvwxyz"
  
  You could also use `System.get_env/2` to retrieve the token from an
  environment variable, but this could potentially cause issues if you use a
  release tool like Distillery.
  
      config :notso, integration_token: System.get_env("NOTSO_INTEGRATION_TOKEN")
  """
  use Application

  @type options :: Keyword.t()

  @spec start(Application.start_type(), any) :: {:error, any} | {:ok, pid} | {:ok, pid, any}
  def start(_type, _args) do
    children = Notso.API.supervisor_children()

    opts = [strategy: :one_for_one, name: Notso.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

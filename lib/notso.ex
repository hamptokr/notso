defmodule Notso do
  @moduledoc """
  A HTTP client for Notion.

  ## Configuration

  ### API Access

  For internal integrations you simply need to set your integration token in
  your application configuration. Typically this is done in `config/config.exs`
  or a similar file. For example:

      config :notso, integration_token: "secret_abcdefghijklmnopqrstuvwxyz"

  You could also use `System.get_env/2` to retrieve the token from an
  environment variable, but this could potentially cause issues if you use a
  release tool like exrm or Distillery.

      config :notso, integration_token: System.get_env("NOTSO_INTEGRATION_TOKEN")
  """
  use Application

  @impl Application
  def start(_type, _args) do
    children = Notso.API.supervisor_children()

    opts = [strategy: :one_for_one, name: Notso.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

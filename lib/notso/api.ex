defmodule Notso.API do
  @moduledoc """
  Low-level utilities for interacting with the Notion API.
  """
  @pool_name __MODULE__

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
end

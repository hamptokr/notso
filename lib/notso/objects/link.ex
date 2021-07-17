defmodule Notso.Link do
  defstruct [:type, :url]

  @type t :: %__MODULE__{
          type: :url,
          url: String.t()
        }

  def new(address) when is_binary(address) do
    %__MODULE__{type: :url, url: address}
  end
end

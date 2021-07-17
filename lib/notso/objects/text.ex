defmodule Notso.Text do
  alias Notso.Link

  defstruct [:content, :link]

  @type t :: %__MODULE__{
          content: String.t(),
          link: Link.t() | nil
        }

  def new(content) when is_binary(content) do
    %__MODULE__{content: content}
  end

  def link_to(%__MODULE__{} = text, address) do
    %{text | link: Link.new(address)}
  end
end

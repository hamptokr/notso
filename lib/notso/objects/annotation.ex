defmodule Notso.Annotation do
  defstruct [:bold, :italic, :strikethrough, :underline, :code, :color]

  @type t :: %__MODULE__{
          bold: boolean(),
          italic: boolean(),
          strikethrough: boolean(),
          underline: boolean(),
          code: boolean(),
          color: Notso.Types.color_or_background_color()
        }
end

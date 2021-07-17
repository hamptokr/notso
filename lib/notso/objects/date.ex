defmodule Notso.Date do
  defstruct [:start, :end]

  @type t :: %__MODULE__{
          start: String.t(),
          end: String.t() | nil
        }

  def start(%DateTime{} = start_date) do
    %__MODULE__{
      start: DateTime.to_iso8601(start_date)
    }
  end

  def range(%DateTime{} = start_date, %DateTime{} = end_date) do
    %__MODULE__{
      start: DateTime.to_iso8601(start_date),
      end: DateTime.to_iso8601(end_date)
    }
  end
end

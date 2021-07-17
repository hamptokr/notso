defmodule Notso.Equation do
  defstruct [:expression]

  @type t :: %__MODULE__{
          expression: String.t()
        }

  def new(expression) do
    %__MODULE__{
      expression: expression
    }
  end
end

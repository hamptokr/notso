defmodule Notso.User do
  defstruct [:object, :id, :type, :name, :avatar_url, :person]

  @type person :: %{
          email: String.t()
        }

  # TODO(kramer): Figure out what the bot object contains, it's not documented
  @type t :: %__MODULE__{
          object: :user,
          id: String.t(),
          type: :person | :bot | nil,
          name: String.t() | nil,
          avatar_url: String.t() | nil,
          person: person() | nil
        }
end

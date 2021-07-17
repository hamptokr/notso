defmodule Notso.Mention do
  alias Notso.Date, as: NotsoDate
  alias Notso.User

  defstruct [:type, :user, :page, :database, :date]

  @type t :: %__MODULE__{
          type: :user | :page | :database | :date,
          user: User.t() | nil,
          page: Notso.Types.id_reference() | nil,
          database: Notso.Types.id_reference() | nil,
          date: NotsoDate.t() | nil
        }

  def user(%User{} = user) do
    %__MODULE__{
      type: :user,
      user: user
    }
  end

  def page(id) when is_binary(id) do
    %__MODULE__{
      type: :page,
      page: %{id: id}
    }
  end

  def database(id) when is_binary(id) do
    %__MODULE__{
      type: :database,
      database: %{id: id}
    }
  end

  def date(%DateTime{} = start_date) do
    %__MODULE__{
      type: :date,
      date: NotsoDate.start(start_date)
    }
  end

  def date_range(%DateTime{} = start_date, %DateTime{} = end_date) do
    %__MODULE__{
      type: :date,
      date: NotsoDate.range(start_date, end_date)
    }
  end
end

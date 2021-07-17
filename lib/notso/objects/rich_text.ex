defmodule Notso.RichText do
  @moduledoc """
  Work with notion Rich Text objects

  This module doesn't make API requests, however it is used as parameters in
  other modules.
  """

  alias Notso.Annotation
  alias Notso.Equation
  alias Notso.Mention
  alias Notso.Text
  alias Notso.User

  defstruct [:plain_text, :text, :href, :annotations, :type, :mention, :equation]

  @type t :: %__MODULE__{
          plain_text: String.t(),
          href: String.t() | nil,
          annotations: [Annotation.t()],
          type: :text | :mention | :equation,
          text: Text.t() | nil,
          mention: Mention.t() | nil,
          equation: Equation.t() | nil
        }

  def text(text) do
    %__MODULE__{
      plain_text: text,
      type: :text,
      text: Text.new(text)
    }
  end

  def text_link(text, address) do
    text_object = Text.new(text) |> Text.link_to(address)

    %__MODULE__{
      plain_text: text,
      type: :text,
      text: text_object
    }
  end

  def mention_user(text, %User{} = user) do
    %__MODULE__{
      plain_text: text,
      type: :mention,
      mention: Mention.user(user)
    }
  end

  def mention_page(text, id) when is_binary(id) do
    %__MODULE__{
      plain_text: text,
      type: :mention,
      mention: Mention.page(id)
    }
  end

  def mention_database(text, id) when is_binary(id) do
    %__MODULE__{
      plain_text: text,
      type: :mention,
      mention: Mention.database(id)
    }
  end

  def mention_date(text, %DateTime{} = start_date) do
    %__MODULE__{
      plain_text: text,
      type: :mention,
      mention: Mention.date(start_date)
    }
  end

  def mention_date_range(text, %DateTime{} = start_date, %DateTime{} = end_date) do
    %__MODULE__{
      plain_text: text,
      type: :mention,
      mention: Mention.date_range(start_date, end_date)
    }
  end

  def equation(text, expression) do
    %__MODULE__{
      plain_text: text,
      type: :equation,
      equation: Equation.new(expression)
    }
  end
end

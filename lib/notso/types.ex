defmodule Notso.Types do
  @type id_reference :: %{id: String.t()}

  @type background_color ::
          :gray_background
          | :brown_background
          | :orange_background
          | :yellow_background
          | :green_background
          | :blue_background
          | :purple_background
          | :pink_background
          | :red_background

  @type color ::
          :default
          | :gray
          | :brown
          | :orange
          | :yellow
          | :green
          | :blue
          | :purple
          | :pink
          | :red

  @type color_or_background_color :: color() | background_color()

  @type number_property :: %{
          optional(:format) =>
            :number
            | :number_with_commas
            | :percent
            | :dollar
            | :euro
            | :pound
            | :yen
            | :ruble
            | :rupee
            | :won
            | :yuan
        }

  @type select_option :: %{
          id: String.t(),
          name: String.t(),
          color: color()
        }

  @type select_property :: %{
          optional(:options) => [select_option()]
        }
end

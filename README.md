# notso

**This project is not yet available in Hex and is very unstable right now.**

## Usage

`notso` is an HTTP wrapper around the Notion API that also aims to make content
within Notion composable. See below for an example.

NOTE: This is a goal of `notso` but the API is not completely fleshed out yet.

```elixir
alias Notso.RichText

def example_mention(user) do
  # This will generate a notion rich text object to be used by the API
  mention = RichText.mention_user("Kramer Hampton", user)
end
```

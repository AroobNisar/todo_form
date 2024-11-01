# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Todo.Repo.insert!(%Todo.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Todo.Quotes

path="priv/repo/quotes.json"
path
|> File.read!()
|> Jason.decode!()
|> Enum.each(fn attrs->
  quote= %{name: attrs["name"], hobby: attrs["hobby"]}
  case Quotes.create_quote(quote) do
    {:ok, _quote}-> :ok
    {:error, _changeset}->:duplicate
  end
end)

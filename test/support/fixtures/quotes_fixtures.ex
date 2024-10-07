defmodule Todo.QuotesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Todo.Quotes` context.
  """

  @doc """
  Generate a quote.
  """
  def quote_fixture(attrs \\ %{}) do
    {:ok, quote} =
      attrs
      |> Enum.into(%{
        hobby: "some hobby",
        name: "some name"
      })
      |> Todo.Quotes.create_quote()

    quote
  end
end

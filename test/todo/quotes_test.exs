defmodule Todo.QuotesTest do
  use Todo.DataCase

  alias Todo.Quotes

  describe "quotes" do
    alias Todo.Quotes.Quote

    import Todo.QuotesFixtures

    @invalid_attrs %{name: nil, hobby: nil}

    test "list_quotes/0 returns all quotes" do
      quote = quote_fixture()
      assert Quotes.list_quotes() == [quote]
    end

    test "get_quote!/1 returns the quote with given id" do
      quote = quote_fixture()
      assert Quotes.get_quote!(quote.id) == quote
    end

    test "create_quote/1 with valid data creates a quote" do
      valid_attrs = %{name: "some name", hobby: "some hobby"}

      assert {:ok, %Quote{} = quote} = Quotes.create_quote(valid_attrs)
      assert quote.name == "some name"
      assert quote.hobby == "some hobby"
    end

    test "create_quote/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Quotes.create_quote(@invalid_attrs)
    end

    test "update_quote/2 with valid data updates the quote" do
      quote = quote_fixture()
      update_attrs = %{name: "some updated name", hobby: "some updated hobby"}

      assert {:ok, %Quote{} = quote} = Quotes.update_quote(quote, update_attrs)
      assert quote.name == "some updated name"
      assert quote.hobby == "some updated hobby"
    end

    test "update_quote/2 with invalid data returns error changeset" do
      quote = quote_fixture()
      assert {:error, %Ecto.Changeset{}} = Quotes.update_quote(quote, @invalid_attrs)
      assert quote == Quotes.get_quote!(quote.id)
    end

    test "delete_quote/1 deletes the quote" do
      quote = quote_fixture()
      assert {:ok, %Quote{}} = Quotes.delete_quote(quote)
      assert_raise Ecto.NoResultsError, fn -> Quotes.get_quote!(quote.id) end
    end

    test "change_quote/1 returns a quote changeset" do
      quote = quote_fixture()
      assert %Ecto.Changeset{} = Quotes.change_quote(quote)
    end
  end
end

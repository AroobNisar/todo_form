defmodule Todo.BooksTest do
  use Todo.DataCase

  alias Todo.Books

  describe "books" do
    alias Todo.Books.Book

    import Todo.BooksFixtures

    @invalid_attrs %{version: nil, title: nil, author: nil}

    test "list_books/0 returns all books" do
      book = book_fixture()
      assert Books.list_books() == [book]
    end

    test "get_book!/1 returns the book with given id" do
      book = book_fixture()
      assert Books.get_book!(book.id) == book
    end

    test "create_book/1 with valid data creates a book" do
      valid_attrs = %{version: 120.5, title: "some title", author: "some author"}

      assert {:ok, %Book{} = book} = Books.create_book(valid_attrs)
      assert book.version == 120.5
      assert book.title == "some title"
      assert book.author == "some author"
    end

    test "create_book/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Books.create_book(@invalid_attrs)
    end

    test "update_book/2 with valid data updates the book" do
      book = book_fixture()
      update_attrs = %{version: 456.7, title: "some updated title", author: "some updated author"}

      assert {:ok, %Book{} = book} = Books.update_book(book, update_attrs)
      assert book.version == 456.7
      assert book.title == "some updated title"
      assert book.author == "some updated author"
    end

    test "update_book/2 with invalid data returns error changeset" do
      book = book_fixture()
      assert {:error, %Ecto.Changeset{}} = Books.update_book(book, @invalid_attrs)
      assert book == Books.get_book!(book.id)
    end

    test "delete_book/1 deletes the book" do
      book = book_fixture()
      assert {:ok, %Book{}} = Books.delete_book(book)
      assert_raise Ecto.NoResultsError, fn -> Books.get_book!(book.id) end
    end

    test "change_book/1 returns a book changeset" do
      book = book_fixture()
      assert %Ecto.Changeset{} = Books.change_book(book)
    end
  end
end

defmodule Todo.Books.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :version, :float
    field :title, :string
    field :author, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:title, :author, :version])
    |> validate_required([:title, :author, :version])
  end
end

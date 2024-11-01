defmodule Todo.Quotes.Quote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "quotes" do
    field :name, :string
    field :hobby, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(quote, attrs) do
    quote
    |> cast(attrs, [:name, :hobby])
    |> validate_required([:name, :hobby])
    |> unique_constraint(:name, name: :index_for_duplicate_quote)
  end
end

defmodule Todo.Gallaries.Gallary do
  use Ecto.Schema
  import Ecto.Changeset

  schema "gallaries" do
    field :name, :string
    field :author, :string
    field :image, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(gallary, attrs) do
    gallary
    |> cast(attrs, [:name, :author, :image])
    |> validate_required([:name, :author, :image])
  end
end

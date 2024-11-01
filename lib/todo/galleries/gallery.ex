defmodule Todo.Galleries.Gallery do
  use Ecto.Schema
  import Ecto.Changeset

  schema "galleries" do
    field :name, :string
    field :author, :string
    field :art_image, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(gallery, attrs) do
    gallery
    |> cast(attrs, [:name, :author, :art_image])
    |> validate_required([:name, :author, :art_image])
  end
end

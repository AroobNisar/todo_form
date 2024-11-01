defmodule Todo.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :name, :string
    field :author, :string
    field :status, Ecto.Enum, values: [:complete, :archeived]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:name, :author, :status])
    |> validate_required([:name, :author])
  end
end

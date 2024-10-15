defmodule Todo.Gallaries.Filter do
  use Ecto.Schema
  import Ecto.Changeset

  schema "filters" do
    field :page, :string
    field :options, {:array, :string}, default: []

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(filter, attrs) do
    filter
    |> cast(attrs, [:page, :options])
    |> validate_required([:page, :options])
  end
end

defmodule Todo.Todo_Form do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todo_forms" do
    field :status, :boolean, default: false
    field :description, :string
    field :title, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(todo__form, attrs) do
    todo__form
    |> cast(attrs, [:title, :description, :status])
    |> validate_required([:title, :description, :status])
  end
end

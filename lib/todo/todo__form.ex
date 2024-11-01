defmodule Todo.Todo_Form do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todo_forms" do
    field :status, :boolean, default: false
    field :description, :string
    field :title, :string
    field :age, :integer
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(todo__form, attrs) do
    todo__form
    |> cast(attrs, [:title, :description, :status, :age])
    |> validate_required([:title, :description, :status, :age])
  end
end

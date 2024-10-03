defmodule Todo.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :status, :boolean, default: false
    field :description, :string
    field :title, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:title, :description, :status])
    |> validate_required([:title, :description, :status])
  end
end

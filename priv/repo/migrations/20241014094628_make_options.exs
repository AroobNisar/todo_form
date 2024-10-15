defmodule Todo.Repo.Migrations.MakeOptions do
  use Ecto.Migration

  def change do
    create table(:filters) do
      add :page, :string
      add :options, {:array, :string}

      timestamps(type: :utc_datetime)
    end
  end
end

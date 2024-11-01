defmodule Todo.Repo.Migrations.DiffUsers do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :room, :string
    end
  end
end

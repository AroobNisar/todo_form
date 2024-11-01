defmodule Todo.Repo.Migrations.CreateStatusField do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :status, :string
    end
  end
end

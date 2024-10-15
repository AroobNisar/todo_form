defmodule Todo.Repo.Migrations.CreateOptions do
  use Ecto.Migration

  def change do
    alter table(:gallaries) do
      add :options, :map
    end
  end
end

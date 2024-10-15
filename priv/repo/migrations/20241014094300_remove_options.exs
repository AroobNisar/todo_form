defmodule Todo.Repo.Migrations.RemoveOptions do
  use Ecto.Migration

  def change do
    alter table(:gallaries) do
      remove :options, :map
    end
  end
end

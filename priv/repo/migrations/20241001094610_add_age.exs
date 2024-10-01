defmodule Todo.Repo.Migrations.AddAge do
  use Ecto.Migration

  def change do
    alter table("todo_forms") do
      add :age, :integer
    end
  end
end

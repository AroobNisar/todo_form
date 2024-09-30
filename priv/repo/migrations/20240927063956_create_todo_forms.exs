defmodule Todo.Repo.Migrations.CreateTodoForms do
  use Ecto.Migration

  def change do
    create table(:todo_forms) do
      add :title, :string
      add :description, :string
      add :status, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end

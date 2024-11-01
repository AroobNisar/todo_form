defmodule Todo.Repo.Migrations.CreateTests do
  use Ecto.Migration

  def change do
    create table(:tests) do
      add :name, :string
      add :grade, :string
      add :age, :integer

      timestamps(type: :utc_datetime)
    end
  end
end

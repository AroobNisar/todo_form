defmodule Todo.Repo.Migrations.CreateQuotes do
  use Ecto.Migration

  def change do
    create table(:quotes) do
      add :name, :string
      add :hobby, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:quotes, [:name], name: :index_for_duplicate_quote)
  end
end

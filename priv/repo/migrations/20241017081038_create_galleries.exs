defmodule Todo.Repo.Migrations.CreateGalleries do
  use Ecto.Migration

  def change do
    create table(:galleries) do
      add :name, :string
      add :author, :string

      timestamps(type: :utc_datetime)
    end
  end
end

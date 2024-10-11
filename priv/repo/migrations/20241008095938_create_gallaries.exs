defmodule Todo.Repo.Migrations.CreateGallaries do
  use Ecto.Migration

  def change do
    create table(:gallaries) do
      add :name, :string
      add :author, :string
      add :image, :string

      timestamps(type: :utc_datetime)
    end
  end
end

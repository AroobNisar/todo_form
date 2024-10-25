defmodule Todo.Repo.Migrations.CreateConversations do
  use Ecto.Migration

  def change do
    create table(:conversations) do
      add :user1_id, references(:users, on_delete: :nothing)
      add :user2_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:conversations, [:user1_id])
    create index(:conversations, [:user2_id])
  end
end

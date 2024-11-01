defmodule Todo.Repo.Migrations.AddConversationId do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :conversation_id, references(:conversations, on_delete: :nothing)
    end
  end
end

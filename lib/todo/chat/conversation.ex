defmodule Todo.Chat.Conversation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "conversations" do

    belongs_to :user1, Todo.Accounts.User
    belongs_to :user2, Todo.Accounts.User

    has_many :messages, Todo.Chat.Message

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(conversation, attrs) do
    conversation
    |> cast(attrs, [:user1_id, :user2_id])
    |> validate_required([:user1_id, :user2_id])
    |> unique_constraint([:user1_id, :user2_id])
  end
end

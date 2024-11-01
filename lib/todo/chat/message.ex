defmodule Todo.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :text, :string
    field :room, :string
    belongs_to :user, Todo.Users.User
    belongs_to :conversation, Todo.Conversation

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:text, :user_id, :room])
    |> validate_required([:text, :user_id, :room])
  end
end

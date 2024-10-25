defmodule Todo.Chat do
  alias Todo.Repo
  alias Todo.Chat.{Conversation, Message}
  import Ecto.Query, only: [from: 2]

  def get_or_create_conversation(user1_id, user2_id) do
    Repo.get_by(Conversation, user1_id: user1_id, user2_id: user2_id) ||
      Repo.get_by(Conversation, user1_id: user2_id, user2_id: user1_id) ||
      %Conversation{user1_id: user1_id, user2_id: user2_id}
      |> Repo.insert()
  end

  def get_conversation!(conversation_id) do
    Repo.get!(Conversation, conversation_id)
  end

  def list_user_conversations(user_id) do
    Repo.all(
      from c in Conversation,
      where: c.user1_id == ^user_id or c.user2_id == ^user_id,
      preload: [:user1, :user2]
    )
  end

  def list_messages_for_conversation(conversation_id) do
    Repo.all(
      from m in Message,
      where: m.conversation_id == ^conversation_id,
      order_by: [asc: m.inserted_at],
      preload: [:user]
    )
  end

  def send_message(conversation_id, user_id, text) do
    %Message{
      conversation_id: conversation_id,
      user_id: user_id,
      text: text
    }
    |> Repo.insert()
  end
end

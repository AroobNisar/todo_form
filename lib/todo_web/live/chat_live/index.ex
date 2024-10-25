defmodule TodoWeb.ChatLive.Index do
  use TodoWeb, :live_view
  alias Todo.Chat.Message
  alias Todo.Repo
  import Ecto.Query, only: [from: 2]

  def mount(%{"room"=>room}=_params, _session, socket) do
    if connected?(socket) do
      TodoWeb.Endpoint.subscribe(topic(room))
    end
    messages = Repo.all(
      from m in Message,
      join: u in assoc(m, :user),
      where: m.room == ^room,
      order_by: [asc: m.inserted_at],
      select: %{text: m.text, name: u.id}
    )
    {:ok, assign(socket, username: socket.assigns.current_user.id, room: room, messages: messages)}
  end

  def handle_info(%{event: "message", payload: message}, socket) do
    {:noreply, assign(socket, messages: socket.assigns.messages ++ [message])}
  end

  def handle_event("send", %{"text" => text}, socket) do
    user_id = socket.assigns.current_user.id
    room = socket.assigns.room
    %Message{text: text, user_id: user_id, room: room}
    |> Repo.insert()

    TodoWeb.Endpoint.broadcast(topic(room), "message", %{text: text, name: socket.assigns.username})
    {:noreply, socket}
  end

  defp topic(room) do
    "chat #{room}"
  end
end

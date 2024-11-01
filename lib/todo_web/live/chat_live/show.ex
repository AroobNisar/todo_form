defmodule TodoWeb.ChatLive.Show do
  use TodoWeb, :live_view
  alias Todo.Chat.Message
  alias Todo.Repo
  import Ecto.Query, only: [from: 2]

  def mount(_params, _session, socket) do
    rooms =
      Enum.uniq(
        Repo.all(
          from m in Message,
            where: m.room != "",
            order_by: [asc: m.inserted_at],
            select: m.room
        )
      )
      |> IO.inspect()

    {:ok, assign(socket, :rooms, rooms)}
  end

  def handle_event("new-room", %{"room" => room}, socket) do
    %Message{room: room}
    |> Repo.insert()

    socket =
      socket
      |> push_navigate(to: ~p"/chat/#{room}")

    {:noreply, socket}
  end
end

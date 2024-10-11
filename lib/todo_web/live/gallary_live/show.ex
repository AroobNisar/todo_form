defmodule TodoWeb.GallaryLive.Show do
  use TodoWeb, :live_view

  alias Todo.Gallaries

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:gallary, Gallaries.get_gallary!(id))}
  end

  defp page_title(:show), do: "Show Gallary"
  defp page_title(:edit), do: "Edit Gallary"
end

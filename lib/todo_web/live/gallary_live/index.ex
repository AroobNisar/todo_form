defmodule TodoWeb.GallaryLive.Index do
  use TodoWeb, :live_view

  alias Todo.Gallaries
  alias Todo.Gallaries.Gallary

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :gallaries, Gallaries.list_gallaries())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Gallary")
    |> assign(:gallary, Gallaries.get_gallary!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Gallary")
    |> assign(:gallary, %Gallary{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Gallaries")
    |> assign(:gallary, nil)
  end

  defp apply_action(socket, :filter, _params) do
    socket
    |> assign(:page_title, "Filtering Gallaries")
    |> assign(:gallary, nil)
  end

  @impl true
  def handle_info({TodoWeb.GallaryLive.FormComponent, {:saved, gallary}}, socket) do
    {:noreply, stream_insert(socket, :gallaries, gallary)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    gallary = Gallaries.get_gallary!(id)
    {:ok, _} = Gallaries.delete_gallary(gallary)

    {:noreply, stream_delete(socket, :gallaries, gallary)}
  end
end

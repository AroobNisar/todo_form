defmodule TodoWeb.TaskLive.Index do
  use TodoWeb, :live_view
  import Ecto.Query, only: [from: 2]
  alias Todo.Repo

  alias Todo.Tasks
  alias Todo.Tasks.Task

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     stream(socket, :tasks, Tasks.list_tasks())
     |> assign(:query, Tasks.list_tasks())
     |> assign(:form, [])
     |> assign(:number, 0)
     |> assign(:seconds, 0)
     |> assign(:tRef, nil)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Task")
    |> assign(:task, Tasks.get_task!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Task")
    |> assign(:task, %Task{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tasks")
    |> assign(:task, nil)
  end

  @impl true
  def handle_info({TodoWeb.TaskLive.FormComponent, {:saved, task}}, socket) do
    {:noreply, stream_insert(socket, :tasks, task)}
  end

  def handle_info(:tick, %{assigns: %{seconds: seconds}} = socket) do
    {:noreply, socket |> assign(:seconds, seconds + 1)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    task = Tasks.get_task!(id)
    {:ok, _} = Tasks.delete_task(task)

    {:noreply, stream_delete(socket, :tasks, task)}
  end

  def handle_event("increment", %{"number" => number}, socket) do
    number = number + 1
    {:noreply, assign(socket, :number, number)}
  end

  def handle_event("decrement", %{"number" => number}, socket) do
    number = number - 1
    {:noreply, assign(socket, :number, number)}
  end

  def handle_event("start-clock", _params, socket) do
    if socket.assigns[:tRef] do
      :timer.cancel(socket.assigns.tRef)
    end

    {:ok, tRef} = :timer.send_interval(1000, self(), :tick)
    {:noreply, assign(socket, :seconds, 0) |> assign(:tRef, tRef)}
  end

  def handle_event("stop-clock", %{"seconds" => seconds}, socket) do
    :timer.cancel(socket.assigns.tRef)
    {:noreply, assign(socket, :seconds, seconds) |> assign(:tRef, nil)}
  end

  def handle_event("reset-clock", %{"seconds" => seconds}, socket) do
    if socket.assigns[:tRef] do
      :timer.cancel(socket.assigns.tRef)
    end

    {:noreply, assign(socket, :seconds, 0) |> assign(:tRef, nil)}
  end

  def handle_event("search", %{"search" => search}, socket) do
    search_term = "%#{search}%"

    query =
      Repo.all(
        from(
          p in Task,
          where: ilike(p.name, ^search_term) or ilike(p.description, ^search_term)
        )
      )

    form =
      Repo.all(
        from(
          p in Task,
          where: ilike(p.name, ^search_term) or ilike(p.description, ^search_term)
        )
      )

    form = if search in ["", nil], do: [], else: form
    {:noreply, assign(socket, query: query, form: form)}
  end
end

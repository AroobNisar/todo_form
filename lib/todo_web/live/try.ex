defmodule TodoWeb.Live.Try do
  alias Todo.Todo_Form
  import TodoWeb.CoreComponents
  use TodoWeb, :live_view
  alias Todo.Repo
  def mount(_params, _session, socket) do
    form_list =
    Todo_Form
    |> Repo.all()
    socket = stream(socket, :todo_forms, form_list)
    {:ok, socket}
  end
  def handle_event("delete", %{"id" => id}, socket) do
    todo_forms = Repo.get!(Todo_Form, id)
    # {:ok, _} = Repo.delete(todo_forms)
    # {:noreply, stream_delete(socket, :todo_forms, todo_forms)}

    case Repo.delete(todo_forms) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Deleted successfully")
         |> stream_delete(:todo_forms, todo_forms)}

        {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

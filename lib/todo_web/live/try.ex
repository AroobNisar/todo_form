defmodule TodoWeb.Live.Try do
  alias Todo.Todo_Form
  import TodoWeb.CoreComponents
  import Ecto.Query, only: [from: 2]
  use TodoWeb, :live_view
  alias Todo.Repo
  def mount(_params, _session, socket) do
    query = from u in Todo_Form, where: is_nil(u.age)
    form_list = Repo.all(query)
    socket = stream(socket, :todo_forms, form_list)
    {:ok, socket}
  end
  def handle_event("delete", %{"iddddd" => id}, socket) do
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

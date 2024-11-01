defmodule TodoWeb.Live.Show do
  alias Todo.Todo_Form
  use TodoWeb, :live_view
  import TodoWeb.CoreComponents
  alias Todo.Repo

  def handle_params(%{"id" => id}, _uri, socket) do
    todo_form = Repo.get!(Todo_Form, id)
    socket = assign(socket, todo_form: todo_form)
    {:noreply, socket}
  end
end

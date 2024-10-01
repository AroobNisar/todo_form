defmodule TodoWeb.Live.Edit do
  use TodoWeb, :live_view
  alias Todo.Repo
  #import TodoWeb.CoreComponents
  alias Todo.Todo_Form
  def mount(%{"id" => id}, _session, socket) do
    todo_form = Repo.get!(Todo_Form, id)
    form =
    Todo_Form.changeset(%Todo_Form{},%{})
    |> to_form()
    {:ok, assign(socket, form: form, todo_form: todo_form)}
  end

  def handle_event("validate-form", %{"title" => _title, "description" => _description, "status" => _status, "age" => _age}=todo_form_params, socket) do
    form =
      Todo_Form.changeset(socket.assigns.todo_form, todo_form_params)
      |> Map.put(:action, :validate)
      |> to_form()
    {:noreply, assign(socket, form: form)}
  end

  def handle_event("save-form", %{"title" => title, "description" => description, "status" => status, "age" => age}, socket) do
    status_bool = if status == "true", do: true, else: false
    todo_form_params = %{"title" => title, "description" => description, "status" => status_bool, "age" => age}
    changeset = Todo_Form.changeset(socket.assigns.todo_form, todo_form_params)
    socket =
      case Repo.update(changeset) do
        {:ok, %Todo_Form{} = todo_form} ->
          put_flash(socket, :info, "Product ID #{todo_form.id} updated!")
          |> push_navigate(to: ~p"/getdata/#{todo_form.id}/")

        {:error, %Ecto.Changeset{} = changeset} ->
          form = to_form(changeset)

          socket
          |> assign(form: form)
          |> put_flash(:error, "Invalid data!")
      end

    {:noreply, socket}
  end
end

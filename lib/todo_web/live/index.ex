defmodule TodoWeb.Live.Index do
  use TodoWeb, :live_view
  alias Todo.Repo
  import TodoWeb.CoreComponents
  alias Todo.Todo_Form

  def mount(_params, _session, socket) do
    changeset =
      Todo_Form.changeset(%Todo_Form{},%{})
      |> to_form()

    {:ok, assign(socket, changeset: changeset)}
  end

  def handle_event("validate", %{"title" => _title, "description" => _description, "status" => _status}=todo_form_params, socket) do
    changeset =
      Todo_Form.changeset(%Todo_Form{}, todo_form_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"title" => title, "description" => description, "status" => status}, socket) do
    status_bool = if status == "true", do: true, else: false
    todo_form_params = %{"title" => title, "description" => description, "status" => status_bool}
    changeset = Todo_Form.changeset(%Todo_Form{}, todo_form_params)
    case Repo.insert(changeset) do
      {:ok, _todo_form} ->
        {:noreply,
         socket
         |> put_flash(:info, "Form saved successfully")
         |> push_navigate(to: ~p"/todo")}  # Reset the form

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}  # Re-render form with errors
    end
  end

end

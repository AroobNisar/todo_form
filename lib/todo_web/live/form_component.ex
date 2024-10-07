defmodule TodoWeb.Live.FormComponent do
  use TodoWeb, :live_component
  alias Todo.Repo
  alias Todo.Test
  import TodoWeb.CoreComponents


  def update(assigns, socket) do
    changeset= Test.changeset(%Test{},%{})
    |> to_form()
    socket = socket |> assign(assigns)
    {:ok, assign(socket, changeset: changeset)|> IO.inspect()}
  end

  def handle_event("validate", %{"test"=>test_params}, socket) do
    changes= Test.changeset(%Test{},test_params)
    |> Map.put(:action, :validate)
    |> to_form()
    {:noreply, assign(socket, :changes, changes)}
  end

  def handle_event("save",  %{"test"=>test_params}, socket) do
    savedata(socket, socket.assigns.action, test_params)
  end

  defp savedata(socket, :new, test_params) do
    test= Test.changeset(%Test{},test_params)
    case Repo.insert(test) do
    {:ok, _test} ->
      {:noreply,
       socket
       |> put_flash(:info, "User created successfully")
       |> push_navigate(to: ~p"/user")}

    {:error, %Ecto.Changeset{} = changeset} ->
      {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp savedata(socket, :edit, test_params) do
    test= Test.changeset(socket.assigns.test,test_params)
    case Repo.update(test) do
    {:ok, _test} ->
      {:noreply,
       socket
       |> put_flash(:info, "Updated successfully")
       |> push_navigate(to: ~p"/user")}

    {:error, %Ecto.Changeset{} = changeset} ->
      {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

end

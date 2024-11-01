defmodule TodoWeb.Live.Edit do
  use TodoWeb, :live_view
  alias Todo.Repo
  alias Todo.Test
  import TodoWeb.CoreComponents


  def mount(%{"id"=>id}, _session, socket) do
    test= Repo.get!(Test,id)
    changeset= Test.changeset(%Test{},%{})
    |> to_form()
    {:ok, assign(socket, changeset: changeset, test: test)}
  end

  def handle_event("validate-edit", %{"test"=>test_params}, socket) do
    changes= Test.changeset(%Test{},test_params)
    |> Map.put(:action, :validate)
    |> to_form()
    {:noreply, assign(socket, :changes, changes)}
  end

  def handle_event("save-edit",  %{"test"=>test_params}, socket) do
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

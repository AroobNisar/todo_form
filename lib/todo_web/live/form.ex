defmodule TodoWeb.Live.Form do
  use TodoWeb, :live_view
  alias Todo.Repo
  alias Todo.Test
  import TodoWeb.CoreComponents


  def mount(_param, _session, socket) do
    changeset= Test.changeset(%Test{},%{})
    |> to_form()
    {:ok, assign(socket, :changeset, changeset)}
  end

  def handle_event("validate", %{"test"=>test_params}, socket) do
    changes= Test.changeset(%Test{},test_params)
    |> Map.put(:action, :validate)
    |> to_form()
    {:noreply, assign(socket, :changes, changes)}
  end

  def handle_event("save",  %{"test"=>test_params}, socket) do
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

end

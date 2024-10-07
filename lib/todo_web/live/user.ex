defmodule TodoWeb.Live.User do
  use TodoWeb, :live_view
  alias Todo.Repo
  alias Todo.Test

  def mount(_param, _session, socket) do
    user= Repo.all(Test)
    {:ok, assign(socket, :test, user)}
  end

  def handle_event("delete", %{"id"=>id}, socket) do
    test= Repo.get!(Test,id)
    case Repo.delete(test) do
      {:ok, _test}->
      {:noreply,
      socket
        |> put_flash(:info, "Deleted Successfully!")
        |> assign(:test, Enum.filter(Repo.all(Test), fn u-> u.id != id end))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: changeset)}
    end

  end

end

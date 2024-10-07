defmodule TodoWeb.Live.User do
  use TodoWeb, :live_view
  alias Todo.Repo
  alias Todo.Test

  def mount(_param, _session, socket) do
    test= Repo.all(Test)
    {:ok, assign(socket, :tests, test)}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Test")
    |> assign(:test, %Test{})
  end

  defp apply_action(socket, :edit, %{"id"=>id}) do
    socket
    |> assign(:page_title, "edit Test")
    |> assign(:test, Repo.get!(Test,id))
  end

  defp apply_action(socket, :user, _params) do
    socket
    |> assign(:page_title, "Listing Tests")
    |> assign(:test, nil)
  end

  def handle_info({TodoWeb.Live.FormComponent, {:saved, test}}, socket) do
    tests = [test | socket.assigns.test]
    |> Enum.uniq_by(& &1.id)
    {:noreply, assign(socket, :tests, tests)}
  end

  def handle_event("delete", %{"id"=>id}, socket) do
    test= Repo.get!(Test,id)
    case Repo.delete(test) do
      {:ok, _test}->
      {:noreply,
      socket
        |> put_flash(:info, "Deleted Successfully!")
        |> assign(:tests, Enum.filter(Repo.all(Test), fn u -> u.id != id end))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: changeset)}
    end

  end

end

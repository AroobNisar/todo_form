defmodule TodoWeb.Live.Show do
  use TodoWeb, :live_view
  alias Todo.Repo
  alias Todo.Test

  def handle_params(%{"id"=>id}, _session, socket) do
    changeset= Repo.get!(Test,id)
    {:noreply, assign(socket, :test, changeset)}
  end
end

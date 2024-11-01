defmodule Todo.Workers.Basic do
  use Oban.Worker, queue: :default
  alias Todo.Posts.Post
  alias Todo.Repo
  import Ecto.Query

  @impl Oban.Worker
  def perform(%Oban.Job{scheduled_at: scheduled_at}) do
    IO.inspect(scheduled_at, label: "hyyy")
scheduled_at = DateTime.add(scheduled_at, -15, :minute)
   Repo.delete_all(from(p in Post, where: (p.status == :archeived) and (p.updated_at <= ^scheduled_at) )) |> IO.inspect()
    :ok
  end
end

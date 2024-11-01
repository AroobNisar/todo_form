defmodule TodoWeb.PostLive.Index do
  use TodoWeb, :live_view

  alias Todo.Posts
  alias Todo.Repo
  alias Todo.Posts.Post
  import Ecto.Query

  @impl true
  def mount(_params, _session, socket) do
    posts = Repo.all(from(p in Post, limit: 10, offset: 0))
    total_pages = Enum.count(Repo.all(Post)) / 10 |> ceil()
    {:ok, assign(socket, posts: posts, offset: nil, page_number: 1, total_pages: total_pages)}
  end

  @impl true
  def handle_params(%{"page" => %{"page" => page_number}} = params, _url, socket)  do
    page_number = page_number |> String.to_integer()
    offset = 10 * (page_number - 1)
    total_pages = Enum.count(Repo.all(Post)) / 10 |> ceil()
    posts = Repo.all(from(p in Post, limit: 10, offset: ^offset))
    {:noreply,
    socket
    |> assign(:posts, posts)
    |> assign(:page_number, page_number)
    |> assign(:total_pages, total_pages)
    |> apply_action(socket.assigns.live_action, params)}
  end

  def handle_params(%{} = params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def handle_params(%{"id"=> _id} = params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, Posts.get_post!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Posts")
    |> assign(:post, nil)
  end

  @impl true
  def handle_info({TodoWeb.PostLive.FormComponent, {:saved, post}}, socket) do
    posts = [post | socket.assigns.posts]
    |> Enum.uniq_by(& &1.id)
    total_pages = Enum.count(Repo.all(Post)) / 10 |> ceil()
    {:noreply, assign(socket, :posts, posts) |> assign(:total_pages, total_pages)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Posts.get_post!(id)
    {:ok, _} = Posts.delete_post(post)
    total_pages = Enum.count(Enum.filter(socket.assigns.posts, fn u -> u.id != id end)) / 10 |> ceil()
    updated_posts = Enum.filter(socket.assigns.posts, fn u -> u.id != id end)
    {:noreply, assign(socket, :posts, updated_posts) |> assign(:total_pages, total_pages)}
  end
end

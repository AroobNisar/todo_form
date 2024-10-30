defmodule TodoWeb.PageController do
  use TodoWeb, :controller
  alias Todo.Posts

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def create(conn, %{"post"=>params}) do
    Posts.create_post(params)
    redirect(conn, to: ~p"/posts")
  end
end

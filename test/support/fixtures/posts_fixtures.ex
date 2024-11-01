defmodule Todo.PostsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Todo.Posts` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        author: "some author",
        name: "some name"
      })
      |> Todo.Posts.create_post()

    post
  end
end

defmodule Todo.GallariesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Todo.Gallaries` context.
  """

  @doc """
  Generate a gallary.
  """
  def gallary_fixture(attrs \\ %{}) do
    {:ok, gallary} =
      attrs
      |> Enum.into(%{
        author: "some author",
        image: "some image",
        name: "some name"
      })
      |> Todo.Gallaries.create_gallary()

    gallary
  end
end

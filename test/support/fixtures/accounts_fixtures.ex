defmodule Todo.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Todo.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        description: "some description",
        status: true,
        title: "some title"
      })
      |> Todo.Accounts.create_user()

    user
  end
end

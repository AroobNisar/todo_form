defmodule Todo.Gallaries do
  @moduledoc """
  The Gallaries context.
  """

  import Ecto.Query, warn: false
  alias Todo.Repo

  alias Todo.Gallaries.Gallary

  @doc """
  Returns the list of gallaries.

  ## Examples

      iex> list_gallaries()
      [%Gallary{}, ...]

  """
  def list_gallaries do
    Repo.all(Gallary)
  end

  @doc """
  Gets a single gallary.

  Raises `Ecto.NoResultsError` if the Gallary does not exist.

  ## Examples

      iex> get_gallary!(123)
      %Gallary{}

      iex> get_gallary!(456)
      ** (Ecto.NoResultsError)

  """
  def get_gallary!(id), do: Repo.get!(Gallary, id)

  @doc """
  Creates a gallary.

  ## Examples

      iex> create_gallary(%{field: value})
      {:ok, %Gallary{}}

      iex> create_gallary(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_gallary(attrs \\ %{}) do
    %Gallary{}
    |> Gallary.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a gallary.

  ## Examples

      iex> update_gallary(gallary, %{field: new_value})
      {:ok, %Gallary{}}

      iex> update_gallary(gallary, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_gallary(%Gallary{} = gallary, attrs) do
    gallary
    |> Gallary.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a gallary.

  ## Examples

      iex> delete_gallary(gallary)
      {:ok, %Gallary{}}

      iex> delete_gallary(gallary)
      {:error, %Ecto.Changeset{}}

  """
  def delete_gallary(%Gallary{} = gallary) do
    Repo.delete(gallary)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking gallary changes.

  ## Examples

      iex> change_gallary(gallary)
      %Ecto.Changeset{data: %Gallary{}}

  """
  def change_gallary(%Gallary{} = gallary, attrs \\ %{}) do
    Gallary.changeset(gallary, attrs)
  end
end

defmodule Todo.GallariesTest do
  use Todo.DataCase

  alias Todo.Gallaries

  describe "gallaries" do
    alias Todo.Gallaries.Gallary

    import Todo.GallariesFixtures

    @invalid_attrs %{name: nil, author: nil, image: nil}

    test "list_gallaries/0 returns all gallaries" do
      gallary = gallary_fixture()
      assert Gallaries.list_gallaries() == [gallary]
    end

    test "get_gallary!/1 returns the gallary with given id" do
      gallary = gallary_fixture()
      assert Gallaries.get_gallary!(gallary.id) == gallary
    end

    test "create_gallary/1 with valid data creates a gallary" do
      valid_attrs = %{name: "some name", author: "some author", image: "some image"}

      assert {:ok, %Gallary{} = gallary} = Gallaries.create_gallary(valid_attrs)
      assert gallary.name == "some name"
      assert gallary.author == "some author"
      assert gallary.image == "some image"
    end

    test "create_gallary/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Gallaries.create_gallary(@invalid_attrs)
    end

    test "update_gallary/2 with valid data updates the gallary" do
      gallary = gallary_fixture()
      update_attrs = %{name: "some updated name", author: "some updated author", image: "some updated image"}

      assert {:ok, %Gallary{} = gallary} = Gallaries.update_gallary(gallary, update_attrs)
      assert gallary.name == "some updated name"
      assert gallary.author == "some updated author"
      assert gallary.image == "some updated image"
    end

    test "update_gallary/2 with invalid data returns error changeset" do
      gallary = gallary_fixture()
      assert {:error, %Ecto.Changeset{}} = Gallaries.update_gallary(gallary, @invalid_attrs)
      assert gallary == Gallaries.get_gallary!(gallary.id)
    end

    test "delete_gallary/1 deletes the gallary" do
      gallary = gallary_fixture()
      assert {:ok, %Gallary{}} = Gallaries.delete_gallary(gallary)
      assert_raise Ecto.NoResultsError, fn -> Gallaries.get_gallary!(gallary.id) end
    end

    test "change_gallary/1 returns a gallary changeset" do
      gallary = gallary_fixture()
      assert %Ecto.Changeset{} = Gallaries.change_gallary(gallary)
    end
  end
end

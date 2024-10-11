defmodule TodoWeb.GallaryLiveTest do
  use TodoWeb.ConnCase

  import Phoenix.LiveViewTest
  import Todo.GallariesFixtures

  @create_attrs %{name: "some name", author: "some author", image: "some image"}
  @update_attrs %{name: "some updated name", author: "some updated author", image: "some updated image"}
  @invalid_attrs %{name: nil, author: nil, image: nil}

  defp create_gallary(_) do
    gallary = gallary_fixture()
    %{gallary: gallary}
  end

  describe "Index" do
    setup [:create_gallary]

    test "lists all gallaries", %{conn: conn, gallary: gallary} do
      {:ok, _index_live, html} = live(conn, ~p"/gallaries")

      assert html =~ "Listing Gallaries"
      assert html =~ gallary.name
    end

    test "saves new gallary", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/gallaries")

      assert index_live |> element("a", "New Gallary") |> render_click() =~
               "New Gallary"

      assert_patch(index_live, ~p"/gallaries/new")

      assert index_live
             |> form("#gallary-form", gallary: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#gallary-form", gallary: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/gallaries")

      html = render(index_live)
      assert html =~ "Gallary created successfully"
      assert html =~ "some name"
    end

    test "updates gallary in listing", %{conn: conn, gallary: gallary} do
      {:ok, index_live, _html} = live(conn, ~p"/gallaries")

      assert index_live |> element("#gallaries-#{gallary.id} a", "Edit") |> render_click() =~
               "Edit Gallary"

      assert_patch(index_live, ~p"/gallaries/#{gallary}/edit")

      assert index_live
             |> form("#gallary-form", gallary: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#gallary-form", gallary: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/gallaries")

      html = render(index_live)
      assert html =~ "Gallary updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes gallary in listing", %{conn: conn, gallary: gallary} do
      {:ok, index_live, _html} = live(conn, ~p"/gallaries")

      assert index_live |> element("#gallaries-#{gallary.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#gallaries-#{gallary.id}")
    end
  end

  describe "Show" do
    setup [:create_gallary]

    test "displays gallary", %{conn: conn, gallary: gallary} do
      {:ok, _show_live, html} = live(conn, ~p"/gallaries/#{gallary}")

      assert html =~ "Show Gallary"
      assert html =~ gallary.name
    end

    test "updates gallary within modal", %{conn: conn, gallary: gallary} do
      {:ok, show_live, _html} = live(conn, ~p"/gallaries/#{gallary}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Gallary"

      assert_patch(show_live, ~p"/gallaries/#{gallary}/show/edit")

      assert show_live
             |> form("#gallary-form", gallary: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#gallary-form", gallary: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/gallaries/#{gallary}")

      html = render(show_live)
      assert html =~ "Gallary updated successfully"
      assert html =~ "some updated name"
    end
  end
end

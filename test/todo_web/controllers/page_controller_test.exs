defmodule TodoWeb.PageControllerTest do
  use TodoWeb.ConnCase

  alias Todo.Repo
  alias Todo.Tasks
  alias Todo.Tasks.Task

  @valid_attrs %{title: "Test Task", description: "A task to test"}
  @invalid_attrs %{title: nil, description: nil}

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Peace of mind from prototype to production"
  end

  describe "GET /tasks" do
    test "renders the index page", %{conn: conn} do
      conn = get(conn, TodoWeb.Router.Helpers.page_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Tasks"
    end
  end

  describe "GET /tasks/new" do
    test "renders the new task form", %{conn: conn} do
      conn = get(conn, TodoWeb.Router.Helpers.page_path(conn, :new))
      assert html_response(conn, 200) =~ "Create a New Task"
    end
  end

  describe "POST /tasks" do
    test "creates a task with valid data", %{conn: conn} do
      conn = post(conn, TodoWeb.Router.Helpers.page_path(conn, :create), task: @valid_attrs)
      assert redirected_to(conn) == TodoWeb.Router.Helpers.page_path(conn, :index)
    end

    test "does not create a task with invalid data", %{conn: conn} do
      conn = post(conn, TodoWeb.Router.Helpers.page_path(conn, :create), task: @invalid_attrs)
      assert html_response(conn, 200) =~ "Something went wrong!"
    end
  end

  describe "GET /tasks/:id/edit" do
    test "renders the edit form for a task", %{conn: conn} do
      {:ok, task} = Tasks.create_task(@valid_attrs)
      conn = get(conn, TodoWeb.Router.Helpers.page_path(conn, :edit, task.id))
      assert html_response(conn, 200) =~ "Edit Task"
    end
  end

  describe "GET /tasks/:id" do
    test "renders the show page for a task", %{conn: conn} do
      {:ok, task} = Tasks.create_task(@valid_attrs)
      conn = get(conn, TodoWeb.Router.Helpers.page_path(conn, :show, task.id))
      assert html_response(conn, 200) =~ "Task Details"
    end
  end

  describe "PUT /tasks/:id" do
    test "updates a task with valid data", %{conn: conn} do
      {:ok, task} = Tasks.create_task(@valid_attrs)

      conn =
        put(conn, TodoWeb.Router.Helpers.page_path(conn, :update, task.id),
          task: %{title: "Updated Task"}
        )

      assert redirected_to(conn) == TodoWeb.Router.Helpers.page_path(conn, :index)
    end

    test "does not update a task with invalid data", %{conn: conn} do
      {:ok, task} = Tasks.create_task(@valid_attrs)

      conn =
        put(conn, TodoWeb.Router.Helpers.page_path(conn, :update, task.id), task: @invalid_attrs)

      assert html_response(conn, 200) =~ "Something went wrong!"
    end
  end

  describe "DELETE /tasks/:id" do
    test "deletes a task", %{conn: conn} do
      {:ok, task} = Tasks.create_task(@valid_attrs)

      conn = delete(conn, TodoWeb.Router.Helpers.page_path(conn, :delete, task.id))
      assert redirected_to(conn) == TodoWeb.Router.Helpers.page_path(conn, :index)
      refute Repo.get(Task, task.id)
    end
  end
end

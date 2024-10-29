defmodule TodoWeb.BookLive.Index do
  use TodoWeb, :live_view
  alias Todo.Repo
  alias Todo.Books
  alias Todo.Books.Book

  @impl true
  def mount(params, _session, socket) do
    books = Repo.paginate(Book, params).entries
    total_pages = Repo.paginate(Book, params).total_pages
    page_number = Repo.paginate(Book, params).page_number
    total_entries = Repo.paginate(Book, params).total_entries
    page_size = Repo.paginate(Book, params).page_size

    {:ok,
     socket
     |> assign(:books, books)
     |> assign(:total_pages, total_pages)
     |> assign(:page_number, page_number)
     |> assign(:total_entries, total_entries)
     |> assign(:page_size, page_size)}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    books = Repo.paginate(Book, params).entries
    total_pages = Repo.paginate(Book, params).total_pages
    page_number = Repo.paginate(Book, params).page_number
    total_entries = Repo.paginate(Book, params).total_entries
    page_size = Repo.paginate(Book, params).page_size

    {:noreply,
     socket
     |> assign(:books, books)
     |> assign(:total_pages, total_pages)
     |> assign(:page_number, page_number)
     |> assign(:total_entries, total_entries)
     |> assign(:page_size, page_size)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Book")
    |> assign(:book, Books.get_book!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Book")
    |> assign(:book, %Book{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Books")
    |> assign(:book, Repo.paginate(Book).entries)
  end

  @impl true
  def handle_info({TodoWeb.BookLive.FormComponent, {:saved, book}}, socket) do
    books =
      [book | socket.assigns.book]
      |> Enum.uniq_by(& &1.id)

    {:noreply, assign(socket, :books, books)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    book = Books.get_book!(id)

    case Repo.delete(book) do
      {:ok, _book} ->
        {:noreply,
         socket
         |> put_flash(:info, "Deleted Successfully!")
         |> assign(:books, %Scrivener.Page{
           page_number: socket.assigns.page_number,
           page_size: socket.assigns.page_size,
           total_entries: socket.assigns.total_entries,
           total_pages: socket.assigns.total_pages,
           entries: Enum.filter(Repo.paginate(Book).entries, fn u -> u.id != id end)
         })}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: changeset)}
    end
  end
end

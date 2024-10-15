defmodule TodoWeb.GallaryLive.Index do
  use TodoWeb, :live_view
  alias Todo.Gallaries.Filter
  alias Todo.Gallaries
  alias Todo.Gallaries.Gallary
  alias Todo.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :gallaries, Gallaries.list_gallaries())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Gallary")
    |> assign(:gallary, Gallaries.get_gallary!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Gallary")
    |> assign(:gallary, %Gallary{})
  end

  defp apply_action(socket, :index, params) do
    IO.inspect(Map.get(socket.assigns, :filter), label: "checkfinsocket")
    filter = Repo.get_by(Filter, page: "gallery") || %Filter{} |> IO.inspect(label: "seeehereerer")
    socket
    |> assign(:filter, filter)
    |> assign(:page_title, "Listing Gallaries")
  end

  defp apply_action(socket, :filter, params) do
    filter = Repo.get_by(Filter, page: "gallery") || %Filter{}
    options_list = ["name", "image", "author"]
    socket
    |> assign(:page_title, "Filtering Gallaries")
    |> assign(:filter, filter)
    |> assign(:options, options_list)
  end

  def handle_info({:hello, gallary}, socket) do
    {:noreply, socket}
    # {:noreply, assign(socket, :filter, gallary)}
  end

  @impl true
  def handle_info({TodoWeb.GallaryLive.FormComponent, {:saved, gallary}}, socket) do
    {:noreply, stream_insert(socket, :gallaries, gallary)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    gallary = Gallaries.get_gallary!(id)
    {:ok, _} = Gallaries.delete_gallary(gallary)

    {:noreply, stream_delete(socket, :gallaries, gallary)}
  end

  # @impl true
  # def handle_event("valid", params, socket) do
  #   list = Enum.map(params, fn {key, value} ->
  #     if is_binary(value) && String.to_atom(value) == true do
  #       key
  #     end
  #   end) |> IO.inspect()
  #   changes = Enum.filter(list, & &1) |> IO.inspect()
  #   changeset = Filter.changeset(socket.assigns.filter, %{page: Map.get(params, "page"),options: changes})|> IO.inspect()

  #   {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  # end

  # def handle_event("filter", params, socket) do
  #   page = Map.get(params, "page")
  #   selected_options = Enum.filter(params, fn {key, value} ->
  #     value == "true" && key != "page"
  #   end) |> Enum.map(fn {key, _} -> key end)

  #   filter = Repo.get_by(Filter, page: page) || %Filter{}
  #   changeset = Filter.changeset(filter, %{page: page, options: selected_options})

  #   case Repo.insert_or_update(changeset) do
  #     {:ok, _filter} ->
  #       gallary_data = fetch_gallary_data(selected_options)
  #       {:noreply,
  #        socket
  #        |> assign(:gallary_data, gallary_data)
  #        |> put_flash(:info, "Filter saved successfully")
  #        |> push_patch(to: ~p"/")}

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       {:noreply, assign(socket, form: to_form(changeset))}
  #   end
  # end

  # def handle_event("filter", params, socket) do
  #   list = Enum.map(params, fn {key, value} ->
  #     if is_binary(value) && String.to_atom(value) == true do
  #       key
  #     end
  #   end) |> IO.inspect()
  #   changes = Enum.filter(list, & &1) |> IO.inspect()
  #   filter = Repo.get_by(Filter, page: Map.get(params, "page")) || %Filter{}
  #   changeset = Filter.changeset(filter, %{page: Map.get(params, "page"),options: changes})|> IO.inspect()
  #   query = from(g in Gallary, select: map(g, ^changes))
  #   gallary_data=Repo.all(query)
  #   case Repo.insert(changeset) do
  #     {:ok, _gallary} ->
  #       {:noreply,
  #        socket
  #         |> assign(:gallary_data, gallary_data)
  #        |> put_flash(:info, "Gallary created successfully")
  #        |> push_patch(to: ~p"/")}

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       {:noreply, assign(socket, form: to_form(changeset))}
  #   end
  # end
end

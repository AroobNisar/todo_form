defmodule TodoWeb.GallaryLive.FilterComponent do
  use TodoWeb, :live_component
  import Phoenix.Component
  alias Todo.Gallaries.Filter
  alias Todo.Repo

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to filter gallary records in your database.</:subtitle>
      </.header>
      <.simple_form
        :let={f}
        for={@form}
        id={"#{@filter.id || :new}"}
        phx-submit="filter"
        phx-target={@myself}
      >
        <.input type="text" field={f[:page]} label="Page" />
        <%= for option <- @options do %>
          <.input type="checkbox" field={f[:options]} name={option} value={option} label={option} id={option} checked={option in @filter.options}  />
        <% end %>
        <:actions>
          <.button phx-disable-with="Saving...">Save Gallary</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{filter: filter} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Filter.changeset(filter, %{}))
     end)}
  end

  # @impl true
  # def handle_event("valid", params, socket) do
  #   list =
  #     Enum.map(params, fn {key, value} ->
  #       if is_binary(value) && String.to_atom(value) == true do
  #         key
  #       end
  #     end)
  #     |> IO.inspect()

  #   changes = Enum.filter(list, & &1) |> IO.inspect()

  #   changeset =
  #     Filter.changeset(socket.assigns.filter, %{page: "gallery", options: changes})
  #     |> IO.inspect()

  #   {:noreply, socket}
  # end

  def handle_event("filter", params, socket) do
    list =
      Enum.map(params, fn {key, value} ->
        if is_binary(value) && String.to_atom(value) == true do
          key
        end
      end)

    changes = Enum.filter(list, & &1)

    changeset =
      Filter.changeset(socket.assigns.filter, %{page: "gallery", options: changes})

    case Repo.insert_or_update(changeset) do
      {:ok, gallary} ->
        send(self(), {:hello, gallary})
        {:noreply,
         socket
         |> put_flash(:info, "Gallary Filtered")
         |> push_navigate(to: "/")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end

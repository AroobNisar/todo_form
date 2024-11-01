defmodule TodoWeb.GalleryLive.FormComponent do
  use TodoWeb, :live_component

  alias Todo.Galleries

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage gallery records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="gallery-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:author]} type="text" label="Author" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Gallery</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{gallery: gallery} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Galleries.change_gallery(gallery))
     end)}
  end

  @impl true
  def handle_event("validate", %{"gallery" => gallery_params}, socket) do
    changeset = Galleries.change_gallery(socket.assigns.gallery, gallery_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"gallery" => gallery_params}, socket) do
    save_gallery(socket, socket.assigns.action, gallery_params)
  end

  defp save_gallery(socket, :edit, gallery_params) do
    case Galleries.update_gallery(socket.assigns.gallery, gallery_params) do
      {:ok, gallery} ->
        notify_parent({:saved, gallery})

        {:noreply,
         socket
         |> put_flash(:info, "Gallery updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_gallery(socket, :new, gallery_params) do
    case Galleries.create_gallery(gallery_params) do
      {:ok, gallery} ->
        notify_parent({:saved, gallery})

        {:noreply,
         socket
         |> put_flash(:info, "Gallery created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

defmodule TodoWeb.GallaryLive.FormComponent do
  use TodoWeb, :live_component
  import Phoenix.Component
  alias Todo.Gallaries

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage gallary records in your database.</:subtitle>
      </.header>
      <.simple_form
        for={@form}
        id="gallary-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:author]} type="text" label="Author" />
        <div>
          <label>Image</label>
          <.live_file_input upload={@uploads.image} />
          <%= for entry <- @uploads.image.entries do %>
            <.live_img_preview entry={entry} width="75" />
            <progress value={@upload_progress} max="100"><%= @upload_progress %>%</progress>
            <.button
              type="submit"
              phx-click="cancel-upload"
              phx-target={@myself}
              phx-value-ref={entry.ref}
            >
              Cancel
            </.button>
          <% end %>
        </div>

        <:actions>
          <.button phx-disable-with="Saving...">Save Gallary</.button>
        </:actions>
      </.simple_form>

    </div>
    """
  end

  @impl true
  def update(%{gallary: gallary} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Gallaries.change_gallary(gallary))
     end)
     |> assign(:uploaded_files, [])
     |> assign(:upload_progress, 0)
     |> allow_upload(:image, accept: :any, max_entries: 1, progress: &handle_progress/3)}
  end

  defp handle_progress(:image, entry, socket) do
    IO.inspect(entry, label: "See entry")
    progress = entry.progress
    socket = assign(socket, :upload_progress, progress)

    if entry.done? do
      {:noreply,
       socket
       |> put_flash(:info, "File uploaded successfully")}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :image, ref)}
  end

  @impl true
  def handle_event("validate", %{"gallary" => gallary_params}, socket) do
    changeset = Gallaries.change_gallary(socket.assigns.gallary, gallary_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"gallary" => gallary_params}, socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :image, fn %{path: path}, _entry ->
        dest = Path.join([:code.priv_dir(:todo), "static", "uploads", Path.basename(path)])
        File.cp!(path, dest)
        {:ok, "/uploads/" <> Path.basename(dest)}
      end)

    new_gallary_params = Map.put(gallary_params, "image", List.first(uploaded_files))
    {:noreply, update(socket, :uploaded_files, &(&1 ++ uploaded_files))}
    save_gallary(socket, socket.assigns.action, new_gallary_params)
  end

  defp save_gallary(socket, :edit, gallary_params) do
    case Gallaries.update_gallary(socket.assigns.gallary, gallary_params) do
      {:ok, gallary} ->
        notify_parent({:saved, gallary})

        {:noreply,
         socket
         |> put_flash(:info, "Gallary updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_gallary(socket, :new, gallary_params) do
    case Gallaries.create_gallary(gallary_params) do
      {:ok, gallary} ->
        notify_parent({:saved, gallary})

        {:noreply,
         socket
         |> put_flash(:info, "Gallary created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

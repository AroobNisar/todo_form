defmodule TodoWeb.Live.Index do
  @moduledoc false
  use TodoWeb, :live_view

  alias Todo.Workers.TextConversion

  @impl true
  def mount(_params, _session, socket) do
    live_pid = inspect(self())
    topic = "job_updates:#{live_pid}"

    # Subscribe to the PubSub topic
    Phoenix.PubSub.subscribe(Todo.PubSub, topic)

    {:ok,
     socket
     |> allow_upload(:file, accept: ~w(.pdf), max_entries: 1)
     |> assign(pdf_data: nil, error_message: nil)}
  end

  @impl true
  def handle_event("validate_upload", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("upload_file", _file_params, socket) do
    uploaded_file_path =
      socket
      |> consume_uploaded_entries(:file, fn %{path: temp_path}, _entry ->
        target_path = Path.join([:code.priv_dir(:todo), "uploads", Path.basename(temp_path)])
        File.cp!(temp_path, target_path)
        {:ok, target_path}
      end)
      |> List.first()

    if uploaded_file_path do
      # Generate a unique job ID and pass to Oban
      job_args = %{"pdf_file" => uploaded_file_path, "live_pid" => inspect(self())}

      # Enqueue the Oban job to process the file asynchronously
      case Oban.insert(TextConversion.new(job_args)) do
        {:ok, _job} ->
          {:noreply, assign(socket, :error_message, nil)}

        {:error, _reason} ->
          {:noreply, assign(socket, :error_message, "Failed to enqueue the job")}
      end
    else
      {:noreply, assign(socket, :error_message, "No file uploaded or invalid path.")}
    end
  end

  @impl true
  def handle_info({:DOWN, _pid, _reason, _info}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info({:text_extracted, pdf_data}, socket) do
    {:noreply, assign(socket, :pdf_data, pdf_data)}
  end

  @impl true
  def handle_info({:error, message}, socket) do
    {:noreply, assign(socket, :error_message, message)}
  end
end

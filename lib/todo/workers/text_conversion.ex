defmodule Todo.Workers.TextConversion do
  @moduledoc false
  use Oban.Worker, queue: :default, max_attempts: 1

  alias Phoenix.PubSub

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"pdf_file" => pdf_file, "live_pid" => live_pid}}) do
    topic = "job_updates:#{live_pid}"

    case extract_text_from_pdf(pdf_file) do
      {:ok, text_data} ->
        # Broadcast the extracted text to the LiveView process
        PubSub.broadcast(Todo.PubSub, topic, {:text_extracted, text_data})
        :ok

      {:error, reason} ->
        PubSub.broadcast(Todo.PubSub, topic, {:error, reason})
        :discard
    end
  end

  defp extract_text_from_pdf(pdf_file) do
    if File.exists?(pdf_file) do
      case System.cmd("pdftotext", ["-layout", pdf_file, "-"]) do
        {text_data, 0} -> {:ok, text_data}
        {_, _} -> {:error, "Failed to extract text from the PDF"}
      end
    else
      {:error, "PDF file not found"}
    end
  end
end

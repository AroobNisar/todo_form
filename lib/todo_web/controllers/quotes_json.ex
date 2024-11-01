defmodule  TodoWeb.QuoteJSON do
  alias Todo.Quotes.Quote

  def index(%{quotes: quotes}) do
    %{data: for(quote<-quotes, do: data(quote))}
  end

  def show(%{quote: quote}) do
    %{data: data(quote)}
  end

  defp data(%Quote{}=datam) do
    %{
      name: datam.name,
      hobby: datam.hobby
     }
  end
end

defmodule TodoWeb.QuotesJSON do
	alias Todo.Quotes.Quote

	def index(%{quotes: quotes}) do
		%{data: for(quote <- quotes, do: data(quote))}
	end

	def show(%{quote: quote}) do
		%{data: data(quote)}
	end

	def view(%{quote: quote}) do
		 %{data: data(quote)}
	end

	defp data(%Quote{} = datum) do
		%{
			quote: datum.quote,
			author: datum.author,
			source: datum.source
		}
	end
end

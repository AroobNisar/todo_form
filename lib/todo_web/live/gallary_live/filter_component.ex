defmodule TodoWeb.GallaryLive.FilterComponent do
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
     end)}
  end

end

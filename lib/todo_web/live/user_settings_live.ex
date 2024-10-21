defmodule TodoWeb.UserSettingsLive do
  use TodoWeb, :live_view

  alias Todo.Accounts

  def render(assigns) do
    ~H"""
    <.header class="text-center">
      Account Settings
      <:subtitle>Manage your account email address and password settings</:subtitle>
    </.header>

    <div class="space-y-12 divide-y">
      <div>
        <.simple_form
          for={@email_form}
          id="email_form"
          phx-submit="update_email"
          phx-change="validate_email"
        >
          <.input field={@email_form[:email]} type="email" label="Email" required />
          <.input
            field={@email_form[:current_password]}
            name="current_password"
            id="current_password_for_email"
            type="password"
            label="Current password"
            value={@email_form_current_password}
            required
          />
          <:actions>
            <.button phx-disable-with="Changing...">Change Email</.button>
          </:actions>
        </.simple_form>
      </div>
      <div>
        <.simple_form
          for={@password_form}
          id="password_form"
          action={~p"/users/log_in?_action=password_updated"}
          method="post"
          phx-change="validate_password"
          phx-submit="update_password"
          phx-trigger-action={@trigger_submit}
        >
          <input
            name={@password_form[:email].name}
            type="hidden"
            id="hidden_user_email"
            value={@current_email}
          />
          <.input field={@password_form[:password]} type="password" label="New password" required />
          <.input
            field={@password_form[:password_confirmation]}
            type="password"
            label="Confirm new password"
          />
          <.input
            field={@password_form[:current_password]}
            name="current_password"
            type="password"
            label="Current password"
            id="current_password_for_password"
            value={@current_password}
            required
          />
          <:actions>
            <.button phx-disable-with="Changing...">Change Password</.button>
          </:actions>
        </.simple_form>
      </div>
      <div>
        <.simple_form for={@time_form} id="time_form" phx-submit="update_date_time">
          <.input
            type="select"
            name="time_zone"
            options={@time_zone_list}
            value={@selected_time_zone}
            label="Time Zone"
            field={@time_form[:time_zone]}
            class="mt-2 block w-full rounded-md border border-gray-300 bg-white shadow-sm focus:border-zinc-400 focus:ring-0 sm:text-sm"
          />
          <.input
            type="select"
            name="time_format"
            options={@time_format_list}
            value={@selected_time_format}
            label="Time Format"
            field={@time_form[:time_format]}
            class="mt-2 block w-full rounded-md border border-gray-300 bg-white shadow-sm focus:border-zinc-400 focus:ring-0 sm:text-sm"
          />
          <.input
            type="select"
            name="date_format"
            options={@date_format_list}
            value={@selected_date_format}
            label="Date Format"
            field={@time_form[:date_format]}
            class="mt-2 block w-full rounded-md border border-gray-300 bg-white shadow-sm focus:border-zinc-400 focus:ring-0 sm:text-sm"
          />
          <:actions>
            <.button phx-disable-with="Setting...">Set Date & Time</.button>
          </:actions>
        </.simple_form>
      </div>

      <div>
        <h3>Current Date and Time</h3>
        <p>
          <%= format_date_time(@date_time, @selected_date_format, @selected_time_format) %>
        </p>
      </div>
    </div>
    """
  end

  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Accounts.update_user_email(socket.assigns.current_user, token) do
        :ok ->
          put_flash(socket, :info, "Email changed successfully.")

        :error ->
          put_flash(socket, :error, "Email change link is invalid or it has expired.")
      end

    {:ok, push_navigate(socket, to: ~p"/users/settings")}
  end

  def mount(_params, _session, socket) do
    time_zone_list = Tzdata.zone_list()

    date_format_list = [
      {"YYYY-MM-DD", "%Y-%m-%d"},
      {"DD/MM/YYYY", "%d/%m/%Y"},
      {"MM/DD/YYYY", "%m/%d/%Y"},
      {"Month Day, Year", "%B %d, %Y"},
      {"Day-Month-Year", "%d-%B-%Y"}
    ]

    time_format_list = [
      {"24-hours", "%H:%M"},
      {"12-hour (AM/PM)", "%I:%M %p"},
      {"12-hour (am/pm)", "%I:%M %P"}
    ]

    time_zone = socket.assigns.current_user.time_zone || "Etc/UTC"
    time_zone = if time_zone in [nil, ""], do: "Etc/UTC", else: time_zone
    time_format = socket.assigns.current_user.time_format
    date_format = socket.assigns.current_user.date_format
    {:ok, date_time} = DateTime.shift_zone(DateTime.utc_now(), time_zone)
    user = socket.assigns.current_user
    email_changeset = Accounts.change_user_email(user)
    password_changeset = Accounts.change_user_password(user)
    time_changeset = Accounts.change_user_time(user)

    socket =
      socket
      |> assign(:current_password, nil)
      |> assign(:email_form_current_password, nil)
      |> assign(:current_email, user.email)
      |> assign(:email_form, to_form(email_changeset))
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:time_form, to_form(time_changeset))
      |> assign(:trigger_submit, false)
      |> assign(:time_zone_list, time_zone_list)
      |> assign(:time_format_list, time_format_list)
      |> assign(:date_format_list, date_format_list)
      |> assign(:selected_time_zone, time_zone)
      |> assign(:selected_time_format, time_format)
      |> assign(:selected_date_format, date_format)
      |> assign(:date_time, date_time)

    {:ok, socket}
  end

  def handle_event("validate_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    email_form =
      socket.assigns.current_user
      |> Accounts.change_user_email(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, email_form: email_form, email_form_current_password: password)}
  end

  def handle_event("update_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_user_update_email_instructions(
          applied_user,
          user.email,
          &url(~p"/users/settings/confirm_email/#{&1}")
        )

        info = "A link to confirm your email change has been sent to the new address."
        {:noreply, socket |> put_flash(:info, info) |> assign(email_form_current_password: nil)}

      {:error, changeset} ->
        {:noreply, assign(socket, :email_form, to_form(Map.put(changeset, :action, :insert)))}
    end
  end

  def handle_event("validate_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    password_form =
      socket.assigns.current_user
      |> Accounts.change_user_password(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, password_form: password_form, current_password: password)}
  end

  def handle_event("update_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        password_form =
          user
          |> Accounts.change_user_password(user_params)
          |> to_form()

        {:noreply, assign(socket, trigger_submit: true, password_form: password_form)}

      {:error, changeset} ->
        {:noreply, assign(socket, password_form: to_form(changeset))}
    end
  end

  # def handle_event("validate_date_time", %{"time_form" => form_data}, socket) do

  #   date_format = form_data["date_format"]|> IO.inspect()
  #   date = Calendar.strftime(Date.utc_today(), date_format)|> IO.inspect()
  #   socket =
  #     socket
  #     |> assign(:date, date)

  #   {:noreply, socket}
  # end

  def handle_event("update_date_time", %{"date_format" => date_format, "time_format" => time_format, "time_zone" => time_zone} = form_data, socket) do
    time_zone  |> IO.inspect()
    time_format |> IO.inspect()
    date_format |> IO.inspect()
    {:ok, date_time} = DateTime.shift_zone(DateTime.utc_now(), time_zone)
    user = socket.assigns.current_user

    case Accounts.update_user_time(user, form_data) do
      {:ok, user} ->
        time_form =
          user
          |> Accounts.change_user_time(form_data)
          |> to_form()

        socket =
          socket
          |> assign(:selected_time_zone, time_zone)
          |> assign(:selected_time_format, time_format)
          |> assign(:selected_date_format, date_format)
          |> assign(:date_time, date_time)
          |> assign(:time_form, to_form(time_form))
          |> put_flash(:info, "selected")

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, password_form: to_form(changeset))}
    end
  end

  @spec format_date_time(map(), any(), any()) :: binary()
  def format_date_time(date_time, date_format, time_format) do
    format_string = "#{date_format} #{time_format}"
    Calendar.strftime(date_time, format_string)
  end
end

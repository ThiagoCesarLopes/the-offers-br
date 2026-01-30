defmodule TheoffersbrWeb.Admin.UsersLive do
  use TheoffersbrWeb, :live_view

  alias Theoffersbr.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, profiles: Accounts.list_profiles())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container">
      <h1 class="text-2xl font-semibold">Usuários</h1>
      <ul class="mt-4 space-y-2">
        <li :for={profile <- @profiles} class="rounded border p-3">
          <div class="font-medium"><%= profile.display_name || profile.email || profile.id %></div>
          <div class="text-xs text-gray-500">Associate ID: <%= profile.associate_id || "-" %></div>
        </li>
      </ul>
    </div>
    """
  end
end

defmodule TheOffersBrWeb.Associate.SocialAccountsLive do
  use TheOffersBrWeb, :live_view

  alias Theoffersbr.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, accounts: Accounts.list_associate_social_accounts())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container">
      <h1 class="text-2xl font-semibold">Contas Sociais</h1>
      <ul class="mt-4 space-y-2">
        <li :for={account <- @accounts} class="rounded border p-3">
          <div class="font-medium"><%= account.platform %></div>
          <div class="text-xs text-gray-500"><%= account.social_url || account.profile_url || "-" %></div>
        </li>
      </ul>
    </div>
    """
  end
end

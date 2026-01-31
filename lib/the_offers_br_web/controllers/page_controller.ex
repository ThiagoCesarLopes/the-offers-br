defmodule TheOffersBrWeb.PageController do
  use TheOffersBrWeb, :controller
  def home(conn, _params) do
    render(conn, :home)
  end
end

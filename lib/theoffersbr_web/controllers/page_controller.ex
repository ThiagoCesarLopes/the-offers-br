defmodule TheoffersbrWeb.PageController do
  use TheoffersbrWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end

defmodule TheoffersbrWeb.PageControllerTest do
  use TheoffersbrWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "The Offers Br"
  end
end

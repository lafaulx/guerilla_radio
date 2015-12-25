defmodule GuerillaRadio.PageController do
  use GuerillaRadio.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

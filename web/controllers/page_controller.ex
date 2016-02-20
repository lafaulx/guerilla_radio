defmodule GuerillaRadio.PageController do
  use GuerillaRadio.Web, :controller

  def index(conn, _) do
    render conn, "index.html"
  end
end

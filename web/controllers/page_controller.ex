defmodule GuerillaRadio.PageController do
  use GuerillaRadio.Web, :controller

  alias GuerillaRadio.Message

  def index(conn, params) do
    IO.puts params["broadcast"]
    messages = Repo.all(
      from message in Message,
      where: message.channel == ^params["broadcast"]
    )

    render conn, "index.html", messages: messages
  end
end

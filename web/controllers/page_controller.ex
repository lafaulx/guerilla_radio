defmodule GuerillaRadio.PageController do
  use GuerillaRadio.Web, :controller

  alias GuerillaRadio.Message

  def index(conn, params) do
    broadcast = params["broadcast"]

    messages = Repo.all(
      from message in Message,
      where: message.channel == ^broadcast
    )

    render conn, "index.html", [messages: messages, broadcast: broadcast]
  end
end

defmodule GuerillaRadio.MessageController do
  use GuerillaRadio.Web, :controller

  alias GuerillaRadio.Message

  def index(conn, params) do
    broadcast = params["broadcast"]

    messages = Repo.all(
      from message in Message,
      where: message.channel == ^broadcast and message.hidden == false,
      order_by: [desc: message.ts]
    )

    render(conn, "index.json", messages: messages)
  end
end

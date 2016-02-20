defmodule GuerillaRadio.MessageController do
  use GuerillaRadio.Web, :controller
  use Timex

  alias GuerillaRadio.Message

  @default_limit 10

  def index(conn, params) do
    broadcast = params["broadcast"]
    limit = Map.get(params, "limit", @default_limit)
    before = Map.get(params, "before", Date.now(:secs))

    messages = Repo.all(
      from message in Message,
      where: message.channel == ^broadcast and message.hidden == false and message.ts < ^before,
      order_by: [desc: message.ts],
      limit: ^limit
    )

    render(conn, "index.json", messages: messages)
  end
end

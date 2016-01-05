defmodule GuerillaRadio.MessageView do
  use GuerillaRadio.Web, :view

  def render("index.json", %{messages: messages}) do
    %{messages: render_many(messages, GuerillaRadio.MessageView, "message.json")}
  end

  def render("message.json", %{message: message}) do
    %{id: message.id,
      user: message.user,
      text: message.text,
      channel: message.channel,
      ts: message.ts}
  end
end

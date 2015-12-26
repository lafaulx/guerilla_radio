defmodule GuerillaRadio.SlackRtm do
  use Slack

  def init(initial_state, slack) do
    IO.puts "Connected as #{slack.me.name}"
    {:ok, initial_state}
  end

  def handle_message(message = %{type: "message", channel: channel_id}, slack, state) do
    # send_message(message_to_send, message.channel, slack)
    GuerillaRadio.Endpoint.broadcast! "broadcasts:" <> slack[:channels][channel_id][:name], "message_new", %{body: get_payload(message, slack)}

    {:ok, state}
  end

  def handle_message(_message, _slack, state) do
    {:ok, state}
  end

  defp get_payload(%{type: "message", user: user_id, ts: ts, text: text}, slack) do
    user_name = slack[:users][user_id][:real_name]
    %{type: "message", user: user_name, text: text, ts: ts}
  end
end
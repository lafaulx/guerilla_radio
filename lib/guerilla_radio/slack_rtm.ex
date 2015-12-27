defmodule GuerillaRadio.SlackRtm do
  use Slack

  alias GuerillaRadio.Message
  alias GuerillaRadio.Repo

  def init(initial_state, slack) do
    IO.puts "Connected as #{slack.me.name}"
    {:ok, initial_state}
  end

  def handle_message(message = %{type: "message", channel: channel_id}, slack, state) do
    # send_message(message_to_send, message.channel, slack)
    changeset = Message.changeset(%Message{}, convert_message_params(message, slack))

    case Repo.insert(changeset) do
      {:ok, message_model} ->
        GuerillaRadio.Endpoint.broadcast! "broadcasts:" <> slack[:channels][channel_id][:name], "message_new", %{body: message_model}
      {:error, _changeset} ->
        IO.puts "Error"
    end

    {:ok, state}
  end

  def handle_message(_message, _slack, state) do
    {:ok, state}
  end

  defp convert_message_params(%{type: "message", user: user_id, channel: channel_id, ts: ts, text: text}, slack) do
    user_name = slack[:users][user_id][:real_name]
    channel_name = slack[:channels][channel_id][:name]
    %{channel: channel_name, user: user_name, text: text, ts: ts}
  end
end
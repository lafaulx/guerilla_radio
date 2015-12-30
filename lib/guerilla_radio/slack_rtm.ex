defmodule GuerillaRadio.SlackRtm do
  use Slack

  alias GuerillaRadio.Message
  alias GuerillaRadio.Repo

  def init(initial_state, slack) do
    IO.puts "Connected as #{slack.me.name}"
    {:ok, initial_state}
  end

  def handle_message(%{type: "message", subtype: "message_changed", channel: channel_id, message: %{ts: ts, text: text}}, slack, state) do
    channel_name = slack[:channels][channel_id][:name]

    edited_message = Repo.get_by!(Message, %{channel: channel_name, ts: ts})
    changeset = Message.changeset(edited_message, %{text: text})

    case Repo.update(changeset) do
      {:ok, message_model} ->
        GuerillaRadio.Endpoint.broadcast! "broadcasts:" <> channel_name, "message_edit", %{body: message_model}
      {:error, _changeset} ->
        IO.puts "Error"
    end

    {:ok, state}
  end

  def handle_message(%{type: "message", subtype: "message_deleted", channel: channel_id, deleted_ts: deleted_ts}, slack, state) do
    channel_name = slack[:channels][channel_id][:name]

    edited_message = Repo.get_by!(Message, %{channel: channel_name, ts: deleted_ts})
    changeset = Message.changeset(edited_message, %{hidden: true})

    case Repo.update(changeset) do
      {:ok, message_model} ->
        GuerillaRadio.Endpoint.broadcast! "broadcasts:" <> channel_name, "message_delete", %{body: %{id: message_model.id}}
      {:error, _changeset} ->
        IO.puts "Error"
    end

    {:ok, state}
  end

  def handle_message(message = %{type: "message", channel: channel_id}, slack, state) do
    channel_name = slack[:channels][channel_id][:name]

    changeset = Message.changeset(%Message{}, convert_message_params(message, slack))

    case Repo.insert(changeset) do
      {:ok, message_model} ->
        GuerillaRadio.Endpoint.broadcast! "broadcasts:" <> channel_name, "message_new", %{body: message_model}
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
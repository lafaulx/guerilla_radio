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

    processed_text = convert_text_to_html(text)

    %{channel: channel_name, user: user_name, text: processed_text, ts: ts}
  end

  defp convert_text_to_html(text) do
    text
    |> convert_text_to_html(~r/(<https?:\/\/[a-z\S]+>)/i, &link_conversion_fn/1)
    |> convert_text_to_html(~r/(\*[^*]*\*)/i, &bold_conversion_fn/1)
    |> convert_text_to_html(~r/(\_[^_]*\_)/i, &italic_conversion_fn/1)
  end

  defp convert_text_to_html(text, replacement, conversion_fn) do
    iterate_and_replace(text, capture(text, replacement), conversion_fn)
  end

  defp capture(text, regexp) do
    List.flatten(Regex.scan(regexp, text, capture: :all_but_first))
  end

  defp iterate_and_replace(str, [], _) do
    str
  end

  defp iterate_and_replace(str, [match|tail], conversion_fn) do
    iterate_and_replace(String.replace(str, match, conversion_fn.(match), global: false), tail, conversion_fn)
  end

  defp link_conversion_fn(match) do
    link = String.slice(match, 1..-2)
    "<a target=\"_blank\" href=\"" <> link <> "\">" <> link <> "</a>"
  end

  defp bold_conversion_fn(match) do
    text = String.slice(match, 1..-2)
    "<strong>" <> text <> "</strong>"
  end

  defp italic_conversion_fn(match) do
    text = String.slice(match, 1..-2)
    "<em>" <> text <> "</em>"
  end
end
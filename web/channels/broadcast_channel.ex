defmodule GuerillaRadio.BroadcastChannel do
  use Phoenix.Channel

  intercept ["message_new", "message_edit"]

  def join("broadcasts:" <> _broadcast_name, _params, socket) do
    {:ok, socket}
  end

  # def handle_in("message_new", %{"body" => body}, socket) do
  #   broadcast! socket, "message_new", %{body: body}
  #   {:noreply, socket}
  # end

  def handle_out("message_new", payload, socket) do
    push socket, "message_new", payload
    {:noreply, socket}
  end

  def handle_out("message_edit", payload, socket) do
    push socket, "message_edit", payload
    {:noreply, socket}
  end
end
defmodule GuerillaRadio.MessageTest do
  use GuerillaRadio.ModelCase

  alias GuerillaRadio.Message

  @valid_attrs %{channel: "some content", text: "some content", ts: "some content", user: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Message.changeset(%Message{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Message.changeset(%Message{}, @invalid_attrs)
    refute changeset.valid?
  end
end

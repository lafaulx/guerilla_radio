defmodule GuerillaRadio do
  use Application

  @slack_token "xoxp-10482927584-10482927600-17388692247-a41ccca0f5"

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Start the endpoint when the application starts
      supervisor(GuerillaRadio.Endpoint, []),
      # Start the Ecto repository
      worker(GuerillaRadio.Repo, []),
      worker(GuerillaRadio.SlackRtm, [@slack_token, []]),
      # Here you could define other workers and supervisors as children
      # worker(GuerillaRadio.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GuerillaRadio.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    GuerillaRadio.Endpoint.config_change(changed, removed)
    :ok
  end
end

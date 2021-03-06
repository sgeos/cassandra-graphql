defmodule CassandraGraphql.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      CassandraGraphqlWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: CassandraGraphql.PubSub},
      # Start the Endpoint (http/https)
      CassandraGraphqlWeb.Endpoint,
      # Start Xandra
      {Xandra, name: :xandra, pool_size: 10},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CassandraGraphql.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CassandraGraphqlWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end


# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :cassandra_graphql, CassandraGraphqlWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "rjOs7ZWm+LGXyBTq5/F34oJl7R5ayAwW/h307GPbosea0YdRVRQQw6n5osExGfF/",
  render_errors: [view: CassandraGraphqlWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: CassandraGraphql.PubSub,
  live_view: [signing_salt: "m5qH02JE"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

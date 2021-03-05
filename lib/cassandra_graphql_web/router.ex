defmodule CassandraGraphqlWeb.Router do
  use CassandraGraphqlWeb, :router
  alias CassandraGraphqlWeb.{ApiController, GraphQL}

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :graphql do
    plug :accepts, ["json", "graphql"]
    plug CassandraGraphqlWeb.Plug.AbsintheRemoteIp
  end

  scope "/api", CassandraGraphqlWeb do
    pipe_through :api
  end

  scope "/" do
    pipe_through :graphql

    match :*, "/", Absinthe.Plug.GraphiQL, schema: GraphQL.Schema, json_codec: Phoenix.json_library(), interface: :simple
    forward "/graphql", Absinthe.Plug, schema: GraphQL.Schema, json_codec: Phoenix.json_library()
    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: GraphQL.Schema, json_codec: Phoenix.json_library()
  end

  scope "/" do
    pipe_through :api

    match :*, "/healthz", ApiController, :healthz
    match :*, "/items", ApiController, :items
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: CassandraGraphqlWeb.Telemetry
    end
  end
end


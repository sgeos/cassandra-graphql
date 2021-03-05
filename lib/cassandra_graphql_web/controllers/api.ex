defmodule CassandraGraphqlWeb.ApiController do
  use CassandraGraphqlWeb, :controller

  defp graphql(query, variables, conn) do
    context = %{remote_ip: conn.remote_ip}
    query
    |> Absinthe.run(CassandraGraphqlWeb.GraphQL.Schema, variables: variables, context: context)
    |> case do
      {:ok, %{data: result}} ->
        result
      {:ok, %{errors: _}=result} ->
        result
      result ->
        result
    end
  end

  def healthz(conn, _params) do
    variables = %{}
    result = """
      query Healthz {
        healthz: ping {
          success
          datetime
        }
      }
    """
    |> graphql(variables, conn)
    json(conn, result)
  end

  def items(conn, _params) do
    variables = %{}
    result = """
      query Items {
        items: itemList {
          itemId
          categoryList
        }
      }
    """
    |> graphql(variables, conn)
    json(conn, result)
  end
end


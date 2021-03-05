defmodule CassandraGraphqlWeb.GraphQL.Resolver.Item do
  def add_item_labels(nil), do: nil
  def add_item_labels([item_id, category_list]), do: %{item_id: item_id, category_list: category_list}

  def get_item_by_id(_parent, %{item_id: item_id}=_args, _info) do
    conn = Process.whereis(:xandra)
    statement = "SELECT * FROM cassandra_graphql.item WHERE item_id=?"
    {:ok, %Xandra.Page{content: result}} = Xandra.execute(conn, statement, [{"text", item_id}])
    result = List.first(result)
    |> add_item_labels
    {:ok, result}
  end

  def get_items_with_limit(_parent, args, _info) do
    conn = Process.whereis(:xandra)
    statement = if limit = Map.get(args, :limit) do
      "SELECT * FROM cassandra_graphql.item LIMIT #{limit}"
    else
      "SELECT * FROM cassandra_graphql.item"
    end
    {:ok, %Xandra.Page{content: result}} = Xandra.execute(conn, statement)
    result = Enum.map(result, &add_item_labels/1)
    {:ok, result}
  end
end


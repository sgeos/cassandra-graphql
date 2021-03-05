defmodule CassandraGraphqlWeb.GraphQL.Schema do
  use Absinthe.Schema
  import_types CassandraGraphqlWeb.GraphQL.Types
  alias CassandraGraphqlWeb.GraphQL.Resolver

  query do
    field :ping, type: :pong do
      resolve &Resolver.ping/2
    end

    field :info, type: :info do
      resolve &Resolver.info/2
    end

    field :item, type: :item do
      arg :item_id, non_null(:string)
      resolve &Resolver.Item.get_item_by_id/3
    end

    field :item_list, type: list_of(:item) do
      arg :limit, :integer
      resolve &Resolver.Item.get_items_with_limit/3
    end
  end
end


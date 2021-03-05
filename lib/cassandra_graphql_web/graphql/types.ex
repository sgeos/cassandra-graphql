defmodule CassandraGraphqlWeb.GraphQL.Types do
  use Absinthe.Schema.Notation

  @desc """
  Pong
  """
  object :pong do
    field :success, :boolean
    field :pong, :string # "pong"
    field :date, :date # date when message is generated
    field :time, :time # time when message is generated
    field :datetime, :datetime # date and time when message is generated
  end

  @desc """
  Info
  """
  object :info do
    field :version, :string
    field :remote_ip, :ip_address
    field :date, :date
    field :time, :time
    field :datetime, :datetime
  end

  defp parse_ok(input), do: {:ok, input}

  @desc """
  The `IP Address` scalar type represents ip address values.
  """
  scalar :ip_address do
    parse fn input ->
      input.value
      |> String.to_charlist
      |> :inet.parse_address
    end
    serialize &(to_string(:inet_parse.ntoa(&1)))
  end

  @desc """
  The `Duration` scalar type represents ISO 8601 duration values.
  """
  scalar :duration do
    parse &(Timex.Duration.parse(&1.value))
    serialize &Timex.Duration.to_string/1
  end

  @desc """
  The `Date` scalar type represents date values.
  """
  scalar :date do
    parse fn input ->
      input.value
      |> Kernel.to_string
      |> String.replace("/", "-")
      |> Date.from_iso8601!
      |> Timex.to_unix
      |> parse_ok
    end
    #serialize &Kernel.to_string/1
    serialize &(&1 |> Timex.from_unix |> DateTime.to_date |> Kernel.to_string)
  end

  @desc """
  The `Time` scalar type represents time values.
  """
  scalar :time do
    parse fn input ->
      input.value
      |> Kernel.to_string
      |> Time.from_iso8601!
      |> Timex.Duration.from_time
      |> Timex.Duration.to_seconds
      |> parse_ok
    end
    #serialize &Kernel.to_string/1
    serialize &(&1 |> Timex.Duration.from_seconds |> Timex.Duration.to_time! |> Kernel.to_string)
  end

  @desc """
  The `Datetime` scalar type represents date time values.
  """
  scalar :datetime do
    parse fn input ->
      input.value
      |> Kernel.to_string
      |> String.replace("/", "-")
      |> Timex.parse!("{ISO:Extended}")
      |> Timex.Timezone.convert("UTC")
      |> Timex.to_unix
      |> parse_ok
    end
    #serialize fn time -> time |> Timex.format("%F %T", :strftime) end
    serialize &(&1 |> Timex.from_unix |> Kernel.to_string)
  end
end


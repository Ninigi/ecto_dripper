defmodule EctoDripper do
  @moduledoc """
  Provides composable queries following a convention of `query_x(query, %{x: "asdf"})`, or `query_all(query, %{x: "asdf"})`.

  ## Basic Usage
  ```elixir
  defmodule MyApp.SomeQuery do
    use EctoDripper,
      composable_queries: [
        [:status, :==, :status],
        [:max_height, :>, :height],
        [:status_down, :status_down]
      ],
      standalone_queries: [
        [:small_with_status_up]
      ]

    defp status_down(query, args)
    defp status_down(query, %{status_down: true}) do
      from(
        i in query,
        where: i.status == ^"down"
      )
    end
    defp status_down(query, %{status_down: _}) do
      from(
        i in query,
        where: i.status != ^"down"
      )
    end

    defp small_with_status_up(query, _args) do
      from(
        i in query,
        where: i.status == ^"up", i.height <= 10
      )
    end
  end

  MyThing
  |> MyApp.SomeQuery.query_all(%{status: "somewhere", max_height: 30})
  # #Ecto.Query<from i in MyThing, where: i.status == ^"somewhere", i.height > ^30>

  # and use it with your Repo
  MyThing
  |> MyApp.SomeQuery.query_all(%{status: "up", max_height: 30})
  |> Repo.all()
  # [%MyThing{}, ..]
  ```
  """

  defp parse_query_opts(opts)
  defp parse_query_opts([_query_key, _args_key, _query_func] = opts), do: opts
  defp parse_query_opts([args_key, query_func]), do: [args_key, query_func, args_key]

  defmacro __using__(options) do
    comp_q = (options[:composable_queries] || []) |> Enum.map(&parse_query_opts/1)
    stan_q = (options[:standalone_queries] || []) |> Enum.map(&parse_query_opts/1)
    queries = comp_q ++ stan_q

    quote bind_quoted: [composable_queries: comp_q, queries: queries, standalone_queries: stan_q] do
      import Ecto.Query, warn: false

      @doc """
      Returns the parsed options given for all composable queries.

      ## Examples
          iex> BuiltInTestQuery.__composable_queries__
          [
            [:eq_field, :==, :eq_field],
            [:neq_field, :!=, :neq_field],
            [:gt_field, :>, :gt_field],
            [:lt_field, :<, :lt_field],
            [:lte_field, :<=, :lte_field],
            [:gte_field, :>=, :gte_field]
          ]
      """
      def __composable_queries__ do
        unquote(composable_queries)
      end

      @doc """
      Returns the parsed options given for all standalone queries.

      ## Examples
          iex> BuiltInTestQuery.__standalone_queries__
          [
            [:sta_eq_field, :==, :sta_eq_field],
            [:another_sta_eq_field, :==, :another_sta_eq_field]
          ]
      """
      def __standalone_queries__ do
        unquote(standalone_queries)
      end

      @doc """
      Returns an ecto query for all the composable queries, depending on the passed arguments.
      For example, if you have composable queries defined for `name` and `age`, you can query for
      either of those fields, or both, or none.

      * `%{name: "my name"}` will query for name only
      * `%{age: 22}` will query for age only
      * `%{name: "my name", age: 22}` will query for name AND age
      * `%{something: "Completely different"}` will return the queryable unchanged

      ## Examples

          iex> BuiltInTestQuery.query_all("a_table", %{eq_field: "123status", gt_field: 12})
          #Ecto.Query<from a in "a_table", where: a.eq_field == ^"123status", where: a.gt_field > ^12>

      """
      @spec query_all(Ecto.Queryable.t(), map) :: Ecto.Query.t() | Ecto.Queryable.t()
      def query_all(query, params, opts \\ []) do
        exclude = opts[:exclude] || []

        Enum.reduce(unquote(composable_queries), query, fn [query_key, _, args_key], query ->
          if args_key in exclude do
            query
          else
            apply(__MODULE__, :"query_#{query_key}", [query, params])
          end
        end)
      end

      for [query_key, query_func, args_key] <- queries do
        @doc """
        Returns an ecto query
        """
        def unquote(:"query_#{query_key}")(query, args)

        case query_func do
          :== ->
            def unquote(:"query_#{query_key}")(query, %{unquote(args_key) => val}) do
              from(
                things in query,
                where: field(things, ^unquote(query_key)) == ^val
              )
            end

          :!= ->
            def unquote(:"query_#{query_key}")(query, %{unquote(args_key) => val}) do
              from(
                things in query,
                where: field(things, ^unquote(query_key)) != ^val
              )
            end

          :< ->
            def unquote(:"query_#{query_key}")(query, %{unquote(args_key) => val}) do
              from(
                things in query,
                where: field(things, ^unquote(query_key)) < ^val
              )
            end

          :> ->
            def unquote(:"query_#{query_key}")(query, %{unquote(args_key) => val}) do
              from(
                things in query,
                where: field(things, ^unquote(query_key)) > ^val
              )
            end

          :<= ->
            def unquote(:"query_#{query_key}")(query, %{unquote(args_key) => val}) do
              from(
                things in query,
                where: field(things, ^unquote(query_key)) <= ^val
              )
            end

          :>= ->
            def unquote(:"query_#{query_key}")(query, %{unquote(args_key) => val}) do
              from(
                things in query,
                where: field(things, ^unquote(query_key)) >= ^val
              )
            end

          _ ->
            case args_key do
              :no_args ->
                def unquote(:"query_#{query_key}")(query),
                  do: apply(__MODULE__, unquote(query_func), [query])
                def unquote(:"query_#{query_key}")(query, _args),
                  do: apply(__MODULE__, unquote(query_func), [query])

              :all_args ->
                def unquote(:"query_#{query_key}")(query, args),
                  do: apply(__MODULE__, unquote(query_func), [query, args])

              _ ->
                def unquote(:"query_#{query_key}")(query, %{unquote(args_key) => _} = args),
                  do: apply(__MODULE__, unquote(query_func), [query, args])
            end
        end

        unless args_key in [:no_args, :all_args] do
          def unquote(:"query_#{query_key}")(query, _args), do: query
        end
      end
    end
  end
end

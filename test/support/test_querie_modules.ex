defmodule BuiltInTestQuery do
  use EctoDripper,
    composable_queries: [
      [:eq_field, :==],
      [:neq_field, :!=],
      [:gt_field, :>],
      [:lt_field, :<],
      [:lte_field, :<=],
      [:gte_field, :>=]
    ],
    standalone_queries: [
      [:sta_eq_field, :==],
      [:another_sta_eq_field, :==]
    ]
end

defmodule CustomTestQuery do
  use EctoDripper,
    composable_queries: [
      [:my_thing, :do_my_thing],
      [:another_thing, :do_another_thing, :custom_arg]
    ]

  def do_my_thing(queryable, %{my_thing: thing}) do
    from(i in queryable, where: i.something == true and i.my_thing == ^thing)
  end

  def do_another_thing(queryable, %{custom_arg: thing}) do
    from(i in queryable, where: i.something == true and i.another_thing == ^thing)
  end
end

defmodule NoArgTestQuery do
  use EctoDripper,
    composable_queries: [
      [:eq_field, :==],
      [:no_arg_thing, :do_no_arg_thing, :no_args]
    ]

  def do_no_arg_thing(queryable) do
    from(i in queryable, where: i.something == true)
  end
end

defmodule AllArgTestQuery do
  use EctoDripper,
    composable_queries: [
      [:eq_field, :==],
      [:all_arg_thing, :do_all_arg_thing, :all_args]
    ]

  def do_all_arg_thing(queryable, %{something: _, other: _} = args) do
    from(
      i in queryable,
      where: i.something == ^args.something and i.other == ^args.other
    )
  end
end

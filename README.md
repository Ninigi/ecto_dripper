# EctoDripper

<<<<<<< HEAD
[![Hex.pm](https://img.shields.io/hexpm/v/ecto_dripper.svg)](https://hex.pm/packages/ecto_dripper)

Provides composable ecto queries following a convention of `query_x(queryable, %{x: "asdf"})`, or `query_all(queryable, %{x: "asdf"})`.
=======
Provides an easy way to create composable ecto queries following a convention of `query_x(queryable, %{x: "asdf"})`, or `query_all(queryable, %{x: "asdf"})`.
>>>>>>> cd26ef8bdc72739c541ece350a26df7b66208c21

## Installation

The package can be installed by adding `ecto_dripper` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ecto_dripper, "~> 0.1.0"}
  ]
end
```

## Why not just write my queries in the already extremely readable ecto DSL??

Excellent question and I am glad you are not a mindless zombie :ok_hand:

If you don't know how to write queries in ecto, then this lib doesn't do anything for you but hide a few basic queries away. Don't use `EctoDripper` if you are not at least a little familiar with ecto queries yet, at some point you will have to use it anyways :fire:

I wrote this lib as part of another project when I realized I am following the same pattern over and over again, and that's all this lib does for you: **Streamline some repetetive tasks and unclutter your query modules.**

## Composable Queries

Composable in this case means "pipable", as in create a bunch of queries you can pipe together, or use the convenience function `query_all/2` to create queries from arguments.

Because of elixirs awesome pattern matching, we can just blindly pipe query functions together and only apply them if a certain key is in the arguments.

```elixir
args = %{query_this: "asdf"}
args2 = %{query_that: "asdf"}

# Does only query for :query_this
MyApp.MySchema
|> MyApp.MyQuery.query_all(args)

# Does only query for :query_that
MyApp.MySchema
|> MyApp.MyQuery.query_all(args2)
```

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

## What's going on here? I'd like to know how this works before `__using__`

```elixir
# What my modules usually looks like without EctoDripper
defmodule MyApp.MyQuery do
  def query_all(query, args) do
    query
    |> query_status(args)
    |> query_name_or_identifier(args)
  end

  def query_status(query, args)
  def query_status(query, %{status: status}) do
    # Create query when status key is in args
    from(
      thing in query,
      where: thing.status == ^status
    )
  end
  def query_status(query, _args) do
    # Let the query "fall through" if no status key in args
    query
  end

  def query_name_or_identifier(query, args)
  def query_name_or_identifier(query, %{query_name_or_identifier: query_name_or_identifier}) do
    # Create query when query_name_or_identifier key is in args
    from(
      thing in query,
      where: thing.name == ^query_name_or_identifier or thing.identifier == ^query_name_or_identifier
    )
  end
  def query_name_or_identifier(query, _args) do
    # Let the query "fall through" if no query_name_or_identifier key in args
    query
  end
end

# When using EctoDripper
defmodule MyApp.MyQuery do
  use EctoDripper,
    composable_queries:[
      [:status, :==],
      [:name_or_identifier, :do_query_name_or_identifier]
    ]

  def do_query_name_or_identifier(query, args) do
    from(
      thing in query,
      where: thing.name == ^query_name_or_identifier or thing.identifier == ^query_name_or_identifier
    )
  end
end
```

## Slightly more advanced usage - aka "I am lazy, give me more convenience"

There are 2 different options, `composable_queries` and `standalone_queries`, both take a list of lists to create some
basic functions for you.

A function option can consist of 2 or 3 keywords. When read from left to right, they describe the query function.
For example with:

```elixir
use EctoDripper,
  composable_queries: [
    [:status, :==]
  ]
```

`[:status, :==]` will create a query, comparing the status field of your queryable with the value for the status key in the args:

```elixir
def query_status(query, %{status: _} = args) do
  for(
    thing in query,
    where: thing.status == ^args.status
  )
end
```

If you want your query argument different from the field name, you can do so by adding a third field to the option:
`[:my_status_thing, :==, :status]`

```elixir
def query_status(query, %{my_status_thing: _} = args) do
  for(
    thing in query,
    where: thing.status == ^args.my_status_thing
  )
end
```

`[:name_or_identifier, :my_handler]` calls your custom handler function when passed `name_or_identifier` in args.

```elixir
def name_or_identifier(query, %{name_or_identifier: _} = args) do
  MyModule.my_handler(query, args)
end
```

## Repo.insert(%Contribution{code: "def awesome"})

**Contributions are highly welcome**

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

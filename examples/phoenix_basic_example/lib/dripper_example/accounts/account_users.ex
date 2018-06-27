defmodule DripperExample.AccountUsers do
  alias DripperExample.{
    Repo,
    Accounts,
    UserQuery
  }

  def find_user(args) do
    Accounts.User
    |> UserQuery.query_username(args)
    |> UserQuery.query_email(args)
    |> Repo.one()
  end
end

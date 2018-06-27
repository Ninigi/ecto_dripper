defmodule DripperExample.UserQuery do
  use EctoDripper,
    composable_queries: [
      [:username, :==],
      [:email, :do_email]
    ]

    @doc """
    This querys a user based on his credential.email
    """
    def do_email(queryable, args) do
      from(
        u in queryable,
        join: c in assoc(u, :credential),
        where: c.email == ^args.email
      )
    end
end

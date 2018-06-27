defmodule DripperExample.FindUserTest do
  use DripperExample.DataCase

  alias DripperExample.{
    Accounts,
    AccountUsers
  }

  describe "find_user/1" do
    test "finds a user for given username" do
      {:ok, user} = Accounts.create_user(%{name: "A Name", username: "username"})

      assert AccountUsers.find_user(%{user_name: user.username}).id == user.id
    end

    test "finds a user by email AND username" do
      {:ok, user} = Accounts.create_user(%{name: "A Name", username: "username"})
      {:ok, credential} = Accounts.create_credential(%{email: "test@email.com", user_id: user.id})

      Accounts.create_user(%{name: "Another Name", username: "another_user", other_thing: "asdf"})

      assert AccountUsers.find_user(%{username: user.username, email: credential.email}).id == user.id
      assert is_nil(AccountUsers.find_user(%{username: user.username, email: "wrong@email.com"}))
    end
  end
end

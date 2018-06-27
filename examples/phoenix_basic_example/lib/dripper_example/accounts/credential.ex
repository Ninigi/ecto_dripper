defmodule DripperExample.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset
  alias DripperExample.Accounts

  schema "credentials" do
    field :email, :string
    belongs_to :user, Accounts.User

    timestamps()
  end

  @doc false
  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:email, :user_id])
    |> validate_required([:email, :user_id])
    |> unique_constraint(:email)
  end
end

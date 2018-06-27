defmodule DripperExampleWeb.Router do
  use DripperExampleWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", DripperExampleWeb do
    pipe_through :api
  end
end

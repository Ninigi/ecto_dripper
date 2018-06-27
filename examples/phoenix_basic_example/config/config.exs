# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :dripper_example,
  ecto_repos: [DripperExample.Repo]

# Configures the endpoint
config :dripper_example, DripperExampleWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "OnYNkWTZ/0i5SzGmJf/ZwZd9fs7eFpwln3Zyb7Act8u7WhMpnSQJrD9u3DJIMfBe",
  render_errors: [view: DripperExampleWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: DripperExample.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

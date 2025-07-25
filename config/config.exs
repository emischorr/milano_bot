import Config

config :logger,
  backends: [:console]

config :logger, :console, level: :info

config :milano_bot, update_interval: :timer.hours(2)

import_config "#{config_env()}.exs"

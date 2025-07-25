import Config

config :milano_bot, :signal,
  api_url: System.get_env("SIGNAL_API_URL", "http://localhost:8080"),
  sender: System.get_env("SIGNAL_SENDER"),
  group: System.get_env("SIGNAL_GROUP_ID")

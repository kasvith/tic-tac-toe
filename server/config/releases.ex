import Config

config(:tic_tac_toe, :port, System.get_env("PORT", "4000"))

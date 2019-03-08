require_relative "../config/environment.rb"

api=API.new
cli=CLI.new(api)

 #binding.pry
# cli.welcome
# cli.account

#cli.start_menu
#cli.search_by_name
# cli.search_by_state
# api.printlist(api.all_park_names)
cli.run_search

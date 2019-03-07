require_relative "../config/environment.rb"

api=API.new
cli=CLI.new(api)

# binding.pry
# 0
# cli.welcome
# cli.account
# cli.start_menu
#cli.search_by_name
cli.search_by_state
# api.printlist(api.all_park_names)


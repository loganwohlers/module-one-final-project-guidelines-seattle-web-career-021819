require_relative "../config/environment.rb"

api=API.new
cli=CLI.new(api)

# binding.pry
# 0
# cli.welcome
# cli.account
# cli.start_menu
# cli.search_menu
# api.printlist(api.all_park_names)
p api.all_parks

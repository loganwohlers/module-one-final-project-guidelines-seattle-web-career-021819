require_relative "../config/environment.rb"

api=API.new
cli=CLI.new(api)

# binding.pry
cli.welcome
cli.start_menu

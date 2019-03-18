require_relative "../config/environment.rb"

api=API.new
cli=CLI.new(api)

cli.welcome
#runs the program
cli.start_menu
cli.goodbye

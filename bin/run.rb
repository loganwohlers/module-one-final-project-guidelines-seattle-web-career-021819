require_relative "../config/environment.rb"

api=API.new
cli=CLI.new(api)

cli.welcome
#runs the program
# TODO: make this a while loop that runs until the user wants to quit
cli.start_menu

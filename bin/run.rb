require_relative "../config/environment.rb"

# binding.pry
# 0
api=API.new
cli=CLI.new(api)
cli.welcome
cli.test222


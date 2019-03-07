require 'bundler'
Bundler.require

require 'yaml'

DBNAME = "nps"

Dir[File.join(File.dirname(__FILE__), "../app/models", "*.rb")].each {|f| require f}
Dir[File.join(File.dirname(__FILE__), "../lib/support", "*.rb")].each {|f| require f}

# DBRegistry[ENV["ACTIVE_RECORD_ENV"]].connect!
DB = ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: 'db/dev.sqlite'
)


NPS_API_KEY= YAML.load_file('config/secrets.yml')["NPS_API_KEY"]
require_all 'app'
require_all 'lib'

ActiveRecord::Base.logger = nil

if ENV["ACTIVE_RECORD_ENV"] == "test"
  ActiveRecord::Migration.verbose = false
end

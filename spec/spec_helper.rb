require 'factory_girl'
require 'faker'
require 'database_cleaner'
require 'active_record'
require 'fars2'

Dir["./spec/support/**/*.rb"].each { |f| require f }
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
CreateCustomers.new.change
CreateOrders.new.change
CreateProducts.new.change
FactoryGirl.find_definitions

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.default_formatter = 'doc' if config.files_to_run.one?
  # config.order = :random
  # Kernel.srand config.seed

  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

require 'bundler/setup'
unless defined? JRUBY_VERSION
  require 'simplecov'
  require 'coveralls'
  Coveralls.wear!

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
                                                                   SimpleCov::Formatter::HTMLFormatter,
                                                                   Coveralls::SimpleCov::Formatter
                                                                 ])
  SimpleCov.start do
    add_filter 'spec/'
  end
end

require 'ya_kansuji'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

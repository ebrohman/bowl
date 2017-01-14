$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "bowl"
require "byebug"
require "csv"
require "rspec/its"

include Bowl

DATA_PATH = File.expand_path("../data/sample_game.csv", __FILE__ )

module SpecHelpers
  def with_csv( path=DATA_PATH )
    CSV.read( path ) do |row|
      yield row if block_given?
      row
    end
  end
end

RSpec.configure do |config|
  config.include SpecHelpers
end

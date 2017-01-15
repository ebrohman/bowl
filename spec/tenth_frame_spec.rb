require "spec_helper"
require "pry"

RSpec.describe TenthFrame do
  describe "#finished" do
    let( :f ) { described_class.new }

    after( :each ) { f.rolls = [] }

    it "can only have three rolls if the first is a strike" do
      f.register_shot 3
      f.register_shot 7
      expect( f.finished? ).to be
    end

    it "can have 3 rolls max" do
      f.register_shot 10
      f.register_shot 10
      f.register_shot 10
      expect( f.finished? ).to be
    end

    it "can't always have 3 rolls" do
      f.register_shot 3
      f.register_shot 3
      # binding.pry
      expect( f.finished? ).to be
    end
  end
end

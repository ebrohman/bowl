require "spec_helper"
require "pry"

RSpec.describe TenthFrame do
  describe "#finished" do
    let( :f ) { described_class.new }

    after( :each ) { f.rolls = [] }

    it "can have 3 rolls max" do
      f.register_shot 10
      f.register_shot 10
      f.register_shot 10
      expect( f.finished? ).to be
    end

    it "can't always have 3 rolls" do
      f.register_shot 3
      f.register_shot 3
      expect( f.finished? ).to be
    end
  end
end

require "spec_helper"
require "pry"

RSpec.describe TenthFrame do
  describe "#finished" do
    let( :f ) { described_class.new }

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
      expect( f.finished? ).to be
    end

    it "can't roll an 11" do
      expect { f.register_shot 11 }.
        to raise_error Frame::RollError
    end

    it "can't roll an 11 on the second shot after a strike" do
      expect do
        f.register_shot 10
        f.register_shot 11
      end.to raise_error Frame::RollError
    end

    it "can't roll an 11 on the third shot after a strike" do
      expect do
        f.register_shot 10
        f.register_shot 10
        f.register_shot 11
      end.to raise_error Frame::RollError
    end

    it "cant roll more than 10 for the first two rolls" do
      expect{ f.register_shot 11 }.
        to raise_error Frame::RollError
    end
  end
end

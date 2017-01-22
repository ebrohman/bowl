require "spec_helper"
require "rspec/its"

RSpec.describe Frame do
  subject( :frame ) { described_class.new }

  it "has 10 pins" do
    expect( described_class::PINS ).to eq 10
  end

  describe "initialize" do
    its( :remaining_pins )  { should eq 10 }
    its( :frame_number )    { should eq 1 }
    its( :ball_total )      { should eq 0 }
    its( :bonus_total )     { should eq 0 }
  end

  describe "#remaining_pins" do
    frame = described_class.new
    subject { frame.register_shot 5 }
    its( :remaining_pins ) { should eq 5 }
    subject { frame.register_shot 5 }
    its( :remaining_pins ) { should eq 0 }
  end

  describe "#strike?" do
    it "is true if the first roll total equals 10" do
      expect( frame.register_shot( 10 ).strike? ).to be
    end
  end

  describe "#spare?" do
    it "two balls are thrown and their total is 10" do
      frame.register_shot 5
      expect( frame.spare? ).to_not be
      frame.register_shot 5
      expect( frame.spare? ).to be
    end

    it "isn't a strike" do
      frame.register_shot 10
      expect( frame.spare? ).to_not be
    end
  end

  describe "#finished?" do
    it "is true if 2 balls have been rolled" do
      frame.register_shot 2
      expect( frame.finished? ).to_not be
      frame.register_shot 2
      expect( frame.finished? ).to be
    end
  end

  describe "#register_shot" do
    context "when the frame is active" do
      it "adds to the ball total" do
        expect{ frame.register_shot( 5 ) }.
          to change{ frame.send :ball_total }.from( 0 ).to 5
      end

      it "subtracts from the remaining_pins" do
        expect{ frame.register_shot( 5 ) }.
          to change{ frame.send :remaining_pins }.from( 10 ).to 5
      end
    end

    context "when the frame is finished" do
      it "doesn't add to the ball total" do
        frame.register_shot 5
        frame.register_shot 5
        expect( frame.send :ball_total ).to eq 10
        expect{ frame.register_shot( 10 ) }.
          to_not change{ frame.send :ball_total }
      end
    end
  end

  describe "#add_to_bonus_total" do
    context "for an unfinished frame" do
      it "doesn't add to the bonus total" do
        allow( frame ).to receive( :finished? ).and_return false
        frame.register_shot( 10 )
        expect( frame.send :bonus_total ).to eq 0
      end
    end

    context "for a finished frame" do
      before( :each ) do
        allow( frame ).to receive( :finished? ).
          and_return true
      end

      context "strike" do
        before( :each ) do
          allow( frame ).to receive( :strike? ).
            and_return true
        end

        it "registers the next two shots only" do
          frame.register_shot( 5 )
          frame.register_shot( 5 )
          frame.register_shot( 5 )
          expect( frame.send :bonus_total ).to eq 10
        end
      end

      context "spare" do
        before( :each ) do
          allow( frame ).to receive( :spare? ).
            and_return true
        end

        it "registers the next shot only" do
          expect( frame.send :bonus_total ).to eq 0
          frame.register_shot( 6 )
          frame.register_shot( 6 )
          expect( frame.send :bonus_total ).to eq 6
        end
      end
    end
  end
end

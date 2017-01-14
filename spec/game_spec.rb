require "spec_helper"

RSpec.describe Bowl::Game do
  let( :frame_model ) { double( Frame ) }

  it "has 10 frames" do
    expect(  described_class::NUM_FRAMES ).to eq 10
  end

  describe ".new" do
    it "starts with frame" do
      expect(  described_class.new.frames.count ).to eq 1
    end
  end

  describe "#current_frame" do
    let( :frame ) { Frame.new }

    before do
      allow( frame_model ).to receive( :new ).
        and_return frame
    end

    it "returns the most recent frame" do
      expect(  described_class.new( frame_model: frame_model )
        .current_frame ).to eq frame
    end
  end

  describe "#roll" do
    let( :frame ) { Frame.new }

    before do
      allow( frame_model ).to receive( :new ).
        and_return frame

      allow( frame ).to receive( :validate_shot! )
      allow( frame ).to receive( :finished? )
      allow( frame_model ).to receive( :new ).and_return frame
    end

    it "validates the shot with the frame" do
      described_class.new( frame_model: frame_model  ).roll 7
      expect( frame ).to have_received( :validate_shot! ).
        with 7
    end

    context "the current frame is finished" do
      before( :each ) do
        allow( frame ).to receive( :finished? ).and_return true
      end

      it "starts a new frame if the current frame is finished" do
        described_class.new( frame_model: frame_model ).roll 7
        expect( frame_model ).to have_received( :new ).twice
      end

      it "gives the new frame a frame number" do
        game = described_class.new
        game.roll 7
        game.roll 3
        game.roll 3
        expect( game.current_frame.frame_number ).to eq 2
      end
    end

    context "with a valid roll" do
      before do
        allow( frame ).to receive( :validate_shot! ).and_return true
        allow( frame ).to receive( :register_shot )
      end

      it "registers the shot with each frame" do
        described_class.new( frame_model: frame_model ).roll 7
        expect( frame ).to have_received( :register_shot ).
          with 7
      end
    end

    context "with an invalid roll" do
      it "raises an error" do
        allow( frame ).to receive( :validate_shot! ).and_call_original
        expect{  described_class.new.roll 11 }.to raise_error Frame::RollError
      end
    end
  end

  describe "#score" do
    it "scores a perfect game" do
      data = %w( 10 10 10 10 10 10 10 10 10 10 10 10 )
      rolls = data.map( &:to_i )
      game = described_class.new
      rolls.each { |pins| game.roll pins }
      expect( game.score ).to eq 300
    end

    it "290" do
      data = %w( 10 10 10 10 10 10 10 10 10 10 10 0 )
      rolls = data.map( &:to_i )
      game = described_class.new
      rolls.each { |pins| game.roll pins }
      expect( game.score ).to eq 290
    end

    it "295" do
      data = %w( 10 10 10 10 10 10 10 10 10 10 10 5 )                              #
      rolls = data.map( &:to_i )
      game = described_class.new
      rolls.each { |pins| game.roll pins }
      expect( game.score ).to eq 295
    end

    it "291" do
      data = %w( 10 10 10 10 10 10 10 10 10 10 10 1 )
      rolls = data.map( &:to_i )
      game = described_class.new
      rolls.each { |pins| game.roll pins }
      expect( game.score ).to eq 291
    end
  end

  describe "#over?" do
    it "raises a GameError if you are finished but still rolling" do
      game = described_class.new
      expect{
        13.times { game.roll 10 }
      }.to raise_error( Bowl::Game::GameError, "This game is finished" )
    end
  end
end

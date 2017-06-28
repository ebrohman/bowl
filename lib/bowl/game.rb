require "bowl"

module Bowl
  class Game
    NUM_FRAMES = 10
    class GameError < StandardError; end
    attr_reader :current_frame, :frame_model
    attr_accessor :frames

    def initialize( frame_model: Frame, frames: [] )
      @frame_model = frame_model
      @frames = frames << frame_model.new
    end

    def current_frame
      frames.last
    end

    def roll( pins )
      validate_pins! pins
      assert_game_is_not_over!
      check_frame!
      frames.each { |f| f.register_shot pins.to_i }
      self
    end

    def score
      frames.map( &:total ).inject( &:+ )
    end

    def over?
      frames.size == NUM_FRAMES &&
        current_frame.finished?
    end

    private

    def check_frame!
      if current_frame.finished?
        approaching_tenth_frame? ?
          add_frame( frame_type: TenthFrame ) :
            add_frame
      end
    end

    def add_frame( frame_type: frame_model )
      frames << frame_type.new
    end

    def approaching_tenth_frame?
      frames.size == 9
    end

    def validate_pins!( pins )
      raise GameError, "Pins must be a number" unless
        pins.to_s.match /^[0-9]+$/
    end

    def assert_game_is_not_over!
      raise GameError, "This game is finished" if
        over?
    end
  end
end

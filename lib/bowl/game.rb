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
      assert_game_is_not_over!
      check_frame!
      frames.each { |f| f.register_shot pins }
      self
    end

    def score
      frames.map( &:total ).inject( &:+ )
    end

    def over?
      current_frame.frame_number == NUM_FRAMES &&
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
      frames << frame_type.
        new( frame_number: next_frame_number )
    end

    def next_frame_number
      current_frame.frame_number + 1
    end

    def approaching_tenth_frame?
      current_frame.frame_number == 9
    end

    def assert_game_is_not_over!
      raise GameError, "This game is finished" if
        over?
    end
  end
end

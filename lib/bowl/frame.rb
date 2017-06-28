require "bowl"

module Bowl
  class Frame
    PINS = 10

    attr_accessor :rolls, :bonus_rolls
    attr_reader   :frame_number

    class RollError < StandardError; end

    def initialize( rolls: [], bonus_rolls: [] )
      @frame_number = frame_number
      @rolls = rolls
      @bonus_rolls = bonus_rolls
    end

    def register_shot( pins )
      validate_shot!( pins )
      add_to_ball_total pins
      add_to_bonus_total pins
      self
    end

    def finished?
      remaining_pins == 0 || second_roll
    end

    def total
      ball_total + bonus_total
    end

    def strike?
      first_roll == 10
    end

    def spare?
      !strike? && remaining_pins == 0
    end

    private

    def first_roll() rolls[0]; end
    def second_roll() rolls[1]; end

    def ball_total
      first_roll.to_i + second_roll.to_i
    end

    def bonus_total
      bonus_rolls.inject( :+ ) || 0
    end

    def remaining_pins
      PINS - ( first_roll.to_i + second_roll.to_i )
    end

    def validate_shot!( pins )
      raise RollError, "Only #{remaining_pins} pin(s) remain" if
        pins > remaining_pins unless finished?

      raise RollError, "Cannot roll more than #{PINS} pins" if pins > PINS
    end

    def add_to_ball_total( pins )
      return if finished?
      rolls << pins
    end

    def add_to_bonus_total( pins )
      return unless finished?
      register_strike_bonus_pins( pins )
      register_spare_bonus_pins( pins )
    end

    def register_strike_bonus_pins( pins )
      return unless strike?
      bonus_rolls << pins if bonus_rolls.length < 2
    end

    def register_spare_bonus_pins( pins )
      return unless spare?
      bonus_rolls << pins if bonus_rolls.empty?
    end
  end
end

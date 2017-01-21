require "bowl"

module Bowl
  class TenthFrame < Frame
    def finished?
      return super unless strike?
      third_roll ? true : false
    end

    def ball_total() super + third_roll.to_i end

    private

    def remaining_pins
      return super unless strike?
      second_roll_strike? ? PINS :
        PINS - ( second_roll || 0 )
    end

    def add_to_bonus_total( _ ) end

    def second_roll_strike?
      second_roll == PINS
    end

    def third_roll() rolls[2] end
  end
end

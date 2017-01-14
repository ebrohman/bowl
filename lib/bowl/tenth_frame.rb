require "bowl"

module Bowl
  class TenthFrame < Frame
    def finished?
      if strike? || spare?
        rolls.count >= 3
      else
        rolls.count >= 2
      end
    end

    def ball_total
      first_roll.to_i +
        second_roll.to_i +
          third_roll.to_i
    end

    private

    def add_to_ball_total( pins )
      return if finished?
      rolls << pins
    end

    def add_to_bonus_total( _ ) end

    def third_roll
      rolls[2]
    end
  end
end

require_relative 'robot_moves'

class RobotMoveController
  include RobotMoves

  def interpret_move current_coords, current_direction, instruction
    new_location_direction = []
    case instruction
    when "L"
      new_location_direction = MoveLeft.move_robot current_coords, current_direction
    when "R"
      new_location_direction = MoveRight.move_robot current_coords, current_direction
    when "F"
      new_location_direction = MoveForward.move_robot current_coords, current_direction
    end
    new_location_direction
  end
end
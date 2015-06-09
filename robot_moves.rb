module RobotMoves
  class Move
    ROBOT_ORIENTATIONS = { "N" => 0, "E" => 90, "S" => 180, "W" => 270 }
    def self.move_robot current_coords, current_direction
    end
  end

  class MoveRight < Move
    def self.move_robot current_coords, current_direction
      new_orientation = ROBOT_ORIENTATIONS[current_direction] + 90
      new_orientation = 0 if new_orientation == 360
      current_coords + [ROBOT_ORIENTATIONS.key(new_orientation)]
    end
  end

  class MoveLeft < Move
    def self.move_robot current_coords, current_direction
      new_orientation = ROBOT_ORIENTATIONS[current_direction] - 90
      new_orientation = 270 if new_orientation == -90
      current_coords + [ROBOT_ORIENTATIONS.key(new_orientation)]
    end
  end

  class MoveForward < Move
    def self.move_robot current_coords, current_direction
      new_coords = current_coords.dup
      case current_direction
      when "N"
        new_coords[1] += 1
      when "E"
        new_coords[0] += 1
      when "S"
        new_coords[1] -= 1
      when "W"
        new_coords[0] -= 1
      end
      new_coords + [current_direction]
    end
  end
end
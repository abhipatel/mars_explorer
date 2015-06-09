require_relative 'robot_move_controller'

file_path = ARGV[0]

$max_x_coord = 0
$max_y_coord = 0
$lost_robots = Hash.new

def is_invalid_move coords
  coords[0] < 0 || coords[0] > $max_x_coord || coords[1] < 0 || coords[1] > $max_y_coord
end

def ignore_invalid_move coords
  $lost_robots.has_key?(coords[0]) && $lost_robots[coords[0]].include?(coords[1])
end

def record_lost_robot coords, direction
  puts "#{coords.join(' ')} #{direction} LOST"
  if $lost_robots.has_key?(coords[0])
    $lost_robots[coords[0]] << coords[1]
  else
    $lost_robots[coords[0]] = [coords[1]]
  end
end

def traverse_mars start_coords_direction, robot_movements, robot_move_controller
  current_location = [start_coords_direction[0].to_i, start_coords_direction[1].to_i]
  current_direction = start_coords_direction[2]
  robot_lost = false
  
  robot_movements.each do |movement|
    new_location_direction = robot_move_controller.interpret_move current_location, current_direction, movement
    if is_invalid_move new_location_direction[0..1]
      unless ignore_invalid_move current_location
        record_lost_robot current_location, current_direction
        robot_lost = true
        break
      end
    else
      current_location = new_location_direction[0..1]
      current_direction = new_location_direction[2]
    end
  end

  # print final location if robot is not lost
  puts "#{current_location.join(' ')} #{current_direction}" unless robot_lost
end

# check file exists and is not blank
if file_path && File.size?(file_path)
  instructions = File.open file_path

  mars_limits = instructions.gets.chomp
  mars_max_coords = mars_limits.split ' '

  $max_x_coord = mars_max_coords[0].to_i
  $max_y_coord = mars_max_coords[1].to_i

  # check grid is not too big
  if $max_x_coord > 50 || $max_y_coord > 50
    puts "Mars grid is too big to traverse with robots"
  else
    robot_move_controller = RobotMoveController.new
    while start_coords_direction = instructions.gets do
      unless start_coords_direction.chomp.empty?
        robot_movements = instructions.gets

        # check instructions are not too long
        if instructions.size > 100
          puts "Too many instructions to compute robot journey"
        else
          traverse_mars start_coords_direction.chomp.split(' '), robot_movements.chomp.split(//), robot_move_controller
        end
      end
    end
  end
else
  puts "Specified input file was not found or empty"
end
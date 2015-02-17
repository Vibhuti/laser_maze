  class Laser

    NORTH = 'N'
    SOUTH = 'S'
    EAST = 'E'
    WEST = 'W'
    MIRROR_FORWARD = '/'
    MIRROR_BACK = '\\'

    attr_accessor :grid, :starting_direction, :player_position, :distance_traveled, :player_previous_position

    def initialize(lines = nil)
      return if lines.nil?
      set_grid_size(lines[0])
      set_player_starting_position(lines[1])
      if lines.length >= 2
        sub_line_array = lines[2..lines.length]
        sub_line_array.each do |i|
          update_grid(i)
        end
      end
    end

    def fire
      move_direction(self.starting_direction)
    end

    def is_mirror?(str)
      (str == MIRROR_FORWARD || str == MIRROR_BACK)
    end

    def to_s
      "#{grid} and #{player_position} \n"
    end

    def move_direction(direction)
      x = player_position.x
      y = player_position.y

      case direction
        when SOUTH
          move_south(x, y)
        when NORTH
          move_north(x, y)
        when EAST
          move_east(x, y)
        when WEST
          move_west(x, y)
        else
      end
      distance_traveled
    end

    private

    def move_south(x, y)
      while(y > 0 && !is_mirror?(grid.double_array[x][y])) do
        y -= 1
        self.distance_traveled += 1

      end
      mirror_condition(x, y, SOUTH)
    end

    def move_north(x, y)
      while(y < (grid.rows - 1) && !is_mirror?(grid.double_array[x][y])) do
        y += 1
        self.distance_traveled += 1
      end
      mirror_condition(x, y, NORTH)
    end

    def move_west(x, y)
      while(x > 0 && !is_mirror?(grid.double_array[x][y])) do
        x -= 1
        self.distance_traveled += 1
      end
      mirror_condition(x, y, WEST)
    end

    def move_east(x, y)
      while(x < (grid.cols - 1) && !is_mirror?(grid.value(x,y))) do
        x += 1
        self.distance_traveled += 1
      end
      mirror_condition(x, y, EAST)
    end

    def mirror_condition(x, y, direction)
      if is_mirror?(grid.value(x,y))
        move_direction(direction_logic(grid.value(x,y), direction))
      end
    end

    def direction_logic(str, direction)
      return EAST if(str == MIRROR_BACK && direction == SOUTH)
      return SOUTH if(str == MIRROR_BACK && direction == EAST)
      return WEST if(str == MIRROR_BACK && direction == NORTH)
      return NORTH if(str == MIRROR_BACK && direction == WEST)
      return EAST if(str == MIRROR_FORWARD && direction == NORTH)
      return WEST if(str == MIRROR_FORWARD && direction == SOUTH)
      return SOUTH if(str == MIRROR_FORWARD && direction == WEST)
      return NORTH if(str == MIRROR_FORWARD && direction == EAST)
    end

    def set_grid_size(input_first_line)
       int_arr = split_input(input_first_line).map(&:to_i)
       self.grid = Grid.new(int_arr)
    end

    def split_input(string_array)
      string_array.split(' ');
    end

    def set_player_starting_position(line)
      arr = split_input(line)
      x = arr[0].to_i
      y = arr[1].to_i
      self.starting_direction = arr[2]
      update_grid(line)
      set_distance_travel
      self.player_position = PlayerPosition.new(x, y, self.starting_direction)
    end

    def update_grid(line)
      grid.double_array[split_input(line)[0].to_i][split_input(line)[1].to_i] = split_input(line)[2]
    end

    def set_distance_travel
      self.distance_traveled = 0
    end

    def exit_condition(player_position)
      x = player_position.x
      y = player_position.y
      direction = player_position.direction
      is_wall?(x, y) || is_loop?(x, y, direction)
    end

    def is_wall?(x, y)
      x == 0 || y == 0 || x == grid.cols || y == grid.rows
    end

    def is_loop?(x, y, direction)
      grid.double_array[x][y] == direction
    end

    def update_player_position(x, y)
      player_position.x = x
      player_position.y = y
    end
  end
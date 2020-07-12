class RacingTui::Circuit
  def initialize(circuit_id)
    road = load_circuit circuit_id
    @circuit = trace road
    @canvas = draw @circuit
  end

  def mark(position, color = '#FF0000')
    x, y = @circuit[position % @circuit.size]

    @canvas.map.with_index do |line, idy|
      if idy == y
        dup = line.clone
        dup[x] = '*'.fg(color)
        dup
      else
        line
      end
    end
  end

  private

  def load_circuit(id)
    road = []

    File.readlines("res/circuit/#{id}.txt").each_with_index do |line, idy|
      line.chomp.split('').each_with_index do |char, idx|
        road << [idx, idy] if char != ' '
      end
    end

    road
  end

  def draw(circuit)
    max_x = max_y = 0

    circuit.each do |x, y|
      max_x = x if x > max_x
      max_y = y if y > max_y
    end

    canvas = 0.upto(max_y).map { ' ' * max_x }

    circuit.each do |x, y|
      canvas[y][x] = '*'
    end

    canvas
  end

  def trace(road)
    circuit = [road.delete_at(0)]

    loop do
      break if road.empty?

      x, y = circuit.last
      close_idx = closest_neigbord(x, y, road)

      circuit << road.delete_at(close_idx)
    end # loop

    circuit
  end

  def closest_neigbord(x, y, road)
    near = road.select do |x2, y2|
      x_diff = x - x2
      y_diff = y - y2

      x_diff.abs < 2 && y_diff.abs < 2
    end

    return road.find_index(near.first) if near.size == 1

    coord = near.min { |(x1, y1), (x2, y2)| ((x1 - x).abs + (y1 - y).abs) <=> ((x2 - x).abs + (y2 - y).abs) }
    road.find_index(coord)
  end
end

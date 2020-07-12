class RacingTui::Terminal
  def initialize
    console.puts "\e[0m\e[2J"
  end

  def max_width
    console.winsize.last - 1
  end

  def max_height
    console.winsize.first - 1
  end

  def puts(msg, position = []) # [col, row]
    set_pos(*position) unless position.empty?

    console.puts msg
  end

  def set_pos(x, y)
    puts "\e[#{x};#{y}H"
  end

  private

  def console
    @console ||= IO.console
  end
end

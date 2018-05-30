class Point
  include ActiveModel::Model
  attr_accessor :x, :y

  def angle(lowest_yx_coordinate)
    dy = y - lowest_yx_coordinate.y
    dx = x - lowest_yx_coordinate.x
    Math::atan2(dy, dx)
  end

  def to_s
    "[#{x}, #{y}]"
  end

end

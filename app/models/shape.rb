# https://en.wikipedia.org/wiki/Graham_scan

class Shape
  include ActiveModel::Model
  attr_accessor :points
  attr_accessor :hull_points

  def self.create(points)
    s = Shape.new(points: points.map { |p| Point.new(x: p[0], y: p[1]) })
    s.sort_points
    s
  end

  def sort_points
    @points = @points - [lowest_yx_coordinate]
    @points = @points.sort_by { |p| [p.angle(lowest_yx_coordinate), p.x, -p.y] }
    @points.unshift lowest_yx_coordinate
  end

  def hull_points
    convex_hull if @hull_points.nil?
    @hull_points[0..-2]
  end

  def lowest_yx_coordinate
    calc_lowest_yx_coordinate if @lowest_yx_coordinate.nil?
    @lowest_yx_coordinate
  end

  def right_turn?(p1, p2, p3)
    !hull_point?(p1, p2, p3)
  end

  def left_turn?(p1, p2, p3)
    hull_point?(p1, p2, p3)
  end

  private

  def hull_point?(p1, p2, p3)
    (p2.x - p1.x)*(p3.y - p1.y) - (p2.y - p1.y)*(p3.x - p1.x) > 0
  end

  def check_point(p = nil)
    @hull_points << p unless p.nil?
    p1 = @hull_points[-3]
    p2 = @hull_points[-2]
    p3 = @hull_points[-1]
    if right_turn?(p1, p2, p3)
      @hull_points.delete_at(-2)
      if @hull_points.count > 2
        check_point()
      end
    end
  end

  def convex_hull
    @hull_points = @points[0..1]
    points = @points.clone
    # Copy the first point to the end of the array so the algorighm tests the last point
    points << points[0]
    points[2..-1].each_with_index do |p,i| 
      check_point(p)
    end
  end

  def calc_lowest_yx_coordinate
    @points.each do |point|
      set_lowest_yx_coordinate(point)
    end
  end

  def set_lowest_yx_coordinate(point)
    @lowest_yx_coordinate = point if @lowest_yx_coordinate.nil?
    @lowest_yx_coordinate = point if ([@lowest_yx_coordinate.y, @lowest_yx_coordinate.x] <=> [point.y, point.x]) == 1
  end

end

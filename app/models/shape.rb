# Find 2D convex hull using Graham scan.
# nrnickolov@yahoo.com
# https://en.wikipedia.org/wiki/Graham_scan

class Shape
  include ActiveModel::Model


  # An array of points containing all given points
  attr_accessor :points

  # An array of points containing the points being scanned
  # At the end of execution, it holds the final result
  attr_accessor :hull_points

  def self.create(points)
    s = Shape.new(points: points.map { |p| Point.new(x: p[0], y: p[1]) })
    s.sort_points
    s
  end

  # Sort the points in increasing order of the angle they and lowest_yx_coordinate point make with the x-axis
  def sort_points
    @points = @points - [lowest_yx_coordinate]
    @points = @points.sort_by { |p| [p.angle(lowest_yx_coordinate), p.x, -p.y] }
    @points.unshift lowest_yx_coordinate
  end

  def hull_points
    convex_hull if @hull_points.nil?
    @hull_points[0..-2]
  end

  # The algorithm starts scanning with the point with the lowest y-coordinate
  # If more than one point has the lowest y-coordinate, the one with the lowest x-coordinate is selected 
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

  # Returns true if the points make a left turn
  # For more info: https://en.wikipedia.org/wiki/Graham_scan
  def hull_point?(p1, p2, p3)
    (p2.x - p1.x)*(p3.y - p1.y) - (p2.y - p1.y)*(p3.x - p1.x) > 0
  end

  # If a point is passed to check_point, it is added to @hull_points and is used in the check
  # If no point is passed to check_point, the last three points of @hull_points are checked
  def check_point(p = nil)
    @hull_points << p unless p.nil?
    p1 = @hull_points[-3]
    p2 = @hull_points[-2]
    p3 = @hull_points[-1]
    if right_turn?(p1, p2, p3)
      # Delete the middle point, because it lies inside the convex hull
      @hull_points.delete_at(-2)

      # Recursivly check the last three points in @hull_points to see if they still make a left turn
      check_point() if @hull_points.count > 2
    end
  end

  # When called, starts the loop to check each point
  def convex_hull

    # Take the furst two point from the sorted array and add them to @hull_points
    # They will be used in the first scan
    @hull_points = @points[0..1]

    points = @points.clone

    # Copy the first point to the end of the array so the algorighm tests the last point
    points << points[0]

    # Loop through each given point and check for left or right turn
    points[2..-1].each { |p| check_point(p) }
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

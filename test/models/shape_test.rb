# Find 2D convex hull using Graham scan.
# nrnickolov@yahoo.com
# https://en.wikipedia.org/wiki/Graham_scan

require 'test_helper'

class ShapeTest < ActiveSupport::TestCase

   test "lowest_yx_coordinate" do
     s = Shape.new(points: [ Point.new(x: 5, y: 7), Point.new(x: 7, y: 5), Point.new(x: 13, y: 13) ] )
     assert_equal 7, s.lowest_yx_coordinate.x
     assert_equal 5, s.lowest_yx_coordinate.y

     s = Shape.new(points: [ Point.new(x: 5, y: 7), Point.new(x: 17, y: 15), Point.new(x: 13, y: 13) ] )
     assert_equal 5, s.lowest_yx_coordinate.x
     assert_equal 7, s.lowest_yx_coordinate.y

     s = Shape.new(points: [ Point.new(x: 5, y: 7), Point.new(x: 5, y: 7), Point.new(x: 13, y: 13) ] )
     assert_equal 5, s.lowest_yx_coordinate.x
     assert_equal 7, s.lowest_yx_coordinate.y

     s = Shape.new(points: [ Point.new(x: 5, y: 7), Point.new(x: 3, y: 7), Point.new(x: 13, y: 13) ] )
     assert_equal 3, s.lowest_yx_coordinate.x
     assert_equal 7, s.lowest_yx_coordinate.y

     s = Shape.new(points: [ Point.new(x: 5.321, y: 7.592), Point.new(x: 3.733, y: 7.8156), Point.new(x: 13, y: 13) ] )
     assert_equal 5.321, s.lowest_yx_coordinate.x
     assert_equal 7.592, s.lowest_yx_coordinate.y

     s = Shape.new(points: [ Point.new(x: 13, y: 13), Point.new(x: 5.321, y: 7.592), Point.new(x: 3.733, y: 7.8156) ] )
     assert_equal 5.321, s.lowest_yx_coordinate.x
     assert_equal 7.592, s.lowest_yx_coordinate.y

     s = Shape.new(points: [ Point.new(x: 3.733, y: 7.8156), Point.new(x: 13, y: 13), Point.new(x: 5.321, y: 7.592) ] )
     assert_equal 5.321, s.lowest_yx_coordinate.x
     assert_equal 7.592, s.lowest_yx_coordinate.y

     s = Shape.new(points: [ Point.new(x: 5.321, y: 7.8156), Point.new(x: 5.321, y: 13), Point.new(x: 5.321, y: 7.592) ] )
     assert_equal 5.321, s.lowest_yx_coordinate.x
     assert_equal 7.592, s.lowest_yx_coordinate.y

     s = Shape.new(points: [ Point.new(x: 3.733, y: 7.8156), Point.new(x: 13, y: 7.8156), Point.new(x: 5.321, y: 7.8156) ] )
     assert_equal 3.733, s.lowest_yx_coordinate.x
     assert_equal 7.8156, s.lowest_yx_coordinate.y
   end

   test "point sorting" do
     s = Shape.create [[6,1], [5,2], [4,3], [3,3], [2,2], [1,1], [6,2], [6,3], [1,2], [0, 2]]
     assert_equal "[1, 1], [6, 1], [6, 2], [5, 2], [6, 3], [4, 3], [2, 2], [3, 3], [1, 2], [0, 2]", s.points.join(", ")

     s = Shape.create [[0,0], [5,0], [5,10], [0,10], [5,2], [4,2], [4,3], [5,3], [5,8], [4, 8], [4,7], [5,7]]
     assert_equal "[0, 0], [5, 0], [5, 2], [4, 2], [5, 3], [4, 3], [5, 7], [5, 8], [4, 7], [4, 8], [5, 10], [0, 10]", s.points.join(", ")

     s = Shape.create [[0,0], [6,0], [6,9], [0,9], [0,8], [1,8], [1,7], [0,7], [0,3], [1,3], [1,2], [0,2]]
     assert_equal "[0, 0], [6, 0], [6, 9], [1, 2], [1, 3], [1, 7], [1, 8], [0, 9], [0, 8], [0, 7], [0, 3], [0, 2]", s.points.join(", ")
   end

   test "hull point" do
     s = Shape.new
     p1 = Point.new(x: 1, y: 1)
     p2 = Point.new(x: 6, y: 1)
     p3 = Point.new(x: 6, y: 3)
     assert_equal true, s.left_turn?(p1, p2, p3)
     assert_equal false, s.right_turn?(p1, p2, p3)

     p1 = Point.new(x: 1, y: 1)
     p2 = Point.new(x: 6, y: 3)
     p3 = Point.new(x: 6, y: 1)
     assert_equal true, s.right_turn?(p1, p2, p3)
     assert_equal false, s.left_turn?(p1, p2, p3)
   end

   test "hull algorithm" do
     s = Shape.create [[6,1], [5,2], [4,3], [3,3], [2,2], [1,1], [6,2], [6,3], [1,2], [0,2]]
     assert_equal "[1, 1], [6, 1], [6, 2], [5, 2], [6, 3], [4, 3], [2, 2], [3, 3], [1, 2], [0, 2]", s.points.join(", ")
     assert_equal "[1, 1], [6, 1], [6, 3], [3, 3], [0, 2]", s.hull_points.join(", ")
     assert_equal "[1, 1], [6, 1], [6, 2], [5, 2], [6, 3], [4, 3], [2, 2], [3, 3], [1, 2], [0, 2]", s.points.join(", ")

     s = Shape.create [[5,0], [0,0], [5,10], [0,10], [5,2], [4,2], [4,3], [5,3], [5,8], [4, 8], [4,7], [5,7]]
     assert_equal "[0, 0], [5, 0], [5, 2], [4, 2], [5, 3], [4, 3], [5, 7], [5, 8], [4, 7], [4, 8], [5, 10], [0, 10]", s.points.join(", ")
     assert_equal "[0, 0], [5, 0], [5, 10], [0, 10]", s.hull_points.join(", ")
     assert_equal "[0, 0], [5, 0], [5, 2], [4, 2], [5, 3], [4, 3], [5, 7], [5, 8], [4, 7], [4, 8], [5, 10], [0, 10]", s.points.join(", ")

     s = Shape.create [[6,0], [0,0], [6,9], [0,9], [0,8], [1,8], [1,7], [0,7], [0,3], [1,3], [1,2], [0,2]]
     assert_equal "[0, 0], [6, 0], [6, 9], [1, 2], [1, 3], [1, 7], [1, 8], [0, 9], [0, 8], [0, 7], [0, 3], [0, 2]", s.points.join(", ")
     assert_equal "[0, 0], [6, 0], [6, 9], [0, 9]", s.hull_points.join(", ")
     assert_equal "[0, 0], [6, 0], [6, 9], [1, 2], [1, 3], [1, 7], [1, 8], [0, 9], [0, 8], [0, 7], [0, 3], [0, 2]", s.points.join(", ")

     s = Shape.create [[6,1], [-1,2], [5,2], [4,3], [3,3], [2,2], [1,1], [6,2], [6,3], [1,2], [0,2]]
     assert_equal "[1, 1], [6, 1], [6, 2], [5, 2], [6, 3], [4, 3], [2, 2], [3, 3], [1, 2], [0, 2], [-1, 2]", s.points.join(", ")
     assert_equal "[1, 1], [6, 1], [6, 3], [3, 3], [-1, 2]", s.hull_points.join(", ")
     assert_equal "[1, 1], [6, 1], [6, 2], [5, 2], [6, 3], [4, 3], [2, 2], [3, 3], [1, 2], [0, 2], [-1, 2]", s.points.join(", ")

     s = Shape.create [[6,1], [-1,-1], [5,2], [4,3], [3,3], [2,2], [1,1], [6,2], [6,3], [1,2], [0,2]]
     assert_equal "[-1, -1], [6, 1], [6, 2], [5, 2], [6, 3], [4, 3], [1, 1], [2, 2], [3, 3], [1, 2], [0, 2]", s.points.join(", ")
     assert_equal "[-1, -1], [6, 1], [6, 3], [3, 3], [0, 2]", s.hull_points.join(", ")
     assert_equal "[-1, -1], [6, 1], [6, 2], [5, 2], [6, 3], [4, 3], [1, 1], [2, 2], [3, 3], [1, 2], [0, 2]", s.points.join(", ")

     s = Shape.create [[6,1], [1,-1], [5,2], [4,3], [3,3], [2,2], [1,1], [6,2], [6,3], [1,2], [0,2]]
     assert_equal "[1, -1], [6, 1], [6, 2], [5, 2], [6, 3], [4, 3], [3, 3], [2, 2], [1, 2], [1, 1], [0, 2]", s.points.join(", ")
     assert_equal "[1, -1], [6, 1], [6, 3], [3, 3], [0, 2]", s.hull_points.join(", ")
     assert_equal "[1, -1], [6, 1], [6, 2], [5, 2], [6, 3], [4, 3], [3, 3], [2, 2], [1, 2], [1, 1], [0, 2]", s.points.join(", ")

     s = Shape.create [[-6,-1], [-5,-2], [-4,-3], [-3,-3], [-2,-2], [-1,-1], [-6,-2], [-6,-3], [-1,-2], [0,-2]]
     assert_equal '[-6, -3]', s.lowest_yx_coordinate.to_s
     assert_equal "[-6, -3], [-4, -3], [-3, -3], [0, -2], [-1, -2], [-2, -2], [-1, -1], [-5, -2], [-6, -1], [-6, -2]", s.points.join(", ")
     assert_equal "[-6, -3], [-3, -3], [0, -2], [-1, -1], [-6, -1]", s.hull_points.join(", ")
     assert_equal "[-6, -3], [-4, -3], [-3, -3], [0, -2], [-1, -2], [-2, -2], [-1, -1], [-5, -2], [-6, -1], [-6, -2]", s.points.join(", ")

     s = Shape.create [[2,1], [1,-1], [1,-3], [-2,2], [-1,-1], [-2,-2], [-3,-3], [-2,-3], [-1,-3]]
     assert_equal '[-3, -3]', s.lowest_yx_coordinate.to_s
     assert_equal "[-3, -3], [-2, -3], [-1, -3], [1, -3], [1, -1], [2, 1], [-2, -2], [-1, -1], [-2, 2]", s.points.join(", ")
     assert_equal "[-3, -3], [1, -3], [2, 1], [-2, 2]", s.hull_points.join(", ")
     assert_equal "[-3, -3], [-2, -3], [-1, -3], [1, -3], [1, -1], [2, 1], [-2, -2], [-1, -1], [-2, 2]", s.points.join(", ")

     s = Shape.create [[2,0], [2,-1], [2,-2], [1, -2], [0, -2], [-1,-2], [-2,-2], [-2,-1], [-2,0], [-2,1], [-2,2], [-1,2], [0,2], [1,2], [2,2], [2,1]]
     assert_equal '[-2, -2]', s.lowest_yx_coordinate.to_s
     assert_equal "[-2, -2], [-1, -2], [0, -2], [1, -2], [2, -2], [2, -1], [2, 0], [2, 1], [2, 2], [1, 2], [0, 2], [-1, 2], [-2, 2], [-2, 1], [-2, 0], [-2, -1]", s.points.join(", ")
     assert_equal "[-2, -2], [2, -2], [2, 2], [-2, 2]", s.hull_points.join(", ")

     s = Shape.create [[2,2], [2,-2], [-2,-2], [-2,2]]
     assert_equal '[-2, -2]', s.lowest_yx_coordinate.to_s
     assert_equal '[-2, -2], [2, -2], [2, 2], [-2, 2]', s.points.join(", ")
     assert_equal '[-2, -2], [2, -2], [2, 2], [-2, 2]', s.hull_points.join(", ")
     assert_equal '[-2, -2], [2, -2], [2, 2], [-2, 2]', s.points.join(", ")

     s = Shape.create [[2,-2], [-2,-2], [-2,2]]
     assert_equal '[-2, -2]', s.lowest_yx_coordinate.to_s
     assert_equal '[-2, -2], [2, -2], [-2, 2]', s.points.join(", ")
     assert_equal '[-2, -2], [2, -2], [-2, 2]', s.hull_points.join(", ")
     assert_equal '[-2, -2], [2, -2], [-2, 2]', s.points.join(", ")

     s = Shape.create [[1,1], [2,1], [3,1]]
     assert_equal '[1, 1]', s.lowest_yx_coordinate.to_s
     assert_equal '[1, 1], [2, 1], [3, 1]', s.points.join(", ")
     assert_equal '[1, 1]', s.hull_points.join(", ")
     assert_equal '[1, 1], [2, 1], [3, 1]', s.points.join(", ")

     # Shower door 
     s = Shape.create [[-0.0625, -0.0625], [-0.0625, 67.5625], [-0.0625, -0.0625], [23.6875, -0.0625], [23.6875, -0.0625], [23.6875, 10.75], [23.6875, 10.75], [22.8832756331392, 10.75], [22.8832756331392, 10.75], [22.5968646522044, 10.75], [21.875, 11.3489109809347], [21.875, 11.1614109809347], [21.875, 11.3489109809347], [21.875, 12.6510890190653], [21.875, 12.8385890190653], [21.875, 12.6510890190653], [22.5968646522044, 13.25], [22.8832756331392, 13.25], [22.8832756331392, 13.25], [23.6875, 13.25], [23.6875, 13.25], [23.6875, 54.25], [23.6875, 56.75], [22.8832756331392, 56.75], [22.8832756331392, 56.75], [22.5968646522044, 56.75], [21.875, 56.1510890190653], [21.875, 56.3385890190653], [21.875, 56.1510890190653], [21.875, 54.8489109809347], [21.875, 54.6614109809347], [21.875, 54.8489109809347], [22.5968646522044, 54.25], [22.8832756331392, 54.25], [22.8832756331392, 54.25], [23.6875, 54.25], [23.6875, 56.75], [23.6875, 67.5625], [-0.0625, 67.5625], [23.6875, 67.5625]] 
     assert_equal "[-0.0625, -0.0625], [23.6875, -0.0625], [23.6875, 67.5625], [-0.0625, 67.5625]", s.hull_points.join(", ")

     # Panel with notch on bottom right
     s = Shape.create [[-0.0625, 0.0], [-0.0625, 92.0625], [-0.0625, 0.0], [9.75, 0.0], [9.75, 0.0], [9.87266791044776, 16.4375], [10.1875, 16.75], [11.75, 16.75], [11.75, 16.75], [11.75, 92.0625], [-0.0625, 92.0625], [11.75, 92.0625]] 
     assert_equal "[-0.0625, 0.0], [9.75, 0.0], [11.75, 16.75], [11.75, 92.0625], [-0.0625, 92.0625]", s.hull_points.join(", ")

     # Panel with notch on bottom left
     s = Shape.create [[-0.0625, 15.75], [-0.0625, 76.875], [-0.0625, 15.75], [12.125, 15.75], [12.4375, 0.0], [12.4375, 15.4375], [12.4375, 0.0], [24.25, 0.0], [24.25, 0.0], [24.25, 76.875], [-0.0625, 76.875], [24.25, 76.875]] 
     assert_equal "[12.4375, 0.0], [24.25, 0.0], [24.25, 76.875], [-0.0625, 76.875], [-0.0625, 15.75]", s.hull_points.join(", ")
   
   end
end

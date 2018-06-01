# README

This code is used to find 2D convex hull using Graham scan.

For more info: https://en.wikipedia.org/wiki/Graham_scan

Create a new rails app.

Copy point.rb and shape.rb into app/models

Copy shape_test.rb into test/models

run 'rake test' to run the tests

In the rails console try the following:

s = Shape.create [[6,1], [5,2], [4,3], [3,3], [2,2], [1,1], [6,2], [6,3], [1,2], [0,2]]

s.hull_points.join(', ')

This README would normally document whatever steps are necessary to get the
application up and running.


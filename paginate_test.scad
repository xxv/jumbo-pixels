use <paginate.scad>

// A demo of paginate.scad

// The stock material (aka the page size)
stock = [32, 10, 1];

// The full size of the object to be paginated
test = [51, 30, stock[2]];

// Spacing between the holes
test_spacing = [7, 7, 10];

// The size of the holes
hole_size = [5, 5, test[2]];

paginate(test, stock, snap=test_spacing,
         first_page_offset=[
           (test_spacing[0] - hole_size[0])/2,
           (test_spacing[1] - hole_size[1])/2,
           0]
        ) {
  grid(test, test_spacing, hole_size);
}

// Here's what the grid looks like non-paginated
translate([0, -30, 0])
  grid(test, test_spacing, hole_size);

// A grid of holes with a border
module grid(dim, spacing, hole_size) {
  difference() {
    cube(dim);

    for (y = [ spacing[1] - hole_size[1]: spacing[1] : dim[1] - dim[1] % spacing[1] ]) {
      for (x = [ spacing[0] - hole_size[0] : spacing[0] : dim[0] - dim[0] % spacing[0] ]) {
        translate([x, y, -1])
          cube(hole_size + [0, 0, 2]);
      }
    }
  }
}



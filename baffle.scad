// The size of a piece of stock material
stock=[610, 457, 1.5875];

// the full size of the display
display=[2440, 502, 50];

// the size an individual pixel needs to be
pixel=[33.334, 33.334, display[2]];

led_strip_width=10;
led_strip_thickness=0.3;
apa102=[5,5,1.5];

preview();
//cut_short();
//cut_long();

short_strip_rows = [ for (x = [pixel[0] : pixel[0] : display[0] - pixel[0]]) x ];
long_strip_rows  = [ for (x = [pixel[1] : pixel[1] : display[1] - pixel[1]]) x ];

module cut_long() {
  copies = [ for ( x = [ 0 : display[2] + 1 : stock[1] - display[2] ]) x ];
  projection(cut = true) {
    for (x = copies) {
      translate([0, x, 0])
        rotate([-90, 0, 0])
          render(convexity = 2)
            long_strip();
    }
  }

  color("blue", alpha=0.2)
    cube(stock);
  echo("there are ", len(long_strip_rows), " long strips");
  echo("make ", ceil(len(long_strip_rows) / len(copies)), " copies of the long strips" );
}

module cut_short() {
  copies = [ for ( x = [ 0 : display[2] + 1 : stock[1] - display[2] ]) x ];
  projection(cut = true) {
    for (x = copies) {
      translate([0, x, 0])
        rotate([-90, 0, 0])
          render(convexity = 2)
            short_strip();
    }
  }

  color("blue", alpha=0.2)
    cube(stock);
  echo("there are ", len(short_strip_rows), " short strips");
  echo("make ", ceil(len(short_strip_rows) / len(copies)), " copies of the short strips" );
}

led_strip_offset = (pixel[0] / 2 - led_strip_width/2) + stock[2] + stock[2]/2;

module preview(){
  for (y = [led_strip_offset : pixel[1] : (display[1] - pixel[1]) + led_strip_offset])
    translate([0, y, 0])
      led_strip(display[0], 30);

  for (x = short_strip_rows) {
      translate([x, stock[2], display[2]])
        rotate([180, 0, 90])
        render(convexity=2)
          short_strip();
  }
  translate([0, stock[2], 0])
    for (y = long_strip_rows) {
      translate([0, y, 0])
        render(convexity=2)
        long_strip();
    }

  color(alpha=0.2)
  cube(display);
}

module led_strip(length, led_per_meter) {
  led_spacing=1000/led_per_meter;
  color("white") {
    cube([length, led_strip_width, led_strip_thickness]);
    for (x = [0 : led_spacing: length - led_spacing]) {
      translate([led_spacing/2 + x,(led_strip_width/2-apa102[1]/2), led_strip_thickness])
      cube(apa102);
    }
  }
}

module short_strip() {
  difference() {
    cube_with_slots_snap([display[1], stock[2], display[2]], pixel[0], [stock[2], stock[2] * 2, display[2]/2]);
    for (x = [pixel[0] / 2 - led_strip_width/2 + stock[2]/2: pixel[0] : display[1]]) {
      translate([x, -stock[2]/2, display[2]-led_strip_thickness])
        cube([led_strip_width, stock[2] * 2, led_strip_thickness*2]);
    }
  }
}

module long_strip() {
  cube_with_slots_snap([display[0], stock[2], display[2]], pixel[0], [stock[2], stock[2] * 2, display[2]/2]);
}

module cube_with_slots_snap(cube_size, slot_spacing, slot_size) {
  difference() {
    cube_with_slots(cube_size, slot_spacing, slot_size);
    translate([(cube_size[0]) - (cube_size[0] % slot_spacing), -cube_size[1]/2, -cube_size[2]/2 ])
      cube([slot_spacing + 1, cube_size[1] * 2, cube_size[2] * 2]);
  }
}

module cube_with_slots(cube_size, slot_spacing, slot_size) {
  difference() {
    cube(cube_size);
    for (x = [slot_spacing : slot_spacing : cube_size[0]]) {
      translate([x, -0.5, -1])
        cube(slot_size + [0, 0, 1]);
    }
  }
}

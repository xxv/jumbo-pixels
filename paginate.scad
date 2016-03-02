module paginate(bounds, page, snap=[0,0,0], first_page_offset=[0, 0, 0], spacing=[10,10,10]) {
  echo(bounds);
  echo(page);
  echo(snap);
  echo(first_page_offset);
  echo(spacing);

  page_offset = page - first_page_offset * 2;
  crop = [bounds[0] > page_offset[0] ? (page_offset[0] - (page_offset[0] % snap[0])) : page[0],
          bounds[1] > page_offset[1] ? (page_offset[1] - (page_offset[1] % snap[1])) : page[1],
          page[2]];

  page_bounds = bounds - first_page_offset * 2;

  pages = [
           max(1, ceil(page_bounds[0]/crop[0])),
           max(1, ceil(page_bounds[1]/crop[1])),
           1 /* only 2D paging for now */
           ];

    echo("Crop: ", crop);
    echo("Pages: ", pages);
    for (page_y = [ 0 : 1 : pages[1] - 1] ) {
      for (page_x = [ 0 : 1 : pages[0] - 1] ) {
        page_offset_x = page_x * crop[0];
        page_offset_y = page_y * crop[1];

        translate([
          spacing[0]  + (spacing[0] + page[0]) * page_x,
          spacing[1]  + (spacing[1] + page[1]) * page_y,
          0
        ]) {
          translate([-page_offset_x, -page_offset_y, 0])
          intersection() {
            translate([page_offset_x, page_offset_y, 0])
              cube(crop + [
                  page_x == 0 ? first_page_offset[0] : 0,
                  page_y == 0 ? first_page_offset[1] : 0,
                  0
                ] + [
                  page_x >= (pages[0] - 1) ? page[0] - crop[0] : 0,
                  page_y >= (pages[1] - 1) ? page[1] - crop[1] : 0,
                  0
                ]);
              translate([
                page_x > 0 ? -first_page_offset[0] : 0,
                page_y > 0 ? -first_page_offset[1] : 0,
                0])
                render()
                  children();
          }

%       translate([0, 0, -page[2] - 0.1])
          color("red", alpha=0.2)
            cube(page);
        }
      }
    }
}



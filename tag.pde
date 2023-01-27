class Tag {

  PVector pos;
  String name;
  boolean selected;



  Tag(String n, float x, float y) {

    pos  = new PVector(x, y);
    name = n;
    selected = false;
  }



  void display() {

    if (dist(worldX, worldY, this.pos.x, this.pos.y) < 20) {

      if (mousePressed == true && this.selected == false) {

        this.selected = true;
        selectedTagsNames.add(this.name);
        selectedTags.add(this);
        //println(selectedTags);

      } else if (mousePressed == true && this.selected == true) {

        this.selected = false;
        selectedTagsNames.remove(String.valueOf(this.name));

      }
    }

    if (this.selected == true) {
      fill(96, 63, 139);
    } else {
      fill(161, 106, 232);
    }

    noStroke();
    circle(this.pos.x, this.pos.y, 10 * (1.2 / scale) );
    textAlign(CENTER);
    textSize(10 * (1.2 / scale));
    text(this.name, this.pos.x, this.pos.y + (20 * (1.15 / scale)));
  }
}

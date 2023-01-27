class TagsGrid {
  
  int x, y;
  int step = 1;
  int state = 0;
  int numSteps = 1;
  int turnCounter = 1;

  String  [] tags;


  int stepSize;
  int totalSteps;

  //ArrayList<Tag> selected_tags;


  TagsGrid(String [] s) {

    stepSize = width / 4;
    totalSteps = s.length;
    x = width / 2;
    y = height / 2;
    tags   = s;
    points = new ArrayList<Tag>();
    //selected_tags = new ArrayList<Tag>();

    for (int i = 0; i < tags.length - 1; i ++) {

      Tag t = new Tag(tags[i], x, y);
      points.add(t);



      // Move according to state
      switch (state) {
      case 0:
        x += stepSize;
        break;
      case 1:
        y -= stepSize;
        break;
      case 2:
        x -= stepSize;
        break;
      case 3:
        y += stepSize;
        break;
      }

      // Change state
      if (step % numSteps == 0) {
        state = (state + 1) % 4;
        turnCounter++;
        if (turnCounter % 2 == 0) {
          numSteps++;
        }
      }
      step++;
    }
  }



  void display() {

    if (view_tags == true) {

      for (int i = 1; i < points.size(); i++) {
        Tag t = points.get(i);
        //println(t.name);
        t.display();
        if (t.selected == true) {
          //selected_tags.add(t);
        }
      }

      if (step > totalSteps) {
        noLoop();
      }
    }
  }


  //void draw_lines() {

  //  for (int i = 0; i < nodes.length; i++ ) {
  //    for (int j = 0; j < nodes[i].tags.length; j ++) {
  //      if (nodes[i].tags[j].equals(t.name)) {
  //      }
  //    }
  //  }
  //}
}

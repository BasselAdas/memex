class Node {

  float x, y;
  int radius;
  String title;
  String [] tags;
  String [] body;
  String [] sentence;
  int no; 
  String last_read_date;
  long decay;
  int f;
  float distance;

  ArrayList<PVector> tags_coords;
  ArrayList<PVector> links_coords;

  boolean unique;
  boolean selected;


  Node(String s, String f, String t, int n) {

    title = s;
    body  = loadStrings(f); // creates an array of the files individual lines 
    tags  = split(t, ','); 
    //radius = 20;
    tags_coords  = new ArrayList<PVector>();
    links_coords = new ArrayList<PVector>();
    no = n;
    selected = false;
  }


  void calculate_decay() {
    decay = ChronoUnit.DAYS.between(d_dates[no], LocalDate.now());
  }


  void decide_fill() {

    if (decay <= 30) {
      f = int(235 - (decay * 3));
    } else {
      f = 0;
    }
  }


  void find_links() {
    for (String s : body) {
      String [] words = split(s, ' ');

      if (words[0].equals("*")) {

        String[] links = split(words[1], ',');

        for (String l : links) {
          String[] address = split(s, ':');
          PVector v = new PVector(nodes[int(address[0])].x, nodes[int(address[0])].y);
          links_coords.add(v);
        }
      }
    }
  }


  void draw_links() {
    //if (view_links == true) {
    for (int i = 0; i < links_coords.size(); i ++) {
      stroke(253, 73, 160);
      line(this.x, this.y, links_coords.get(i).x, links_coords.get(i).y);
    }
    //}
  }


  void calculate_pos() {

    for (int i = 0; i < tags.length; i ++) {//loop through the tags of the node
      for (int j = 0; j < points.size(); j ++) {//loop through the tags in th tags grid 
        if (tags[i].equals(points.get(j).name)) {//if a node tag equals a grid tag  
          tags_coords.add(points.get(j).pos);// save the grid tag's coordinate
        }
      }
    }

    int a = 0;
    int b = 0;

    for (int i = 0; i < tags_coords.size(); i ++) {//loop through the positins of the match grid tags 
      a += tags_coords.get(i).x;//add all the x components together
      b += tags_coords.get(i).y;//add all the y components together
    }

    this.x = (a / tags_coords.size()) + random(40, 60);//take the average of the Xs
    this.y = (b / tags_coords.size()) + random(40, 60);//take the average of the Ys
  }


  void calc_dist() {
    if (dragging == false && reading == false && showing_results == false ) {
      distance = dist(worldX, worldY, x, y);
    }
  }


  void calc_radius() {

    ArrayList<String> t1 = new ArrayList<String>(Arrays.asList(tags));
    Collections.sort(t1);

    for (int i = 0; i < all_tag_combs.size(); i++) {
      ArrayList<String> t2 = new ArrayList<String>(all_tag_combs.get(i).tags_combination);
      Collections.sort(t2);


      if (t1.equals(t2) == true) {
        radius = 20 - (3 * all_tag_combs.get(i).num_of_matches);
      }
    }
  }


  void show_relations() {
    if (this.selected == true) {
      stroke(161, 106, 232);
      for (int i = 0; i < tags_coords.size(); i ++) {
        line(x, y, tags_coords.get(i).x, tags_coords.get(i).y );
        //tags_coords.get(i).display();
      }
      this.draw_links();
      fill(0);
      textAlign(CENTER);
      textSize(15 * (1.2 / scale));
      text(title, x, y + radius + 3);
    }
  }



  void connect_to_tags() {
    if (selectedTagsNames.size() > 0) {
      ArrayList<String> t1 = new ArrayList<String>(Arrays.asList(tags));
      if (t1.containsAll(selectedTagsNames)) {
        for (int i = 0; i < selectedTags.size(); i++) {
          stroke(0);
          line(x, y, selectedTags.get(i).pos.x, selectedTags.get(i).pos.y );
        }
      }
    }
  }




  void drawEllipse() {

    if (reading == false) {

      if (distance < radius) {


        if (mousePressed == true && this.selected == false) {
          //fill(0);
          this.selected = true;
        } else if (mousePressed == true && this.selected == true) {
          //fill(180);
          this.selected = false;
        }


        fill(f);
        noStroke();
        ellipse(x, y, radius * 1.25, radius * 1.25);
        fill(0);
        textAlign(CENTER);
        textSize(15 * (1.2 / scale));
        text(title, x, y + radius + 3);




        if (double_clicked == true) {
          reading = true;
          tv.text = body;
          last_opened_id = this.no;
        }
      } else {

        fill(f);
        noStroke();
        ellipse(x, y, radius, radius);
        if (view_titles == true) {
          fill(150);
          textAlign(CENTER);
          textSize(15* (1 / scale));
          text(title, x, y + radius + 3);
        }
      }
    }
  }



  //void draw_text() {

  //  translate(x, y);
  //  //noFill();
  //  //stroke(0);
  //  //ellipse(0, 0, r*2, r*2);

  //  // We must keep track of our position along the curve
  //  float arclength = 0;

  //  // For every box
  //  for (int i = 0; i < title.length(); i++)
  //  {
  //    // Instead of a constant width, we check the width of each character.
  //    char currentChar = title.charAt(i);
  //    float w = textWidth(currentChar);

  //    // Each box is centered so we move half the width
  //    arclength += w/2;
  //    // Angle in radians is the arclength divided by the radius
  //    // Starting on the left side of the circle by adding PI
  //    float theta = PI + arclength / radius;

  //    pushMatrix();
  //    // Polar to cartesian coordinate conversion
  //    translate(radius*cos(theta), radius*sin(theta));
  //    // Rotate the box
  //    rotate(theta+PI/2); // rotation is offset by 90 degrees
  //    // Display the character
  //    fill(0);
  //    text(currentChar, 0, 0);
  //    popMatrix();
  //    // Move halfway again
  //    arclength += w/2;

  //  }
  //}
}

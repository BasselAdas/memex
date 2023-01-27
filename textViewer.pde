class TextViewer {

  String [] text;
  int line  =  0;
  Textarea  note;

  TextViewer() {

    note = cp5.addTextarea("nt")
      .setPosition(200, 200)
      .setSize(400, 400)
      .setFont(f)
      .setLineHeight(30)
      .setColor(color(0))
      .setColorBackground(color(255))
      .setColorForeground(color(255))
      .setVisible(false);
  }


  void display() {
    if (reading == true && line <= text.length - 1) {
      note.setVisible(true);
      fill(255);
      noStroke();
      rectMode(CORNER);
      rect(0, 0, 800, 900);

      //rectMode(CENTER);
      //fill(0);
      //textFont(f);
      ////textSize(20);
      //text(text[line], 400, 400, 400, 400);
      note.setText(text[line]);

      check_link (text[line]);
    } else if (reading == false) {
      note.setVisible(false);
    }
  }


  void check_link(String l) {
    String [] words = split(l, ' ');

    if (words[0].equals("*")) {

      int y = 0;
      String[] links = split(words[1], ',');

      for (String s : links) {
        String[] address = split(s, ':');

        textSize(10);
        rectMode(CORNER);
        text(nodes[int(address[0])].title + ":" + nodes[int(address[0])].body[int(address[1]) - 1], 5, 500 + y, 800, 400);
        y += 100;
      }
    }
  }
}

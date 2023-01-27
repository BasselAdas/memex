class UiManager {

  Textarea       selectedResult;
  Textfield      searchField;
  int line = 0;



  UiManager() {


    searchField = cp5.addTextfield("input")
      .setPosition(20, 20)
      .setSize(200, 45)
      .setFocus(false)
      .setColor(color(120))
      .setColorBackground(color(240, 240, 240, 200))
      .setFont(createFont("arial", 20))
      .setColorCursor(color(0, 0, 0))
      .setVisible(searching)
      ;



    selectedResult = cp5.addTextarea("txt")
      .setPosition(19, 450)
      .setSize(781, 400)
      .setFont(f)
      .setLineHeight(30)
      .setColor(color(0))
      .setColorBackground(color(255))
      .setColorForeground(color(255))
      .setBorderColor(color(0))
      .setVisible(false);
  }


  public void search() {
    searchText = searchField.getText();
    if (searchText != "") {
      searchResults = new ArrayList<String>();
      for (int i = 0; i < nodes.length; i++ ) {
        for (int j = 0; j < nodes[i].body.length; j++ ) {
          String [] words = split(nodes[i].body[j], ' ');
          if (words[0].equals("-") == false) {
            String[] m = match(nodes[i].body[j], searchText);
            if (m != null) {  
              searchResults.add(nodes[i].body[j]);
            }
          }
        }
      }
      showing_results = true;
    }
  }


  void display_results() {
    if (ui.line < searchResults.size() - 1) {
      selectedResult.setText(searchResults.get(ui.line));
    }
  }



  //public void clean() {
  //  resultList.clear();
  //  selectedResult.clear();
  //}
}

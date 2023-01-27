import java.util.*;
import java.util.Arrays;
import controlP5.*;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;


Node[] nodes;
ControlP5 cp5;
DataManager dm;
TextViewer  tv;
TagsGrid    tg;
PanZoomController panZoomController;
UiManager ui;

boolean pressed;
boolean reading;
boolean showing_results;
boolean view_tags;
boolean view_links;
boolean view_titles;
boolean searching;
boolean dragging;
boolean double_clicked;

float radius;
float savedTransX;
float savedTransY;
float worldX, worldY;
float scroll;
float scale;

PVector pan;

ArrayList<Tag> points;
ArrayList<PVector> nodes_coords;
ArrayList<String>  searchResults;
ArrayList<String>  selectedTagsNames;
ArrayList<Tag>     selectedTags;
ArrayList<TagComb> all_tag_combs;




int last_opened_id;

JSONObject json;
JSONArray nodeData;

PrintWriter output;

LocalDate [] d_dates;


String searchText = "";

PFont f;



void setup() {

  size(800, 900);
  f = createFont("Georgia", 25, true);

  cp5 = new ControlP5(this);
  all_tag_combs = new ArrayList<TagComb>();
  selectedTagsNames  = new ArrayList<String>();
  panZoomController = new PanZoomController(this);
  dm = new DataManager();
  tv = new TextViewer();
  ui = new UiManager();
  dm.loadData();
  tg = new TagsGrid(dm.final_tags);
  nodes_coords  = new ArrayList<PVector>();
  selectedTags  = new ArrayList<Tag>();


  output = createWriter("data/dates.txt");

  pressed     = false;
  reading     = false;
  view_tags   = true;
  view_links  = false;
  view_titles = false;
  searching   = false;
  showing_results = false;


  for (int i = 0; i < nodes.length; i++) {
    nodes[i].calc_radius();
    nodes[i].calculate_pos();
    nodes[i].calculate_decay();
    nodes[i].decide_fill();
    nodes[i].find_links();
  }
}




void draw() {

  pan   = panZoomController.getPan();
  scale = panZoomController.getScale();

  background(255); 


  pushMatrix();

  translate(pan.x, pan.y);
  scale(scale);
  calcMouseWorldPos(pan.x, pan.y, scale);


  for (int i = 0; i < nodes.length; i++ ) {
    nodes[i].calc_dist();
    nodes[i].show_relations();
    nodes[i].drawEllipse();
    nodes[i].connect_to_tags();
  }

  tg.display();

  popMatrix();

  tv.display();
}



void calcMouseWorldPos(float a, float b, float s) {
  worldX = (mouseX - a) / s; //calculate mouseX relative to translated new origin 
  worldY = (mouseY - b) / s;//calculate mouseY relative to translated new origin
}


void keyPressed() {

  if ((key == 'c' || key == 'C') && (ui.searchField.isActive() == false)) {//exit reading mode

    //ui.resultList.clear();
    ui.selectedResult.clear();
    //ui.resultList.setVisible(false);
    ui.selectedResult.setVisible(false);
    searchResults.clear();
    showing_results = false;
    ui.line = 0;
    
  } else if ((key == 't' || key == 'T') && (ui.searchField.isActive() == false)) {//show tags grid

    view_tags = !view_tags;
    
  } else if ((key == 'e' || key == 'E') && (ui.searchField.isActive() == false)) {//exit the program

    for (int i = 0; i < d_dates.length; i++) {//loop through the dates array and write them line by line. 
      output.println(d_dates[i]);
    } 
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
    exit(); // Stops the program
  } else if ((key == 'l' || key == 'L') && (ui.searchField.isActive() == false)) {

    view_links = !view_links;
    
  } else if ((key == 's' || key == 'S') && (ui.searchField.isActive() == false)) {

    searching = !searching;
    ui.searchField.setVisible(searching);
    //ui.resultList.setVisible(false);
  } else if (key == ENTER && ui.searchField.isActive() == true ) {

    ui.search();
    ui.selectedResult.setVisible(true);
    
  } else if ((key == 'm' || key == 'M') && (ui.searchField.isActive() == false)) {

    reading = false; //so that the white background of textview stops being rendered. 
    tv.line = 0; //so that when another node is opened it starts from the first line.
    double_clicked = false;
    
  } else if ((key == 'x' || key == 'X') && (ui.searchField.isActive() == false)) {

    if (reading == true) {
      reading = false; //so that the white background of textview stops being rendered. 
      tv.line = 0; //so that when another node is opened it starts from the first line.
      d_dates[last_opened_id] = LocalDate.now();//update the last read date of the recently closed node to todays, and populated in its position in the dates array
      nodes[last_opened_id].calculate_decay();//update the color of the recently read node
      nodes[last_opened_id].decide_fill();
      double_clicked = false;
    }
  } else if ((key == 'h' || key == 'H') && (ui.searchField.isActive() == false)) {

    view_titles = !view_titles;
  }


  if (key == CODED) {
    if (keyCode == UP) {
      if (reading == true) {
        if (tv.line > 0) {
          tv.line -= 1;
        }
      }

      if (showing_results == true) {
        if (ui.line > 0) {
          ui.line -= 1;
        }
        ui.display_results();
       
      }
    } else if (keyCode == DOWN) {

      if (reading == true) {
        tv.line += 1;
      }

      if (showing_results == true) {
        ui.line += 1;
        ui.display_results();
      }
    }
  }
}

void mouseDragged() {
  panZoomController.mouseDragged();
  dragging = true;
}

void mouseWheel(MouseEvent event) {
  
  if(ui.selectedResult.isMouseOver() == false && ui.searchField.isMouseOver() == false && reading == false){
      panZoomController.mouseWheel(event.getCount());
  }

}


void mouseReleased() {
  dragging = false;
}


void mousePressed() {

  if (mouseEvent.getClickCount()==2) {  // double-click
    double_clicked = true;
  }
}



public void dispose() {
  for (int i = 0; i < d_dates.length; i++) {//loop through the dates array and write them line by line. 
    output.println(d_dates[i]);
  } 
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
}

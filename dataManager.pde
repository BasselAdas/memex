class DataManager {

  String all_tags = " ";
  String [] final_tags = {}; //tags filtered from duplicates to use in creating the tags grid 

  DataManager() {
  }


  void loadData() {

    json     = loadJSONObject("meta.json");
    nodeData = json.getJSONArray("nodes");
    nodes    = new Node[nodeData.size()];
    String [] s_dates    = loadStrings("dates.txt");
    d_dates = new LocalDate[s_dates.length];
    
    
    for (int i = 0; i < s_dates.length; i++){
      LocalDate d = LocalDate.parse(s_dates[i]);
      d_dates[i]  = LocalDate.parse(s_dates[i]);
      //println(d);
    }



    for (int i = 0; i <  nodeData.size(); i++) { //loop through the meta data for each node in JSON file 

      JSONObject node = nodeData.getJSONObject(i);

      String title = node.getString("title");
      String file  = node.getString("file");
      all_tags    += node.getString("tags");
      int num      = node.getInt("n");
      TagComb tg   = new TagComb(node.getString("tags"));
      tg.decide(i, tg);

      nodes[i] = new Node(title, file, node.getString("tags"), num);
    }



    String[] tags_array = split(all_tags, ',');

    for (int i = 0; i < tags_array.length; i++) {

      if (!valueIsInArray(tags_array[i], final_tags)) {
        final_tags = append(final_tags, tags_array[i]);
      }
    }

    //println(final_tags);
  }





  boolean valueIsInArray(String s, String[] arr) {
    for (int i = 0; i < arr.length; i++) {
      if (s.equals(arr[i])) {
        return true;
      }
    }
    return false;
  }
}

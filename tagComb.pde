class TagComb {
  ArrayList<String> tags_combination;
  int num_of_matches;


  TagComb(String s) {

    tags_combination = new ArrayList<String>();
    String[] tags_array = split(s, ',');

    for (int i = 0; i < tags_array.length; i++) {

      tags_combination.add(tags_array[i]);
      
    }
    num_of_matches = 1;
  }



  void decide(int n, TagComb tc) {//decide if we should add the tag combination to the arrayList of all unique combinations

    if (n==0) {//if this is the tags combination of the first node then we can add it immediatly without checking if such a combination already exists

      all_tag_combs.add(tc);//adding it to the unique tag combinations
      
    } else {
      
      ArrayList<String> t1 = new ArrayList<String>(tc.tags_combination);
      Collections.sort(t1);
      for (int i = 0; i < all_tag_combs.size(); i++) {
        ArrayList<String> t2 = new ArrayList<String>(all_tag_combs.get(i).tags_combination);

        //to avoid messing the order of the lists we will use a copy
        //t1 = new ArrayList<String>(t1); 
        //t2 = new ArrayList<String>(t2);   

        //Collections.sort(t1);
        Collections.sort(t2);


        if (t1.equals(t2) == true) {
          tc.num_of_matches += 1;
          all_tag_combs.get(i).num_of_matches += 1;
        }
      }

      if (tc.num_of_matches > 1) {
        println("found a matching tag combination at:" + t1);
      } else {
        all_tag_combs.add(tc);
      }
    }
  }
}

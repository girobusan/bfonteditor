void printbreaks(String strng) {
  String[] slist = strng.split("\n");
  for (int i=0; i<slist.length; i++) {
    println(slist[i]);
  }
}
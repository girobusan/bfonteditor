import java.util.*;
import java.lang.*;
import java.io.*;

public class LetterSort implements Comparator<LetterCell> {
  public int compare(LetterCell a, LetterCell b) {
    return a.codepoint - b.codepoint;
  }
}

public class Alphabet implements EditorComponent {

  LetterCell[] letters;
  String filename = "";
  String specimen = "В чащах юга жил был цитрус...";
  Specimen spec = null;

  Alphabet() {
    letters = new LetterCell[0];
  }

  void sort() {
    Arrays.sort(letters, new LetterSort());
  }

  int getLettersCount() {
    return letters.length;
  }

  void fillFromString(String s) {
    for (int i = 0; i<s.length(); i++) {

      byte[][] k = {
        {0, 0, 0, 0, 0, 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0, 0}
      };

      int ccp = int(s.charAt(i));
      //print(ccp); 
      //print(":") ; 
      //println(findCodepoint(ccp));
      if (findCodepoint(ccp)==-1) {
        //print(s.charAt(i)) ; 
        //print(":") ; 
        //println(int(s.charAt(i)));
        //System.arraycopy(zeroGrid , 0 , k , 0 , zeroGrid.length);
        LetterCell l= new LetterCell(k, byte(8));
        l.setCodepoint(int(s.charAt(i)));
        addLetter(l);
      }
    }
  }

  public Boolean isClickInside(float x, float y) {
    return false;
  }
  public Boolean doClick(float x, float y) {
    return false;
  }
  public Boolean keyPress(char keychar, int keycode) {
    println("alphabet keypress!");
    if (keycode==79) {
      ab.openFile();
      return true;
    }
    if (keyCode== 83) {
      ab.saveAs();
      return true;
    }


    return false;
  }
  
  void setSpecimen(Specimen s){
  spec = s;
  }

  void addLetter(LetterCell l) {
    //println("appended");
    letters = (LetterCell[]) append(letters, l);
    //println(letters.length);
  }

  int findCodepoint(int cp) {
    for (int i = 0; i<letters.length; i++) {
      if (letters[i].codepoint == cp) {
        return i;
      }
    }
    return -1;
  }

  LetterCell getByCodepoint(int i) {
    int li = findCodepoint(i);
    if (li ==-1) {
      //println("no codepoint " + char(i) );
      return null;
    }
    return letters[li];
  }

  public void saveTheFile(File selection) {
    filename = selection.getAbsolutePath();


    saveJSONObject( dumpJSON(), filename);
  }

  public void saveAs() {
    String fn = "font.json";
    if (filename != "") {
      fn=filename;
    }
    selectOutput("Select a file", "saveTheFile", new File(fn), this);
  }

  public void openFile() {
    String fn = "font.json";
    if (filename != "") {
      fn = filename;
    }

    selectInput("Choose a file", "openCallback", new File(fn), this);
  }

  public void openCallback(File se) {
    filename = se.getAbsolutePath();
    JSONObject json = loadJSONObject(filename);
    fillFromJSON(json);
  }

  public void fillFromJSON(JSONObject js) {
    //letters = new LetterCell[0];
    JSONArray ltrs = js.getJSONArray("letters");
    for (int i = 0; i < ltrs.size(); i++) {
      LetterCell letterToAppend = new LetterCell( ltrs.getJSONObject(i) );
      if ( findCodepoint(letterToAppend.codepoint)==-1 ) {
        addLetter(letterToAppend);
        return;
      } else {
        if (getByCodepoint(letterToAppend.codepoint).isBlank() ) {
          //replace letter
          letters[ findCodepoint(letterToAppend.codepoint) ] = letterToAppend;
        }
      }



      //addLetter();
    }
    //println("about to finalize open process");
    if(!js.isNull("specimen")){
      //println("specimen defined");
      //println(js.getString("specimen"));
      specimen = js.getString("specimen");
      if (spec!=null){
      spec.setSpecimenText(specimen); 
      }
      //println(specimen);
    }
    sort();
  }

  public JSONObject dumpJSON() {
    JSONObject comp = new JSONObject();
    JSONArray result = new JSONArray();

    for (int i = 0; i < letters.length; i++) {
      result.setJSONObject( i, letters[i].dumpJSON());
    }
    comp.setJSONArray("letters", result) ;
    comp.setString("specimen" , specimen);
    return comp;
  }

  public String dumpToC() {
    return "";
  }
}//Alphabet class
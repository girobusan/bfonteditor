class Specimen implements EditorComponent {

  Alphabet myFont;
  String myText = "Съешь еще этих мягких французских булок да выпей чаю";
  float x;
  float y;
  int w = 700;
  int h=100;
  int padding = 10;
  int factor = 2;
  Boolean isActive =false;

  Specimen(Alphabet a, float dx, float dy) {
    myFont = a;
    myText = a.specimen;
    x = dx;
    y=dy;
  }


  Boolean isClickInside(float ix, float iy) {
    if ((ix<x)||(iy<y)) {
      isActive = false;
      return false;
    }
    if ((ix>(x+w))||iy>(y+h)) {
      isActive = false;
      return false;
    }
    return true;
  }
  
  public String getSpecimenText(){
  return myText;
  }
  
  public void setSpecimenText(String s){
  myText = s;
  }

  public Boolean doClick(float x, float y) {
    println("specimen clicked");
    isActive = true;
    return true;
  }
  //backspace  8
  //enter  13
  public Boolean keyPress(char keychar, int keycode) {
    if (!isActive) {
      //println("not active");
      return false;
    }
    if (keycode == 8) { //backspace
      println("backspace");
      if(myText.length()<1){
      return true;
      }
      myText = myText.substring(0, myText.length()-1);
      return true;
    }
    if (keycode == 10) { //enter
      println("enter");
      myText = myText+"\n";
      return true;
    }

    if (myFont.findCodepoint(int(keychar))!=-1) {
      myText = myText+keychar;
    }
    ab.specimen = myText;
    return true;
  }

  void drawString(String txt, float topy , Boolean showCursor) {
    int stringPos = padding;
    for (int i = 0; i<txt.length(); i++) {
      //one letter
      LetterCell cp = myFont.getByCodepoint(int(txt.charAt(i)));
      if ( cp != null) {
        cp.type(stringPos+x, y+topy+padding, factor*8, factor*8);
        //stringPos += ;
        stringPos += (factor*cp.letterWidth);
        if (stringPos>(w-padding*2)) {
          return ;
        }
      } else {
        stringPos +=8;
      }
    }
    if(showCursor){
       if(frameCount%60>30){
         fill(255);
       }else{
          fill(0);   
       }
       rect(stringPos+x , y+topy+padding  , factor , factor*8);
    }
  }//draw

  void printLn(String lines) {
    String[] lnz = lines.split("\n");
    if(lines.length()>1 && lines.charAt(lines.length()-1)=='\n') {
      // letters = (LetterCell[]) append(letters, l);
      lnz = (String[]) append(lnz , "");
    }
    for (int i = 0; i<lnz.length; i++) {
      //show cursor?
      Boolean showCursor = isActive;
      if (i!=lnz.length-1){
        showCursor = false;
      }
      
      drawString(lnz[i], i*factor*8 +factor , showCursor);
    }
  }

  // void printWrap(String lines){

  // }

  void draw() {
    if (isActive) {
      fill(#C5FF62);
    } else {
      fill(255);
    }
    rect(x, y, w, h);
    printLn(myText);
  }
}
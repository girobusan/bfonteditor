class LetterCell {

  byte[][] letter = new byte[8][8];
  byte letterWidth;
  int codepoint = 0;
  Alphabet font;
  float tx;
  float ty;
  float twidth;
  float theight;

  LetterCell (byte[][] data) {

    letter = data;
    letterWidth = 8;
  }

  LetterCell ( JSONObject json) {
    decodeJSON(json);
  }

  LetterCell (byte[][] data, byte w) {

    letter = data;
    letterWidth = w;
    //debug
    //println("constructed");
    //println(letter[0][0]);
  } 

  String makeLabel( int cpd) {
    if (cpd==32) {
      return "<space>";
    }

    return "" + (char)cpd;
  }

  void decodeJSON(JSONObject json) {
    letterWidth = byte(json.getInt("width"));
    codepoint  = json.getInt("codepoint");
    byte[][] indata = new byte[8][8];

    for (int x = 0; x<8; x++) {
      for (int y = 0; y<8; y++) {

        ////print(x);
        //print(":");
        //println(y);

        indata[x][y] = byte(json.getJSONArray("bytes").getJSONArray(x).getInt(y));
      }
    }
    letter =indata;
  }

  void setCodepoint(int cp) {
    codepoint = cp;
  }

  Boolean isBlank() {
    if (letterWidth!=8) {
      return false;
    }
    for  (int i = 0; i<8; i++) {
      for ( int j=0; j<8; j++) {
        if (letter[i][j] != 0) {
          return false;
        }
      }
    }

    return true;
  }


  void setPixel(byte atx, byte aty) {
    letter[atx][aty] = 1;
  }

  void clearPixel(byte atx, byte aty) {
    letter[atx][aty] = 0;
  }

  void switchPixel(byte atx, byte aty) {
    if ( letter[atx][aty] ==0) {
      setPixel(atx, aty);
    } else {
      clearPixel(atx, aty);
    }
  }

  void switchPixel(byte[] ca) {
    switchPixel(ca[0], ca[1]);
  }


  void draw(float dx, float dy, float w, float h) {
    //println(letter[0][0]);
    noStroke();
    float cw = w/8;
    float ch = h/8;
    fill(#CCE5E8);
    //println(letterWidth);
    rect(dx, dy, w, h);
    fill(255);
    rect(dx, dy, cw*letterWidth, h);
    for (int x=0; x<8; x++) {
      for (int y=0; y<8; y++) {
        //x = column, y = byte in column

        if (letter[int(x)][int(y)]==1) {
          //println("dot");
          if (x<letterWidth) {
            fill(60);
          } else {
            fill(120);
          }
          rect(dx+ (x*cw), dy+ch*y, cw, ch);
        }
      }
    }
    fill(0);
    textAlign(CENTER);
    float labelSize = h/6;

    if (labelSize<12) {
      labelSize = 12;
    }
    textSize((int)labelSize);
    //text(hex(codepoint ,4) + " (" + (char)codepoint + ")"  , dx+(w/2) , dy + h+12 );
    text(makeLabel(codepoint), dx+(w/2), dy + h+labelSize );
  }

  void type(float dx, float dy, float w, float h) {
    //println(letter[0][0]);
    noStroke();
    float cw = w/8;
    float ch = h/8;
    fill(#CCE5E8);

    for (int x=0; x<8; x++) {
      for (int y=0; y<8; y++) {
        //x = column, y = byte in column

        if (letter[int(x)][int(y)]==1) {
          //println("dot");
          if (x<letterWidth) {
            fill(60);
          } else {
            fill(120);
          }
          rect(dx+ (x*cw), dy+ch*y, cw, ch);
        }
      }
    }
  }

  JSONObject dumpJSON() {
    JSONArray data = new JSONArray();
    JSONObject meta = new JSONObject(); 

    meta.setFloat("width", letterWidth);
    meta.setInt("codepoint", codepoint);

    for (int i = 0; i<8; i++) {
      //println("new array");
      JSONArray mybyte = new JSONArray();
      //print("i loop ");
      //println(i);
      for (int b=0; b<8; b++) {
        //print("b loop ");
        //print(b); 
        //print(":") ; 
        //println(i);
        //print("array length " );
        //println(letter[i]);
        mybyte.setInt(b, letter[i][b]);
        //println("set int");
      }
      //println("about to set mybyte");
      data.setJSONArray(i, mybyte);
      //println("set mybyte");
    }
    //println("about to set bytes");
    meta.setJSONArray("bytes", data);
    ////println("META");
    println(meta.toString());
    //decodeJSON(meta);
    return meta;
  }
}//class letterCell



class LetterEdit implements EditorComponent {

  LetterCell lc;
  float ew;
  float eh;
  float ex;
  float ey;

  LetterEdit(byte cd[][], byte lwidth, int cp, float x, float y, float w, float h) {
    lc = new LetterCell(cd);
    lc.letterWidth = lwidth;
    lc.setCodepoint(cp);
    ew = w;
    eh = h;
    ex = x;
    ey = y;
  }



  LetterEdit(LetterCell l) {

    lc = l;
  }

  Boolean isClickInside(float ix, float iy) {
    if ((ix<ex)||(iy<ey)) {
      return false;
    }
    if ((ix>(ex+ew))||iy>(ey+eh)) {
      return false;
    }
    return true;
  }

  Boolean doClick(float cx, float cy) {
    click(cx, cy);
    return true;
  }

  public Boolean keyPress(char keychar, int keycode) {
      if (keychar=='n') {
    narrow();
    return true;
  }

  if (keychar=='w') {
    widen();
    return true;
  }
  return false;
  }

  public void narrow() {
    //println("narrow");
    if (lc.letterWidth>0) {
      lc.letterWidth--;
    }
  }

  public void widen() {
    //println("widen");
    if (lc.letterWidth<8) {
      lc.letterWidth++;
    }
  }

  void setSelection(LetterCell l) {
    lc=l;
  }

  void draw() {
    lc.draw(ex, ey, ew, eh);
  }

  byte[] pixelToPoint(float px, float py) {
    //pixel coordinates to letter element
    byte xcoord = byte(  (px-ex)/(ew/8)  );
    byte ycoord = byte(   (py-ey)/(eh/8)  );
    byte[] result = {xcoord, ycoord};
    return result;
  }

  Boolean isInside(float x, float y) {
    float relx = x- ex;
    float rely = y - ey;
    if ((relx< ew)&&(relx>0)&&(rely<eh)&&(rely>0)) {

      return true;
    } else {
      return false;
    }
  }

  void click(float x, float y) {
    //println("switch");
    if (isInside(x, y)) {
      //byte[] test = pixelToPoint(x,y);
      lc.switchPixel(pixelToPoint(x, y));
    }
  }
}//LetterEdit
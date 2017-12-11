class LetterSelector implements EditorComponent {

  Alphabet letters;
  LetterEdit editor;
  float x;
  float y;
  float w;
  float h;
  float sizeref = 10;
  int cellWidth = 32;
  int cellHeight= 32;
  int padding = 10;
  int vertPadding = 12;
  int atPage;
  int atRow;
  int atColumn;
  int pages;
  int currentPage;


  LetterSelector(Alphabet lttrs, LetterEdit ce, float cx, float cy, float cw, float ch ) {
    letters = lttrs;
    editor = ce;
    w = cw;
    h=ch;
    x = cx;
    y = cy;
    atRow = (int) (w+padding)/(cellWidth+padding);

    atColumn = (int) (h+padding) /(cellHeight+padding+vertPadding);
    //print("atrow ");
    //println(atRow);
    //print("atcolumn ");
    //println(atColumn);
    atPage = atRow*atColumn;
    //print("letters count "); 
    //println(letters.getLettersCount()) ;
    pages = (int) letters.getLettersCount()/atPage +1;
    currentPage = 0;
  }

  Boolean isClickInside(float ix, float iy) {
    if ((ix<x)||(iy<y)) {
      return false;
    }
    if ((ix>(x+w))||iy>(y+h)) {
      return false;
    }
    return true;
  }

  Boolean doClick(float cx, float cy) {
    selectFromXY(cx, cy);
    return true;
  }

  public Boolean keyPress(char keychar, int keycode) {
    return false;
  }


  void nextPage() {
    //println("next page");
    print(currentPage);
    //print("/");
    //println(pages);
    if (currentPage<pages) {
      //println("go!");
      currentPage++;
    }
  }

  void prevPage() {
    if (currentPage>0) {
      currentPage--;
    }
  }

  LetterCell getFromXY(float cx, float cy) {
    if (cx<x || cy<y || cx>x+w ||cy>y+h) {
      println("no you cant");
      return null;
    }
    int lcol = (int) ((cx-x)+padding)/(cellWidth+padding);
    int lrow = (int) (cy-y)/(cellHeight+padding+vertPadding);
    int lindex = (currentPage*atPage) + (lrow*atRow) +lcol;
    //print("index "); 
    //println(lindex);
    if (lindex>=0 && lindex<letters.getLettersCount()) {
      return letters.letters[lindex];
    } else {
      return null;
    }
  }

  void selectFromXY(float cx, float cy) {
    if (getFromXY(cx, cy)!=null) {
      editor.setSelection(getFromXY(cx, cy));
    } else {
      //println("no selection made");
    }
  }

  void selectIndex(int indx) {
    if (indx>=0 && indx< letters.getLettersCount()) {
      editor.setSelection(letters.letters[indx]);
    }
  }

  void draw() {
    int start = currentPage*atPage;
    for (int r = 0; r<atRow; r++) {
      for (int c = 0; c<atColumn; c++) {
        int index = start + (c*atRow + r);
        if (index <letters.getLettersCount()) {
          letters.letters[index].draw( x+(r*(cellWidth+padding)), y+(c*(cellHeight+padding+vertPadding)), cellWidth, cellHeight    );
        }
      }
    }
  }//draw
}//letter selector
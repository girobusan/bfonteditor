LetterEdit lc ;
Alphabet ab ; 
LetterSelector lsel;
Specimen spc ;
PFont ifaceFont;
EditorDispatcher disp;


void setup() {

  size(800, 600);
  smooth();
  ifaceFont = createFont("FiraSans-Regular.otf", 48);
  textFont(ifaceFont);
  pixelDensity(displayDensity());
  byte[][] grid = 
    {
    {1, 1, 1, 1, 1, 1, 1, 1}, 
    {0, 1, 0, 1, 0, 1, 0, 1}, 
    {1, 0, 1, 0, 1, 0, 1, 0}, 
    {0, 1, 0, 1, 0, 1, 0, 1}, 
    {1, 0, 1, 0, 1, 0, 1, 0}, 
    {0, 1, 0, 1, 0, 1, 0, 1}, 
    {1, 0, 1, 0, 1, 0, 1, 0}, 
    {0, 1, 0, 1, 0, 1, 0, 1}
  };
  printbreaks("В моей душе ледит сокровище\nИ ключ доступен только мне");

  lc = new LetterEdit( grid, byte(5), 0x042B, 50, 50, 150.0, 150.0 );
  //lc.lc.dumpJSON();
  ab = new Alphabet();
  ab.fillFromString(" АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЫЪЬЭЮЯабвгдежзийклмнопрстуфхцчшщыъьэюяЁё1234567890"+
    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ…" + " №#~%©@®$€™()₽><+-*=°•,.← → ↑ ↓?!:;/\\");
 
  ab.sort();
  //ab.addLetter(new LetterCell(grid,byte(8)));
  //LetterSelector(Alphabet lttrs , float cx , float cy , float cw , float ch ){
  lsel = new LetterSelector(ab, lc, 250, 50, 500, 400);
  lsel.selectIndex(0);
  spc = new Specimen(ab, 50, 450);
  ab.setSpecimen(spc);
  disp = new EditorDispatcher();
  disp.addComponent(spc); 
  disp.addComponent(lsel);
  disp.addComponent(lc);
  disp.addComponent(ab);
}

void draw() {
  background(100);
  fill(200);
  textSize(14);
  text("8x8 font editor", width/2, 28 );

  lc.draw();
  lsel.draw();
  spc.draw();
}

void mouseClicked() {
  disp.click(mouseX, mouseY);
  //lsel.selectFromXY(mouseX, mouseY);
}

void keyPressed() {
  println(keyCode);

  if (keyCode==39) {
    lsel.nextPage();
  }
  if (keyCode==37) {
    lsel.prevPage();
  }
  if(keyCode == 81) {
  exit();
  }


  disp.type(key, keyCode);
}
interface EditorComponent {

  public Boolean isClickInside(float x, float y);
  public Boolean doClick(float x, float y);
  public Boolean keyPress(char keychar, int keycode);
}

class EditorDispatcher {

  EditorComponent[] components;

  EditorDispatcher() {
    components =  new EditorComponent[0];
  }

  void addComponent(EditorComponent c) {
    println(c);
    components = (EditorComponent[]) append(components, c);
  }

  void click(float x, float y) {
    println("click recieved");
    for (int i = 0; i<components.length; i++) {
      //println(components.length);
      if (components[i].isClickInside(x, y)) {
        println("click is inside comp");
        if (components[i].doClick(x, y)) {
          return;
        }
      }
    }
  }

  void type(char keychar, int keycode) {
    for (int i = 0; i<components.length; i++) {
      if (components[i].keyPress(keychar, keycode)) {
        return;
      }
    }
  }
}
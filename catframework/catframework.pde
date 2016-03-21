import gifAnimation.*;

import megamu.mesh.*;

import netP5.*;
import oscP5.*;
import processing.serial.*;

PApplet sketch;

int start = millis();
PImage bg;

ArrayList<Cat> cats = new ArrayList<Cat>();
ArrayList<String> messages = new ArrayList<String>();
ADGettext line;
int max_messages = 5;
String tabby= "cat3.gif";
String siamese="cat2.gif";
String eat="cat-eating.gif";

void setup() {

  sketch = this;
  size(800,700);
  line = new ADGettext(20,height-50,500,"> ","fname");
  line.setFocusOn();
  bg = loadImage("bg.jpg");
}

void draw() {
  background(bg);
  setNeighbours();
  for (Cat cat : cats) {
    cat.move();
    cat.draw();
  }

  float[][] edges = catEdges();
  for (float[] coords : edges) {
    line(coords[0], coords[1], coords[2], coords[3]);
  }
  line.update();

  textFont(line.gText,20);
  textAlign(LEFT);
  int i = 0;
  int msggap = 25;
  int top = height-(40 + (25*messages.size()));
  for (String message : messages) {
    fill((255/max_messages)*(messages.size()-i));
    text(message,20,top+(25*i));
    i++;
  }
}

Cat find(String name) {
  Cat result = null;
  for (Cat cat : cats) {
    println("check " + cat.name);
    if (cat.name.toLowerCase().equals(name.toLowerCase())) {
      result = cat;
      break;
    }
  }
  return(result);
}

Delaunay catDelaunay() {
  float[][] points = new float[cats.size()][2];
  int i = 0;
  for (Cat cat : cats) {
    points[i][0] = cat.v.x;
    points[i][1] = cat.v.y;
    ++i;
  }
  Delaunay d = new Delaunay(points);
  return(d);
}

float[][] catEdges() {
  float[][] result;
  Delaunay d = catDelaunay();
  result = d.getEdges();
  return(result);
}

int[][] catLinks() {
  Delaunay d = catDelaunay();
  int[][] result = d.getLinks();
  return(result);
}

void setNeighbours() {
  int[][] links = catLinks();
  for (Cat cat : cats) {
    cat.neighbours.clear();
  }
  for (int i = 0; i < links.length; ++i) {
    if (links[i][0] == links[i][1]) {
      continue;
    }
    //println("link from " + links[i][0] + " to " + links[i][1]);
    Cat from = cats.get(links[i][0]);
    Cat to = cats.get(links[i][1]);
    // println("neighbour " + from.name + " <> " + to.name);
    from.neighbours.add(to);
    to.neighbours.add(from);
  }
}
//function get cat
String _cat(String[] tokens) {
  String result = "?";

  if (tokens.length > 1) {
    String name = tokens[1];
    if (find(name) != null) {
      Cat cat = find(name);
      result = cat.name + " is already here.";
    }
    else {
      cats.add(new Cat(name));
      result = name + " arrives.";
    }
  }
  else {
    result = "Please give the cat a name.";
  }
  return(result);
}

// change cats coat
String _coat(String[] tokens) {
  String result = "?";

  if (tokens.length > 2) {
    String name = tokens[1];
    if (find(name) == null) {
          result = name +" is not here.";
    }
    else {
      Cat cat = find(name);
      switch(tokens[2]) {
      case "default":
        cat.loadGif("cat.gif");  // Does not execute
        break;
      case "tabby":
        cat.loadGif("cat3.gif");  // Does not execute
        break;
      case "siamese":
        cat.loadGif("cat2.gif");  //
        break;
      }
      result = cat.name + " has a new look.";

    }
  }
  else {
    result = "Please enter a cat's name.";
  }
  return(result);
}

// calls an action
String _action(String[] tokens) {
  String result = "?";

  if (tokens.length > 2) {
    String name = tokens[1];
    if (find(name) == null) {
          result = name +" is not here.";
    }
    else {
      Cat cat = find(name);
      switch(tokens[2]) {
      case "eat":
        cat.loadGif("cat-eating.gif");  // Does not execute
        result = cat.name + " is now " + tokens[2] + "ing.";
        break;
      case "fight":
        cat.loadGif("cat-fight.gif");  // Does not execute
        result = cat.name + " is now " + tokens[2] + "ing.";
        break;
      case "heat":
        cat.loadGif("cat-heat.gif");  // Does not execute
        result = cat.name + " is now in" + tokens[2];
        break;
      case "knead":
        cat.loadGif("cat-kneading.gif");  // Does not execute
        result = cat.name + " is now " + tokens[2] + "ing.";
        break;
      case "sleep":
        cat.loadGif("cat-sleeping.gif");  // Does not execute
        result = cat.name + " is now " + tokens[2] + "ing.";
        break;
      default:
        result = "No matching action found.";
        break;
      }
    }
  }
  else {
    result = "Please enter a cat's name followed by an action.";
  }
  return(result);
}




void command(String cmd) {
  String[] tokens = splitTokens(cmd);
  String result = "";
  if (tokens.length == 0) {
    return;
  }
  switch (tokens[0]) {
    case "cat": result = _cat(tokens); break;
    case "coat": result = _coat(tokens); break;
    case "action": result = _action(tokens); break;

  }
  messages.add(result);
  if (messages.size() > max_messages) {
    messages.remove(0);
  }
  print(result + "\n");
}

void keyPressed() {
  int i = line.checkKeyboardInput();
  if (i == 1000) {
    command(line.getText());
    line.eraseField();
  }
}

void keyReleased() {
  line.checkAdditionalKeys();
}
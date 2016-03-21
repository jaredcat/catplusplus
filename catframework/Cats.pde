import gifAnimation.*;

class Cat {
   String name;
   boolean female;
   boolean spayed;
   int born;
   PVector v;
   ArrayList<Cat> neighbours = new ArrayList<Cat>();
   // takes 5 minutes
   float adult = 30;
   PImage[] images = null;
   float fr = random(0.8,1.5);
   
   Cat (String name) {
     this.name = name;
     female = true;
     spayed = true;
     v = new PVector(0.5, 0.5);
     born = millis();
     loadGif("cat.gif");
            
            
   }
   
   void loadGif(String fn) {
     Gif g = new gifAnimation.Gif(sketch,fn);
     images = g.getPImages();
   }
   
   float friendliness() {
     float result = 0;
     result = -1 + ((min(age(),adult) / adult)*2);
     return(result);
   }
   
   void move() {
     v.x += random(-0.005,0.005);
     v.y += random(-0.005,0.005);
     for (Cat neighbour : neighbours) {
       
       PVector diff = PVector.sub(v, neighbour.v);
        diff.normalize();
        float d = PVector.dist(v, neighbour.v);
        println("f: " + friendliness());
        diff.div(d*friendliness());        // Weight by distance
        diff.mult(0.00001);
        v.add(diff);
     }
     if (v.x > 1) {
       v.x = 1;
     }
     if (v.y > 1) {
       v.y = 1;
     }
     if (v.x < 0) {
       v.x = 0;
     }
     if (v.y < 0) {
       v.y = 0;
     }
   }
   
   float age() {
     return(float(millis() - born) / 1000.0);
   }
   
   void draw() {
     float sz = age();
     if (sz > adult) {
       sz = adult;
     }
     sz = sz / adult;
     sz = sz * 20 + 100;

     if (images == null || images.length == 0) {
       fill(255,0,0);
       ellipse(v.x*width,v.y*height,sz,sz);
     }
     else {
       int frame = int(int(float(millis() - start) / (fr * 1000)) % images.length);
       PImage image = images[frame];
       image(image,v.x*width,v.y*height,sz,sz);
     }
   }
   
   float distance(Cat from) {
     float result;
     //println("dist from " + v.x + " - " + from.v.x + " : " + v.y + " - " +from.v.y);
     result = sqrt(sq(v.x - from.v.x) + sq(v.y - from.v.y));
     //println(" = " + result);
     return(result);
   }
}

class BlackCat extends Cat {
  BlackCat (String name) {
    super(name);
  }
  void draw () {
    fill(0,0,0);
    ellipse(v.x,v.y,30,30);
  }
}
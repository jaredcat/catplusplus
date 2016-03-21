 
class ADGettext
{    
  PFont gText;
  int textPoints=24;
  color textColor=#717171;
   
  int boxOffset=4;
   
  color colorFillBox=#EBEDEC;
  color colorBorderBox=0;
  color originalColorBorderBox=0;
  color colorSelectedBorderBox=#FF7308;
  float borderWidth=1;
  float originalBorderWidth=borderWidth;
  color cursorColor=0;
   
  String gtextString="", tempL="", tempR="", showString="";
  int sI=0, sF=0;
   
  String textHint="Type something...";
  color textHintColor=#F7F7F7;
  boolean textHintVisible=true;
   
  float textX, textY, textW, textH;
   
  int cursorPos=0;
  timer cursorBlink;
  boolean cursorVisible=true;
     
  boolean isMouseOver=false;
  boolean focus=false;
  boolean selected=false;
  boolean setArrayOn=false;
   
  int maxCharacters=50;
   
  int keyControl=0;
   
  String ID;
   
  boolean debug=true;
  boolean pressOnlyOnce=true;
  int deb=0;
   
  String textExceptions="";
  String textAllowed="";
  boolean allTextAllowed=true;
   
  boolean masked=false;
   
  boolean enabled=true;
   
  keys specialKey;
  boolean analyzeKeys=true;
  
   
   
  ///////////////////////////////////////////////////////
  ADGettext(float x, float y, float w, String i)
  {
    textX=x;
    textY=y;
    textW=w;
    textH=textPoints+textPoints*.28;
     
    specialKey = new keys();
     
    ID=i;
     
    gText = createFont("Courier",textPoints,true);     
       
    cursorBlink = new timer(600);
    setCursorPos(0);
     
     
     
     
  }
  ///////////////////////////////////////////////////////
  ADGettext(float x, float y, float w, String tHint, String i)
  {
    textX=x;
    textY=y;
    textW=w;
    textH=textPoints+textPoints*.28;
    ID=i;
    specialKey = new keys();
     
    gText = createFont("Arial",textPoints,true);     
    textFont(gText,textPoints);  
    cursorBlink = new timer(600);
     
    setTextHint(tHint);
  }
   
  /////////////////////////////////////////////////////// 
  public String getID()
  {
    return ID;
  }
  /////////////////////////////////////////////////////// 
  public void enableField()
  {
    enabled=true;
  }
  /////////////////////////////////////////////////////// 
  public void disableField()
  {
    enabled=false;
  }
  /////////////////////////////////////////////////////// 
  public void setDebugOn()
  {
    debug=true;
  }
  /////////////////////////////////////////////////////// 
  public void setDebugOff()
  {
    debug=false;
  }
 
  /////////////////////////////////////////////////////// 
  public void setMaskOn()
  {
    masked=true;
  }
  /////////////////////////////////////////////////////// 
  public void setMaskOff()
  {
    masked=false;
  }
 
  /////////////////////////////////////////////////////// 
  public boolean isEmpty()
  {
    if (stringLength()==0)
      return true;
    else
      return false; 
  }
 
  ///////////////////////////////////////////////////
  public void setTextSize(int s)
  {
    if (s<8) s=8;
    if (s>80) s=80;
     
    textPoints=s;
    textH=textPoints+textPoints*.28;
  }
  ///////////////////////////////////////////////////
  public void setMaxCharacters(int v)
  {
    if (v<0 || v>80) return;
     
    maxCharacters=v;
  }
  ///////////////////////////////////////////////////
  private String getText()
  {
    return gtextString;
  }
  ///////////////////////////////////////////////////
  private int textLength()
  {
    return gtextString.length();
  }
  ///////////////////////////////////////////////////
  private String trimText(String s)
  {
    String result=s;
     
    if (textWidth(s)>(textW-textWidth("_")/2))
    {
      String temp="";
     
      for (int i=0; i<s.length(); i++)
      {
        if (textWidth(temp)<(textW-textWidth("_")/2))
          temp+=s.charAt(i);
        else
          i=s.length(); 
      }
      result=temp;
    }
     
    if (s.length() > maxCharacters)
    {
      result=s.substring(0,maxCharacters);
    }
     
    return result;
  }
  ///////////////////////////////////////////////////
  private void drawBox()
  {
    fill(colorFillBox);
    stroke(colorBorderBox);
    strokeWeight(borderWidth);
    rect(textX-boxOffset,textY,textW+boxOffset,textH);
  }
  ///////////////////////////////////////////////////
  public void setBorderWidth(int w)
  {
    if (w<0) return;
    if (w>20) return;
     
    borderWidth=w;
    originalBorderWidth=w;
  } 
  ///////////////////////////////////////////////////
  public void setBackgroundBox(color c)
  {
    colorFillBox=c;
  } 
  ///////////////////////////////////////////////////
  public void setBoxBorderColor(color c)
  {
    colorBorderBox=c;
  } 
   
  ///////////////////////////////////////////////////
  private String fillString(char c, int n)
  {
    String result="";
     
    for (int i=0; i<n; i++)
       result+=c;
        
    return result;  
  }
  ///////////////////////////////////////////////////
  private String setShowString()
  {
    String result="";
     
    if (masked)
       showString=fillString('*',gtextString.length());
    else  
      showString=gtextString;
    //showString=gtextString.substring(sI,sF);
     
     
    if (gtextString.length()==0 && textHintVisible)
      result=textHint;
    else
      result=showString;
     
    return result;
  }
   
  ///////////////////////////////////////////////////
  private void drawText()
  {
 
    textFont(gText,textPoints);
 
    if (gtextString.length()==0 && textHintVisible)
      fill(textHintColor);
    else
      fill(textColor); 
 
    textAlign(LEFT);
    text(setShowString(),textX,textY+textPoints);
     
  }
  ///////////////////////////////////////////////////
  private int stringLength()
  {
    return gtextString.length();
  }
  ///////////////////////////////////////////////////
  private char stringcharAt(int i)
  {
    if (i>stringLength()-1) i=stringLength()-1;
    if (i<0) i=0;
     
    return showString.charAt(i);
  }
  ///////////////////////////////////////////////////
  public void setTextHint(String th)
  {
    textHint=trimText(th);
    textHintVisible=true;
     
  } 
  ///////////////////////////////////////////////////
  public void setText(String t)
  {
    gtextString=trimText(t);
    showString=gtextString;
  } 
  ///////////////////////////////////////////////////
  private int getCursorX()
  {
    int result=0;
    int curPosAnt=cursorPos;
 
    for (int i=0; i<cursorPos; i++)
    {
      if (cursorPos>=stringLength()+1)
        result+=textWidth("_");
      else
      {
        result+=textWidth(stringcharAt(i));
      }
    }
    return result;
  }
  ///////////////////////////////////////////////////
  private void setCursorPos(int pos)
  {
    if (pos<0) pos=0;
    if (pos>stringLength()) pos=stringLength();
     
    cursorBlink.reset();
    cursorVisible=true;
    cursorPos=pos;
  }
  ///////////////////////////////////////////////////
  private void drawCursor()
  {
    if (!selected) return;
     
    if (cursorBlink.over())
    {
       cursorVisible=!cursorVisible;
       cursorBlink.reset();
    }
     
    stroke(cursorColor);
    if (cursorVisible)
      line(textX+getCursorX(),textY+textPoints/4,textX+getCursorX(),textY+textH-textPoints/4);
  }
   
  ///////////////////////////////////////////////////
  public boolean getFocus()
  {
    return focus;
  } 
  ///////////////////////////////////////////////////
  public void setFocusOn()
  {
    setCursorPos(cursorPos);
    focus=true;
  } 
  ///////////////////////////////////////////////////
  public void setFocusOff()
  {
    focus=false;
  } 
  ///////////////////////////////////////////////////
  public void setArrayOn()
  {
    setArrayOn=true;
  } 
  ///////////////////////////////////////////////////
  public void setArrayOff()
  {
    setArrayOn=false;
  } 
 
  ///////////////////////////////////////////////////
  private void checkFocus()
  {
 
    if (setArrayOn) //if it belongs to a array of objetcs
    {
      if (focus && enabled) // if it has the focus activated it
        selected=true;
      else
        selected=false;
       
 
      if (mouseOver() && mousePressed && mouseButton==LEFT && enabled)
      {
        focus=true;
        selected=true;
      }
 
    }
    else // if the object is alone
    {
      if (mouseOver()) //only activated it if mouse is over and press mouse-left
      {
        if (mousePressed && mouseButton==LEFT && enabled)
        {
          focus=true;
          selected=true;
        }
      }
      else {//if mouse is not over deselect the field
        // selected=false;
      }
    }
   
    if (selected) 
    {
      colorBorderBox=colorSelectedBorderBox;
      borderWidth=originalBorderWidth*2;
    }
    else
    {
      colorBorderBox=originalColorBorderBox;
      borderWidth=originalBorderWidth;
    }
     
  }
 
  ///////////////////////////////////////////////////
  private boolean mouseOver()
  {
    boolean result=false;
     
    if (mouseX>=textX-boxOffset && mouseX<=textX+textW+boxOffset && mouseY>=textY && mouseY<=textY+textH)
      result=true;
       
    isMouseOver=result;
    return result;
     
  }
   
  ///////////////////////////////////////////////////
  private void deleteCharInTheMiddle(boolean back)
  {
    if (back)
    {
      tempL=gtextString.substring(0,cursorPos-1);
      tempR=gtextString.substring(cursorPos,stringLength());
    } 
    else
    {
      tempL=gtextString.substring(0,cursorPos);
      tempR=gtextString.substring(cursorPos+1,stringLength());
 
    }
    gtextString=tempL+tempR;
    sF--;
    if (sI>0) sI--;
    
 
  }
  ///////////////////////////////////////////////////
  private void deleteCharFromEnd()
  {
    tempL=gtextString.substring(0,stringLength()-1);
    gtextString=tempL;
 
    sF--;
    if (sI>0) sI--;
     
  }
 
 
  ///////////////////////////////////////////////////
  public void setAllowedText(String a)
  {
    allTextAllowed=false;
    textAllowed=a;
  }
 
  ///////////////////////////////////////////////////
  private boolean complyAllowed(String a)
  {
    if (allTextAllowed) return true;
     
    boolean result=false;
     
    if (textAllowed.toLowerCase().contains(a.toLowerCase()))
      result=true;
       
    return result;  
  }
 
  ///////////////////////////////////////////////////
  public void setExceptions(String e)
  {
    textExceptions=e;
  }
 
  ///////////////////////////////////////////////////
  private boolean complyException(String e)
  {
    boolean result=false;
     
    if (textExceptions.toLowerCase().contains(e.toLowerCase()))
      result=true;
 
    return result;  
  }
  ///////////////////////////////////////////////////
  public void eraseField()
  {
    gtextString="";
    sI=0; sF=0;
    setCursorPos(0);
     
  } 
  ///////////////////////////////////////////////////
  private void insertChar(char c)
  {
     
    if (!enabled) return;
    if (c==CODED) return;
     
    textFont(gText,textPoints);
    if ((textWidth(gtextString)>textW-textWidth(c)-textWidth("_")/2) || stringLength()>=maxCharacters) return;
 
    if (complyException(Character.toString(c))) return;   
     
    if (!complyAllowed(Character.toString(c))) return;
     
    if (cursorPos==0)
    {
      gtextString=Character.toString(c)+gtextString;
      sF++;
      setCursorPos(cursorPos+1);
    }
    else
      if (cursorPos<gtextString.length())
      {
        tempL= gtextString.substring(0,cursorPos);
        tempR=gtextString.substring(cursorPos,stringLength());
        gtextString=tempL+Character.toString(c)+tempR;
        sF++;
        setCursorPos(cursorPos+1);
      }
      else
        if (cursorPos>=gtextString.length())
        {
         tempL=gtextString.substring(0,stringLength());
         gtextString=tempL+Character.toString(c);
         sF++;
         setCursorPos(cursorPos+1);;
        }
 
     if (textWidth(gtextString)>textW-boxOffset-10) sI++;
     
  }
  ///////////////////////////////////////////////////
  private void delChar()
  {
    if (cursorPos>=0)
    {
      if (cursorPos<stringLength())
      {
        deleteCharInTheMiddle(false);
      }
    }
  }
  ///////////////////////////////////////////////////
  private void backChar()
  {
    if (cursorPos>0)
    {
      if (cursorPos>=stringLength())
      {
        setCursorPos(cursorPos-1);
        deleteCharFromEnd();
         
      }
      if (cursorPos<stringLength())
      {
        deleteCharInTheMiddle(true);
        setCursorPos(cursorPos-1);
      }
    }
  }
   
  ///////////////////////////////////////////////////
  private void checkArrows()
  {
    if (keyCode==LEFT)
    {
      setCursorPos(cursorPos-1);
    }
 
    if (keyCode==RIGHT)
      setCursorPos(cursorPos+1);
    
 
  }
 
  ///////////////////////////////////////////////////
  public void checkAdditionalKeys()
  {
    specialKey.releasedKey();
    analyzeKeys=true;
  }
  ///////////////////////////////////////////////////
  private void checkSpecialKeys()
  {
     
    if (specialKey.checkStrokes("CONTROL+LEFT"))
    {
      for (int i=cursorPos-1; i>=0; i--)
      {
        if (stringcharAt(i)==' ' || i==0)
        {
          setCursorPos(i);
          i=-1;
        }
      }
 
    } else if (specialKey.checkStrokes("CONTROL+RIGHT"))
    {
      for (int i=cursorPos+1; i<=stringLength(); i++)
      {
        if (stringcharAt(i)==' ' || i==stringLength())
        {
          setCursorPos(i+1);
          i=stringLength()+1;
        }
      }
       
 
    } else if (specialKey.checkStrokes("CONTROL+DELETE"))
    {
      eraseField();
    }
    else checkArrows();
 
 
  }
 
  ///////////////////////////////////////////////////
  public int checkKeyboardInput()
  {
    if (!selected) return 0;
     
    int result=0;
 
    if (analyzeKeys)
    {
      analyzeKeys=false;
      specialKey.pressedKey();
      checkSpecialKeys();
    }
    else
      checkArrows(); 
     
     
     
    if (keyPressed && (key==BACKSPACE || key==DELETE))
    {
      if (key==BACKSPACE)
      {
        backChar();
      }
      if (key==DELETE)
      {
        delChar(); 
      }
    }
    else
    {
      if (keyPressed && key!=TAB && key!=ENTER && key!=ESC &&key!=RETURN)
      {
        insertChar(key);
      } 
 /*
      if (keyPressed && keyCode==END) //END
        setCursorPos(stringLength());
       
      if (keyPressed && keyCode==HOME) //HOME
        setCursorPos(0);
         */
         
      if (keyPressed &&  (keyCode==ENTER || keyCode==RETURN))
        result=1000;
      if (keyPressed &&  (keyCode==TAB))
        result=1001;
      if (keyPressed &&  (keyCode==UP))
        result=1002;
      if (keyPressed &&  (keyCode==DOWN))
        result=1003;
   
    }
 
    return result;
  }
  ///////////////////////////////////////////////////
  private void checkCursorPosition()
  {
    int posX=0, pos=0, i;
 
    for (i=0; i<stringLength()-1; i++)
    {
      if (mouseX>posX+textX+textWidth(stringcharAt(i))/2)
        pos=i+1;
 
      posX+=textWidth(stringcharAt(i));
    }
     
    if (mouseX>=posX+textX)
      pos=i+1;
 
    setCursorPos(pos);
  }
 
  /////////////////////////////////////////////////////// 
  private void deBounce(int n)
  {
    if (pressOnlyOnce)
      return;
    else
       
    if (deb++ > n)
    {
      deb=0;
      pressOnlyOnce=true;
    }
     
  }
  ///////////////////////////////////////////////////
  private void checkMouseInput()
  {
    if (mouseOver() && mousePressed && mouseButton==LEFT)
    {
      checkCursorPosition();
    }
 
    if (mouseOver() && mousePressed && mouseButton==RIGHT && keyPressed && keyCode==CONTROL)
    {
      eraseField();
    }
     
    if (debug)
      if (mouseOver())
      {
        if (mousePressed && mouseButton==LEFT && keyPressed)
        {
          if (keyCode==CONTROL)
          {
            textX=textX+(int )((float )(mouseX-pmouseX)*1);
            textY=textY+(int )((float )(mouseY-pmouseY)*1);
          }
          if (keyCode==SHIFT && pressOnlyOnce)
          {
            printGeometry();
            pressOnlyOnce=false;
          }
          deBounce(5);
           
        }
      }   
  }
  /////////////////////////////////////////////////////// 
  public void printGeometry()
  {
    println("radio = new ADGettext("+textX+", "+textY+", "+textW+", \""+textHint+"\", \""+ID+"\");");
 
  }
  ///////////////////////////////////////////////////
  public String update()
  {
    drawBox();
    drawText();
    drawCursor();
    checkFocus();
    checkMouseInput();
    //checkKeyboardInput - this is done on the main program after a key is released
         
    return gtextString;
  }
   
/////////////////////////////////////////////////////////////////////// 
private class timer
{
  float startTime;
  int tOver;
   
  timer(int millisecs)
  {
    startTime=millis();
    tOver=millisecs;
  }
   
  boolean over()
  {
    if ((millis() - startTime)>tOver)
      return true;
    else
       return false;
  }
   
  void reset()
  {
    startTime=millis();
  }
   
  void setOver(int millisecs)
  {
    tOver=millisecs;
    reset();
  }
   
  
}

class keys
{
  boolean[] keyArray;
  int lastKey=0;
   
  String[] keyCombinations= {
     
    "CONTROL+LEFT","CONTROL+RIGHT","CONTROL+UP", "CONTROL+DOWN",
    "ALT+LEFT", "ALT+RIGHT", "ALT+UP", "ALT+DOWN",
    "CONTROL+DELETE"
   
  };
  /////////////////////////////////////////////////////////////////////
  keys()
  {
    keyArray = new boolean[526];
  }
  /////////////////////////////////////////////////////////////////////
  boolean checkKey(int k)
  {
    if (keyArray.length >= k) {
      return keyArray[k]; 
    }
    return false;
  }
  /////////////////////////////////////////////////////////////////////
  void releasedKey()
  {
    if (keyCode>526) return;
    keyArray[keyCode] = false;
  } 
  void pressedKey()
  {
    if (keyCode>526) return;
    keyArray[keyCode] = true;
    lastKey=keyCode;
  } 
  /////////////////////////////////////////////////////////////////////
  boolean checkStrokes(String keyComb)
  {
    boolean result=false;
    String kc="";
 
     
    if (checkKey(CONTROL) && (!checkKey(ALT) && !checkKey(SHIFT)) && checkKey(LEFT))
      kc=keyCombinations[0];
    if (checkKey(CONTROL) && (!checkKey(ALT) && !checkKey(SHIFT)) && checkKey(RIGHT))
      kc=keyCombinations[1];
    if (checkKey(CONTROL) && (!checkKey(ALT) && !checkKey(SHIFT)) && checkKey(UP))
      kc=keyCombinations[2];
    if (checkKey(CONTROL) && (!checkKey(ALT) && !checkKey(SHIFT)) && checkKey(DOWN))
      kc=keyCombinations[3];
 
    if (checkKey(ALT) && (!checkKey(CONTROL) && !checkKey(SHIFT)) && checkKey(LEFT))
      kc=keyCombinations[4];
    if (checkKey(ALT) && (!checkKey(CONTROL) && !checkKey(SHIFT)) && checkKey(RIGHT))
      kc=keyCombinations[5];
    if (checkKey(ALT) && (!checkKey(CONTROL) && !checkKey(SHIFT)) && checkKey(UP))
      kc=keyCombinations[6];
    if (checkKey(ALT) && (!checkKey(CONTROL) && !checkKey(SHIFT)) && checkKey(DOWN))
      kc=keyCombinations[7];
     
    if (checkKey(CONTROL) && (!checkKey(ALT) && !checkKey(SHIFT)) && checkKey(DELETE))
      kc=keyCombinations[8];
 
     
    if (kc == keyComb)
      result=true;
       
    return result;
  }
   
 }
}
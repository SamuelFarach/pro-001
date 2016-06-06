//VARIABLES:
StopWatchTimer timer;
StopWatchTimer limit;

Animations a;


int noOfEnemies = 70, c, mousePressedCount, time;
int[] vectsCo = new int[noOfEnemies];

PVector cur;
PVector ene;
PVector[] vectors = new PVector[noOfEnemies];
PVector[] directi = new PVector[noOfEnemies];
PVector b1;

boolean[] vectsBo = new boolean[noOfEnemies];
boolean incrementar, gameOver;

float[] bordersX = {0, width};
float[] bordersY = {0, height};
float r = 25, rE1 = 50, rE2 = 15, eneR, minDist = 1, distance = 150, ac = 0;
float red, gre, blu, timeTarget;




//SETUP:
void setup()
{
  size(800, 400);
  smooth();
  System.out.println("Started...");
  for (int i = 0; i<vectors.length; i++)
  {

    //vectors[i] = new PVector(random(rE1, width-rE1), random(rE1, height-rE1));
    vectors[i] = new PVector(width/2, height/2);
    directi[i] = new PVector(random(rE1, width-rE1), random(rE1, height-rE1));
    //directi[i] = new PVector(rE1, rE1);
  }

  eneR = rE1-rE2;
  ene = new PVector(random(eneR, width-eneR), random(eneR, height-eneR));
  timer = new StopWatchTimer();
  limit = new StopWatchTimer();
  a = new Animations(r, rE1, rE2);
  b1 = new PVector(30, height-30);

  incrementar = true;
  gameOver = false;

  timer.start();
}

//DRAW
void draw()
{
  if (gameOver)
  {
    gameOver();
    if (mousePressed)
    {
      setup();
    }
  } else
  {
    drawVesches();
  }
}
//REAL DRAW:
void drawVesches()
{
  background(100, 200, 150, 150);
  //background(150, 150, 0);

  setCursor();
  displayEnemies();
  compareDistance();
  displayCursor();
  displayEnemy();
  movementOfEnemies();
  //if(c<1000){a.an1();}
  adjustTime();
  displayInfo();
  count();
}
//SHOW ENEMIES:
void displayEnemies()
{  
  for (int i = 0; i<vectors.length; i++)
  {
    noStroke();

    //TARGETS
    fill(255, 0, 0);
    ellipse(directi[i].x, directi[i].y, rE2, rE2);

    fill(100, 100, 100, 220);
    ellipse(vectors[i].x, vectors[i].y, rE1, rE1);
    fill(0);
    ellipse(vectors[i].x, vectors[i].y, rE2, rE2);

    fill(255, 0, 0);
    text(i+"", vectors[i].x+20, vectors[i].y+20);



    fill(255, 0, 0);
    text(i+"", directi[i].x+rE2, directi[i].y+rE2);
  }
}
//set MOUSE CURSOR:
void setCursor()
{
  cur = new PVector(mouseX, mouseY);
}
//SHOW MOUSE CURSOR:
void displayCursor()
{
  cur = new PVector(mouseX, mouseY);
  noStroke();
  fill(255, 100, 0);
  ellipse(cur.x, cur.y, r, r);
}

//COMPARE DISTANCE FROM PLAYER AND VECTORS(ENEMIES):
void compareDistance()
{
  for (int i = 0; i<vectors.length; i++)
  {
    if (cur.dist(vectors[i]) < distance)
    {
      //CONTEO
      vectsCo[i]++;
      fill(0, 155, 0);
      text(vectsCo[i]+"", vectors[i].x+30, vectors[i].y+30);

      vectsBo[i] = true;
      float c = random(0, 5);
      if (incrementar)
      {
        red++;
        if (red >= 255)
        {
          incrementar = false;
        }
      } else
      {
        red--;
        if (red <= 0)
        {
          incrementar = true;
        }
      }
      //r+=0.01;
      stroke(red, gre, blu);
      strokeWeight(1.5);
      line(vectors[i].x, vectors[i].y, cur.x, cur.y);
    } else
    {
      vectsBo[i] = false;
      vectsCo[i] = 0;
    }
  }
}

//MOVEMENT OF ENEMIES:
void movementOfEnemies()
{
  for (int i = 0; i<vectors.length; i++)
  {
    //VARIABLES:
    float dist = vectors[i].dist(directi[i]);
    float vX = (Math.abs(vectors[i].x-directi[i].x)/dist);
    float vY = (Math.abs(vectors[i].y-directi[i].y)/dist);


    if (vectors[i].dist(directi[i])<=(minDist))
    {
      directi[i] = new PVector(random(rE1, width-rE1), random(rE1, height-rE1));
    } else
    {
      ////IF START
      if (vectors[i].x<directi[i].x && vectors[i].y<directi[i].y)
      {
        vectors[i].x = vectors[i].x + vX;
        vectors[i].y = vectors[i].y + vY;
      } else 
      if (vectors[i].x>directi[i].x && vectors[i].y<directi[i].y)      
      {
        vectors[i].x = vectors[i].x - vX;
        vectors[i].y = vectors[i].y + vY;
      } else 
      if (vectors[i].x<directi[i].x && vectors[i].y>directi[i].y)
      {
        vectors[i].x = vectors[i].x + vX;
        vectors[i].y = vectors[i].y - vY;
      } else 
      if (vectors[i].x>directi[i].x && vectors[i].y>directi[i].y)
      {
        vectors[i].x = vectors[i].x - vX;
        vectors[i].y = vectors[i].y - vY;
      }////IF END


      //OTROS:
      //r = r + 0.01;
    }
  }
}
//GAME CHALLENGE:
void setGameChallenge()
{
  /*
      GAME CHALLENGE: TO LINK ALL TARGETS REQUIRED IN THE GIVEN AMOUNT OF TIME
   PROVIDED BY THE CHALLENGE  
   */


  int ii;
  for (int i = 0; i <= noOfEnemies; i++)
  {
    int target = i+1;
    int catched = 0;

    for (ii = 0; ii <= noOfEnemies; ii++);
    {
      catched += (vectsBo[ii] == true)?1:0;
    }

    if (catched == target)
    {
      limit.start();
    }
  }
}
//COUNTER:
void count()
{
  c++;
}
//ADJUST TIME:
void adjustTime()
{
  time = (int)timer.getElapsedTime()/1000;
  timer.stop();
}
//DISPLAY INFO
void displayInfo()
{

  fill(0);
  text("Counter:", 20, 20);
  text("Time:", 20, 40);
  text("Mouse Pressed:", 20, 60);

  text(c, 140, 20);
  text(time, 140, 40);
  text(mousePressedCount, 140, 60);
}
//DISPLAY ENEMY
void displayEnemy()
{
  fill(120, 0, 155, 280);
  ellipse(ene.x, ene.y, eneR, eneR);

  if (cur.dist(ene)<(eneR/2)+r/2)
  {
    gameOver = true;
  }
}
//CHANGE LINE COLOR
void mouseReleased()
{
  //setup();
  mousePressedCount++;
  if (cur.dist(b1)<=(eneR/2))
  {
    background(255);
    setup();
  }
}
//GAME OVER:
void gameOver()
{
  background(0);
  //fill(150);
  //ellipse(b1.x, b1.y, eneR, eneR);
  fill(255);
  text("FIN", 30, 30);
  //text("EMPEZAR", b1.x, b1.y);
}



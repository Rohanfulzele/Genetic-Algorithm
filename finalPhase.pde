int num = 50 ;
int types = 6 ;
organism[][] generation = new organism[num][types]; 
int[][] goal_turn = new int[num][types];
float[][] goal_closest = new float[num][types];
float[][] top2_score = new float[2][types];
float[][] top1 = new float[types][1000];
float[][] top2 = new float[types][1000];
//IntList line[] = new IntList(); //graph line
ArrayList<IntList> line = new ArrayList<IntList>();
team leaderboard = new team();
float top_fitness[] = {0, 0, 0, 0, 0, 0};
int turn = 1;
int gen = 1;
int deads = 0;
int div = 0;
float ang = 0 ; 
float rot_speed = 2 ;
boolean obs = true ,vision = false
;
PFont font1 ;
void setup() {
  size(800, 600);
  font1 = loadFont("OCRAExtended-48.vlw") ;
  for (int t=0; t<types; t++)
  {
    top2_score[0][t]=0;
    top2_score[1][t]=0;
    for (int i = 0; i<num; i++) //NUM ORGANISMS
    {
      generation[i][t]= new organism();
      generation[i][t].random_genome();
      goal_turn[i][t]=1000;
      goal_closest[i][t]=1500;
    }
  }
}

void draw() {
  if (turn==1)
    println("-----Generation: "+gen+"-----");
  if(turn==200)
    leaderboard.reset_new_score();
    
  if (turn<1000) //MAX TURNS
  {
    background(#ffffff);
    noFill();
    //rect(3, 3, 800, 494);

    //draw obstacles
    fill(#242828);
    rect(0, 451, 800, 200); // bottom leaderboard background
    //rect(800, 0 , 200 , 450);//side leaderboard background
    if(obs){
      noStroke();
      rect( 239 , 88 , 34 , 137 );
      rect( 348 , 225 , 34 , 137 );
      rect( 459.5 , 88 , 34 , 137 );
      rect( 559.5 , 225 , 34 , 137 );
    }

    //draw goal
    noStroke();
    fill(#50b0ff);
    ellipse( 719, 210.5, 29, 29);
    noStroke();

    //POSITION UPDATES
    for (int t=0; t<types; t++)
      for (int g = 0; g<num; g++) //NUM ORGANISMS
      {
        if (generation[g][t].get_state()==0)
        {
            generation[g][t].handle_mov(turn-1); 

            float dist;
            dist = dist(generation[g][t].get_X(), generation[g][t].get_Y(), 719, 210.5);
            if (dist<goal_closest[g][t])
              goal_closest[g][t]=dist;

          if (generation[g][t].get_X()>800 || generation[g][t].get_X()<0 || generation[g][t].get_Y()>450 || generation[g][t].get_Y()<0 || get(generation[g][t].get_X(), generation[g][t].get_Y())==#242828)
          {
            generation[g][t].set_state(-1);
            deads++;
            goal_turn[g][t]=turn;
          } else
          {
            if (get(generation[g][t].get_X(), generation[g][t].get_Y())==#50b0ff)
            {
              generation[g][t].set_state(1);
              goal_turn[g][t]=turn;
              deads++;
              println("goal in turn: "+turn);
            }
          }
        }
      }

    //DRAW ORGANISMS
    for (int t=0; t<types; t++)
      for (int g = num - 1; g>=0; g--) //NUM ORGANISMS
      {
        pushMatrix();
        translate(generation[g][t].get_X(), generation[g][t].get_Y());
        rotate(generation[g][t].get_angle()-PI/2);
        //switch(generation[g][t].get_state())
        switch(t) //change here team colors
        {
        case 0: {
                fill(#a281fc);//purple
                //stroke(125) ;
                //noStroke() ;
                break; }
        case 1: {
                fill(#f9df5f); //yellow
                //stroke(125) ;
                //noStroke() ;
                break; }
        case 2: {
                fill(#64f979); //green
                //stroke(125) ;
                //noStroke() ;
                break; }
        case 3: {
                fill(#ff5284); //pink
                //stroke(125) ;
                //noStroke() ;
                break; }
        case 4: {
                fill(#6b9ffc); //blue
                //stroke(125) ;
                //noStroke() ;
                break; }       
        case 5: {
                fill(#fc7e4c); //orange
               // stroke(125) ;
                //noStroke() ;
                break; }              
        }
        triangle(-4, -8, +4, -8, 0, 8);
        //ellipse( -4 , -8 , 11 , 11 ) ;
        //ellipse( -4 , -4 , 11 , 11 ) ;
        //ellipse( -4 , -8 , 2 , 11 ) ;
        popMatrix();
      }


    //draw data
    fill(255);
    noStroke();
    textSize(22);
    text("Generation: "+gen, 560, 520);
    //text("Fitness: "+top_fitness, 810, 60);
    text("Time Left: "+(1000-turn), 560, 540);
    text("Alive: "+(num*types-deads), 560, 560);
    textFont(font1,18) ;
    text("SPECIES", 39.325 , 489.091);
    for (int t=0; t<types; t++)
    {
      fill(255);
      text("#"+(t+1), (39.325 + t * 80), 520);
      switch(t)
      {
      case 0: 
        fill(#a281fc); stroke(#a281fc); break;
      case 1: 
        fill(#f9df5f); stroke(#f9df5f); break;
      case 2: 
        fill(#64f979); stroke(#64f979); break;
      case 3: 
        fill(#ff5284); stroke(#ff5284);break;
      case 4: 
        fill(#6b9ffc); stroke(#6b9ffc); break;
      case 5: 
        fill(#fc7e4c); stroke(#fc7e4c); break;
      }
      text(leaderboard.get_name(t),(39.325+leaderboard.get_position(t)*80),540);
      noFill();
      if(leaderboard.get_new_state(t))
        fill(#56ffff);
      else
        fill(251);
      text(int(top2_score[0][t]), (39.325+leaderboard.get_position(t)*80) , 560 );
    }
    // vision enabled
    if(vision == true ) {
      translate(719, 210.5) ;
      rotate(ang);
      //fill(80,178,255,25) ;
      fill(#50b2ff) ;
      noStroke();
      triangle(0,0,100,50,50,100) ;
      ang = ang + rot_speed/100 ;
      //vision detector ........updated
    for (int t=0; t<types; t++)
      for (int g = 0; g<num; g++)
      {
        if (generation[g][t].get_state()==0)
        {
          if ( get(generation[g][t].get_X(), generation[g][t].get_Y())==((#50b2ff)))
          {
            //rotate(generation[g][t].get_angle()-180);
            generation[g][t].set_angle(180-generation[g][t].get_angle());
            generation[g][t].set_state(-1);
            deads++;
            goal_turn[g][t]=turn;
          }
        }
      }
   }
    
    stroke(0);
    //check if last turn
    if (turn == 999 || deads == num * types ) // ..........updated
    {
      for (int t=0; t<types; t++)
      {
        for (int j=0; j<num; j++)  //fitness
        {
          //score = 1*(1500-final_dist)+0.5*(1500-closest_dist)+1*(1000-goal_turn)+0.5*(1000-lastmove_turn)
          float score = 0;
          float final_dist = dist(generation[j][t].get_X(), generation[j][t].get_Y(), 719, 210.5);
          if (generation[j][t].get_state()==1) //got gold
            score = 1*(1500-final_dist)+0.5*(1500-final_dist)+1*(1000-goal_turn[j][t])+0.3*(1000-goal_turn[j][t]);
            //score = (1000 - final_dist);
          else         
            score = 1*(1500-final_dist)+0.5*(1500-goal_closest[j][t])+1*(1000-1000)+0.3*(1000-goal_turn[j][t]);
            //println(j+"-"+score+" (best:"+top2_score[0][t]);

          //if new top2
          if (score>top2_score[0][t]) //1st
          {
            top2_score[1][t]=top2_score[0][t];
            top2[t]=copy_genome(top1[t]);
            top2_score[0][t]=score;
            top1[t]=copy_genome(generation[j][t].get_genome());
            leaderboard.set_new_true(t);
          } else
            if (score>top2_score[1][t] && j!=0) //2nd
          {
            top2_score[1][t]=score;
            top2[t]=copy_genome(generation[j][t].get_genome());
          }
        }

        leaderboard.reset();
        for(int x=0; x<types; x++)
          leaderboard.update(top2_score[0][x],x);

        //new genome     
        generation[0][t].set_genome(top1[t]);
        generation[1][t].set_genome(top2[t]);
        for (int n=2; n<num; n++)
        {
          generation[n][t].child(generation[0][t], generation[1][t], 3); //change mutation of teams
        }

        //top2_score[0]=0;
        //top2_score[1]=0;
        for (int j=0; j<num; j++)
        {
          generation[j][t].reset();
          goal_turn[j][t]=1000;
          goal_closest[j][t]=1500;
        }
      }
      //reset things
      turn=0;
      deads=0;
      gen++;
    }
    //println("top1 score: "+top2_score[0]);
    //println("top2 score: "+top2_score[1]);

    turn++;
  }
}

float[] copy_genome(float[] old)
{
  float[] new_ = new float[1000];
  for (int i=0; i<1000; i++)
  new_[i]=old[i];
  return new_;
}
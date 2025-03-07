import de.bezier.guido.*;

private static final int NUM_ROWS = 40;
private static final int NUM_COLS = 40;
private static final int NUM_MINES = 150;

private MSButton[][] buttons;
private ArrayList <MSButton> mines = new ArrayList <MSButton> ();
private boolean gameOver = false;
private boolean gameStarted = false; 
private boolean firstClick = true;

void setup () {
  size(800, 800);
  textAlign(CENTER, CENTER);

  Interactive.make( this );

  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int i = 0; i < buttons.length; i++) {
    for (int j = 0; j < buttons[i].length; j++) {
      buttons[i][j] = new MSButton(i, j);
    }
  }

  for (int k = 0; k < NUM_MINES; k++) {
    setMines();
  }
}

public void setMines() {
    int r = (int)(Math.random() * NUM_ROWS);
    int c = (int)(Math.random() * NUM_COLS);
    if (firstClick || mines.contains(buttons[r][c]) || buttons[r][c].clicked) {
        setMines();
    } else {
        mines.add(buttons[r][c]);
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() && !gameOver)
      displayWinningMessage();
    if(!isWon() && gameOver)
      displayLosingMessage();
}
public boolean isWon()
{
  for (int i = 0; i < buttons.length; i++) {
    for (int j = 0; j < buttons[i].length; j++) {
      if (mines.contains(buttons[i][j]) && !buttons[i][j].isFlagged()) {
        return false;
      }
      if (!mines.contains(buttons[i][j]) && !buttons[i][j].clicked) {
        return false;
      }
    }
  }
  return true;
}
public void displayLosingMessage() {
  String[] arr = {"Y", "o", "u", " ", "L", "o", "s", "t", "!"};

  for (int k = 0; k < arr.length; k++) {
    if (k < NUM_COLS) {
      buttons[0][k].setLabel(arr[k]);
      buttons[0][k].clicked = true; 
    }
  }

  gameOver = true;
}

public void displayWinningMessage() {
  String[] arr = {"Y", "o", "u", " ", "W", "o", "n", "!"};

  for (int k = 0; k < arr.length; k++) {
    if (k < NUM_COLS) {
      buttons[0][k].setLabel(arr[k]);
      buttons[0][k].clicked = true; 
    }
  }
  if(gameOver) 
    return;
}
public boolean isValid(int r, int c)
{
    return !(r >= NUM_ROWS || c >= NUM_COLS || r < 0 || c < 0);
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for (int i = -1; i < 2; i++) {
    for (int j = -1; j < 2; j++) {
      if (i == 0 && j == 0) {
        continue;
      }
      if (isValid(row + i, col + j)) {
        if (mines.contains(buttons[row + i][col + j])) {
          numMines++;
        }
      }
    }
  }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 800/NUM_COLS;
        height = 800/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); 
    }
public void mousePressed () {
    if (gameOver) {
        return; 
    }

    if (firstClick) {
        firstClick = false;
        // Regenerate mines after the first click to avoid a mine being placed on the first clicked box
        resetMines();
    }

    if (mouseButton == RIGHT && !clicked) {
        flagged = !flagged;
    } else if (!flagged) {
        clicked = true;
        if (mines.contains(this)) {
            displayLosingMessage(); 
            gameOver = true; 
            for (MSButton mine : mines) {
                mine.clicked = true; 
            }
        } else if (countMines(myRow, myCol) > 0) {
            setLabel(str(countMines(myRow, myCol)));
        } else {
            for (int i = -1; i <= 1; i++) {
                for (int j = -1; j <= 1; j++) {
                    if (i == 0 && j == 0) {
                        continue;
                    }

                    if (isValid(myRow + i, myCol + j)) {
                        if (!buttons[myRow + i][myCol + j].flagged && !buttons[myRow + i][myCol + j].clicked) {
                            buttons[myRow + i][myCol + j].mousePressed();
                        }
                    }
                }
            }
        }
    }
}
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
void keyPressed() {
    if (gameOver) {
        resetBoard(); 
    }
}
public void resetBoard() {
    gameOver = false; 
    mines.clear();    
    for (int i = 0; i < buttons.length; i++) {
        for (int j = 0; j < buttons[i].length; j++) {
            buttons[i][j].clicked = false; 
            buttons[i][j].flagged = false; 
            buttons[i][j].setLabel("");    
        }
    }
    for (int k = 0; k < NUM_MINES; k++) {
        setMines();
    }
}
public void resetMines() {
    mines.clear(); 
    for (int k = 0; k < NUM_MINES; k++) {
        setMines();
    }
}


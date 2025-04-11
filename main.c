#include "main.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "gba.h"
#include "title.h"
#include "play.h"
#include "win.h"
#include "lose.h"

#include "player_sprite.h"


#define BROWN COLOR(31, 16, 0)
enum gba_state {
    START,
    PLAY,
    WIN,
    LOSE,
};


int main(void) {
  // Enable Mode 3 + BG2 once
  REG_DISPCNT = MODE3 | BG2_ENABLE;

  u32 prevButtons = BUTTONS;
  u32 currButtons = BUTTONS;
  enum gba_state state = START;

  // Timer vars
  u32 startTime = 0;
  u32 finalTime = 0;
  char timerText[16];

  // Entities: player, goal, two enemies
  Entity player, goal, enemy1, enemy2;
    // Title‐screen text animation state
    int boxLeft   = 10;
    int boxTop    = HEIGHT - 40;      // 40px tall region
    int boxRight  = boxLeft + 80;     // 80px wide region
    int boxBottom = HEIGHT - 8;       // leave room for 8px text height

    // Title‑screen text state
    int titleTextCol = boxLeft;
    int titleTextRow = boxTop;
    int titleTextDx  = 1;
    int titleTextDy  = 1;
    char titleText[] = "Apples!"; // >= 5 chars
  while (1) {
      // Poll input & sync to 60 Hz
      prevButtons = currButtons;
      currButtons = BUTTONS;
      waitForVBlank();

      switch (state) {
          case START:
              
              drawFullScreenImageDMA(title);

              // Animate the text bouncing around
              {
                int len   = strlen(titleText);
                int textW = len * 6;
                int textH = 8;
        
                // Move
                titleTextCol += titleTextDx;
                titleTextRow += titleTextDy;
        
                // Bounce horizontally within [boxLeft, boxRight-textW]
                if (titleTextCol < boxLeft || titleTextCol + textW > boxRight) {
                    titleTextDx = -titleTextDx;
                    titleTextCol += titleTextDx;
                }
                // Bounce vertically within [boxTop, boxBottom-textH]
                if (titleTextRow < boxTop || titleTextRow + textH > boxBottom) {
                    titleTextDy = -titleTextDy;
                    titleTextRow += titleTextDy;
                }
        
                // Draw the moving text
                drawString(titleTextRow, titleTextCol, titleText, BLACK);
            }


              if (KEY_JUST_PRESSED(BUTTON_START, currButtons, prevButtons)) {
                  // Reset timer
                  startTime = vBlankCounter;

                  // Initialize player at left center
                  player = (Entity){
                    (HEIGHT * 3) / 4,
                    10,
                    16,
                    16
                  };
                  // Initialize goal at right center
                  goal = (Entity){
                    (HEIGHT*3) / 4,
                      WIDTH - 10 - 16,
                      16, 16
                  };
                  // Initialize enemies under middle line
                  enemy1 = (Entity){
                      (HEIGHT / 2) + 10,
                      WIDTH / 3,
                      16, 16
                  };
                  enemy2 = (Entity){
                      (HEIGHT*3) / 4,
                      (2 * WIDTH) / 3,
                      16, 16
                  };

                  state = PLAY;
              }
              break;

          case PLAY:
              // Draw play background
              drawFullScreenImageDMA(play);

              // Player movement
              if (KEY_DOWN(BUTTON_UP, currButtons) && player.row > HEIGHT/2) {
                player.row--;
              }
              if (KEY_DOWN(BUTTON_DOWN, currButtons) && player.row + player.height < HEIGHT) {
                  player.row++;
              }
              if (KEY_DOWN(BUTTON_LEFT, currButtons) && player.col > 0) {
                  player.col--;
              }
              if (KEY_DOWN(BUTTON_RIGHT, currButtons) && player.col + player.width < WIDTH) {
                  player.col++;
              }
        
              // Draw player and goal
              drawImageDMA(
                player.row, player.col,
                player.width, player.height,
                player_sprite
              );
              drawRectDMA(goal.row,   goal.col,   goal.width,   goal.height,   RED);

              // Draw enemies
              drawRectDMA(enemy1.row, enemy1.col, enemy1.width, enemy1.height, BROWN);
              drawRectDMA(enemy2.row, enemy2.col, enemy2.width, enemy2.height, BROWN);

              // Draw running timer (right‑aligned, bottom)
              {
                  u32 elapsed = vBlankCounter - startTime;
                  u32 seconds = elapsed / 60;
                  int len = snprintf(timerText, sizeof(timerText), "Time:%2d", seconds);
                  int col = WIDTH - (len * 6) - 5;
                  drawString(HEIGHT - 8, col, timerText, WHITE);
              }

              // Collision with goal → WIN
              if (player.col <  goal.col + goal.width  &&
                  player.col + player.width > goal.col  &&
                  player.row <  goal.row + goal.height &&
                  player.row + player.height > goal.row) {
                  finalTime = (vBlankCounter - startTime) / 60;
                  state = WIN;
                  break;
              }

              // Collision with enemies → LOSE
              if ((player.col <  enemy1.col + enemy1.width  &&
                   player.col + player.width > enemy1.col  &&
                   player.row <  enemy1.row + enemy1.height &&
                   player.row + player.height > enemy1.row)
               ||(player.col <  enemy2.col + enemy2.width  &&
                   player.col + player.width > enemy2.col  &&
                   player.row <  enemy2.row + enemy2.height &&
                   player.row + player.height > enemy2.row)) {
                  state = LOSE;
                  break;
              }

              // Reset to title
              if (KEY_JUST_PRESSED(BUTTON_SELECT, currButtons, prevButtons)) {
                  state = START;
              }
              break;

          case WIN:
              drawFullScreenImageDMA(win);
              {
                  int len = snprintf(timerText, sizeof(timerText), "Time:%2d", finalTime);
                  int col = WIDTH - (len * 6) - 5;
                  int row = HEIGHT - 8 - 5;
                  drawString(row, col, timerText, BLACK);
              }
              if (KEY_JUST_PRESSED(BUTTON_SELECT, currButtons, prevButtons)) {
                  state = START;
              }
              break;

          case LOSE:
              drawFullScreenImageDMA(lose);
              if (KEY_JUST_PRESSED(BUTTON_SELECT, currButtons, prevButtons)) {
                  state = START;
              }
              break;
      }
  }

  return 0;
}
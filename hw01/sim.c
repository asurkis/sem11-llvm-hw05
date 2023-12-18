#include "sim.h"
#include <SDL.h>
#include <SDL2/SDL_timer.h>
#include <unistd.h>

static SDL_Window *window = NULL;
static int shouldContinue = 1;

static void processEvents() {
        SDL_Event event;
        while (SDL_PollEvent(&event)) {
                switch (event.type) {
                case SDL_QUIT:
                        shouldContinue = 0;
                        break;
                case SDL_KEYDOWN:
                        switch (event.key.keysym.scancode) {
                        case SDL_SCANCODE_ESCAPE:
                                shouldContinue = 0;
                                break;
                        default:
                                break;
                        }
                default:
                        break;
                }
        }
}

void simBegin() {
        SDL_Init(SDL_INIT_EVENTS | SDL_INIT_VIDEO);
        window = SDL_CreateWindow("Main window",
                                  SDL_WINDOWPOS_CENTERED,
                                  SDL_WINDOWPOS_CENTERED,
                                  1280,
                                  720,
                                  SDL_WINDOW_RESIZABLE | SDL_WINDOW_ALLOW_HIGHDPI);
        simFlush();
}

void simEnd() {
        SDL_DestroyWindow(window);
        SDL_Quit();
}

int simShouldContinue() { return shouldContinue; }

SDL_Surface *windowSurface = NULL;
int w = 0;
int h = 0;
int offsetX = 0;
int offsetY = 0;
int cellSize = 0;

void simSetPixel(int x, int y, int rgb) {
        int r = (rgb >> 16) & 255;
        int g = (rgb >> 8) & 255;
        int b = (rgb >> 0) & 255;
        Uint32 color = SDL_MapRGB(windowSurface->format, r, g, b);
        SDL_Rect rect = {};
        rect.x = cellSize * x + offsetX;
        rect.y = cellSize * y + offsetY;
        rect.w = cellSize;
        rect.h = cellSize;
        SDL_FillRect(windowSurface, &rect, color);
}

void simFlush() {
        SDL_UpdateWindowSurface(window);
        SDL_Delay(100);
        processEvents();

        windowSurface = SDL_GetWindowSurface(window);
        SDL_GetWindowSize(window, &w, &h);

        int cand1 = w / SIM_X_SIZE;
        int cand2 = h / SIM_Y_SIZE;
        cellSize = cand1 < cand2 ? cand1 : cand2;
        offsetX = (w - SIM_X_SIZE * cellSize) / 2;
        offsetY = (h - SIM_Y_SIZE * cellSize) / 2;

        SDL_Rect rect = {};
        rect.x = 0;
        rect.y = 0;
        rect.w = w;
        rect.h = h;
        SDL_FillRect(windowSurface, &rect, SDL_MapRGB(windowSurface->format, 192, 192, 192));
}

void simDebug(int val) {
        SDL_Log("%d\n", val);
}

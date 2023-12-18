#include "sim.h"

static int isPrime(int x) {
        if (x < 2) return 0;
        for (int k = 2; k * k <= x; ++k) {
                if (x % k == 0) return 0;
        }
        return 1;
}

static void fillNextState(int frame) {
        for (int row = 0; row < SIM_Y_SIZE; ++row) {
                for (int col = 0; col < SIM_X_SIZE; ++col) {
                        int xor = (row + frame) ^ (col + frame);
                        int prime = isPrime(xor);
                        simSetPixel(col, row, prime ? 0xFFFFFF : 0);
                }
        }
}

int main(int _argc, char *_argv[]) {
        simBegin();
        int frame = 0;
        while (simShouldContinue()) {
                fillNextState(frame++);
                simFlush();
        }
        simEnd();
        return 0;
}

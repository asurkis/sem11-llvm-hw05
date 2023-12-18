#ifndef SIM_H
#define SIM_H

#define SIM_X_SIZE 640
#define SIM_Y_SIZE 360

#ifdef __cplusplus
extern "C" {
#endif

extern void simBegin();
extern void simEnd();
extern int simShouldContinue();

extern void simSetPixel(int x, int y, int rgb);
extern void simFlush();

extern void simDebug(int val);

#ifdef __cplusplus
}
#endif

#endif

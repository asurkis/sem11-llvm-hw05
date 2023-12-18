; ModuleID = 'main.c'
source_filename = "main.c"
target triple = "x86_64-pc-linux-gnu"

@REG = private global [32 x i32] zeroinitializer

define i32 @main() {
  call void @simBegin()
  store i32 0, ptr @REG, align 4
  store i32 -1, ptr getelementptr inbounds (i32, ptr @REG, i32 1), align 4
  store i32 2, ptr getelementptr inbounds (i32, ptr @REG, i32 29), align 4
  store i32 640, ptr getelementptr inbounds (i32, ptr @REG, i32 30), align 4
  store i32 360, ptr getelementptr inbounds (i32, ptr @REG, i32 31), align 4
  br label %simLoopCond

simLoopCond:                                      ; preds = %rowLoopEnd, %0
  store i32 -1, ptr getelementptr inbounds (i32, ptr @REG, i32 2), align 4
  %1 = load i32, ptr getelementptr inbounds (i32, ptr @REG, i32 1), align 4
  %2 = add i32 %1, 1
  store i32 %2, ptr getelementptr inbounds (i32, ptr @REG, i32 1), align 4
  %3 = call i32 @simShouldContinue()
  store i32 %3, ptr getelementptr inbounds (i32, ptr @REG, i32 3), align 4
  %4 = load i32, ptr @REG, align 4
  %5 = load i32, ptr getelementptr inbounds (i32, ptr @REG, i32 3), align 4
  %6 = icmp eq i32 %4, %5
  br i1 %6, label %simLoopEnd, label %rowLoopCond

simLoopEnd:                                       ; preds = %simLoopCond
  call void @simEnd()
  ret i32 0

rowLoopCond:                                      ; preds = %colLoopCond, %simLoopCond
  store i32 -1, ptr getelementptr inbounds (i32, ptr @REG, i32 3), align 4
  %7 = load i32, ptr getelementptr inbounds (i32, ptr @REG, i32 2), align 4
  %8 = add i32 %7, 1
  store i32 %8, ptr getelementptr inbounds (i32, ptr @REG, i32 2), align 4
  %9 = load i32, ptr getelementptr inbounds (i32, ptr @REG, i32 2), align 4
  %10 = load i32, ptr getelementptr inbounds (i32, ptr @REG, i32 31), align 4
  %11 = icmp slt i32 %9, %10
  br i1 %11, label %colLoopCond, label %rowLoopEnd

colLoopCond:                                      ; preds = %colLoopBody2, %rowLoopCond
  %12 = load i32, ptr getelementptr inbounds (i32, ptr @REG, i32 3), align 4
  %13 = add i32 %12, 1
  store i32 %13, ptr getelementptr inbounds (i32, ptr @REG, i32 3), align 4
  %14 = load i32, ptr getelementptr inbounds (i32, ptr @REG, i32 3), align 4
  %15 = load i32, ptr getelementptr inbounds (i32, ptr @REG, i32 30), align 4
  %16 = icmp slt i32 %14, %15
  br i1 %16, label %colLoopBody1, label %rowLoopCond

rowLoopEnd:                                       ; preds = %rowLoopCond
  call void @simFlush()
  br label %simLoopCond

colLoopBody1:                                     ; preds = %colLoopCond
  %17 = load i32, ptr getelementptr inbounds (i32, ptr @REG, i32 1), align 4
  %18 = load i32, ptr getelementptr inbounds (i32, ptr @REG, i32 2), align 4
  %19 = add i32 %17, %18
  store i32 %19, ptr getelementptr inbounds (i32, ptr @REG, i32 4), align 4
  %20 = load i32, ptr getelementptr inbounds (i32, ptr @REG, i32 1), align 4
  %21 = load i32, ptr getelementptr inbounds (i32, ptr @REG, i32 3), align 4
  %22 = add i32 %20, %21
  store i32 %22, ptr getelementptr inbounds (i32, ptr @REG, i32 6), align 4
  %23 = load i32, ptr getelementptr inbounds (i32, ptr @REG, i32 4), align 4
  %24 = load i32, ptr getelementptr inbounds (i32, ptr @REG, i32 6), align 4
  %25 = xor i32 %23, %24
  store i32 %25, ptr getelementptr inbounds (i32, ptr @REG, i32 4), align 4
  store i32 1, ptr getelementptr inbounds (i32, ptr @REG, i32 6), align 4
  %26 = load i32, ptr getelementptr inbounds (i32, ptr @REG, i32 4), align 4
  %27 = load i32, ptr getelementptr inbounds (i32, ptr @REG, i32 29), align 4
  %28 = icmp slt i32 %26, %27
  br i1 %28, label %pixelNotPrime, label %primeLoopCond

pixelNotPrime:                                    ; preds = %primeLoopBody, %colLoopBody1
  store i32 0, ptr getelementptr inbounds (i32, ptr @REG, i32 5), align 4
  br label %colLoopBody2

primeLoopCond:                                    ; preds = %primeLoopBody, %colLoopBody1
  %29 = load i32, ptr getelementptr inbounds (i32, ptr @REG, i32 6), align 4
  %30 = add i32 %29, 1
  store i32 %30, ptr getelementptr inbounds (i32, ptr @REG, i32 6), align 4
  %31 = load i32, ptr getelementptr inbounds (i32, ptr @REG, i32 6), align 4
  %32 = load i32, ptr getelementptr inbounds (i32, ptr @REG, i32 6), align 4
  %33 = mul i32 %31, %32
  store i32 %33, ptr getelementptr inbounds (i32, ptr @REG, i32 7), align 4
  %34 = load i32, ptr getelementptr inbounds (i32, ptr @REG, i32 4), align 4
  %35 = load i32, ptr getelementptr inbounds (i32, ptr @REG, i32 7), align 4
  %36 = icmp slt i32 %34, %35
  br i1 %36, label %pixelPrime, label %primeLoopBody

pixelPrime:                                       ; preds = %primeLoopCond
  store i32 16777215, ptr getelementptr inbounds (i32, ptr @REG, i32 5), align 4
  br label %colLoopBody2

primeLoopBody:                                    ; preds = %primeLoopCond
  %37 = load i32, ptr getelementptr inbounds (i32, ptr @REG, i32 4), align 4
  %38 = load i32, ptr getelementptr inbounds (i32, ptr @REG, i32 6), align 4
  %39 = srem i32 %37, %38
  store i32 %39, ptr getelementptr inbounds (i32, ptr @REG, i32 7), align 4
  %40 = load i32, ptr @REG, align 4
  %41 = load i32, ptr getelementptr inbounds (i32, ptr @REG, i32 7), align 4
  %42 = icmp eq i32 %40, %41
  br i1 %42, label %pixelNotPrime, label %primeLoopCond

colLoopBody2:                                     ; preds = %pixelNotPrime, %pixelPrime
  %43 = load i32, ptr getelementptr inbounds (i32, ptr @REG, i32 3), align 4
  %44 = load i32, ptr getelementptr inbounds (i32, ptr @REG, i32 2), align 4
  %45 = load i32, ptr getelementptr inbounds (i32, ptr @REG, i32 5), align 4
  call void @simSetPixel(i32 %43, i32 %44, i32 %45)
  br label %colLoopCond
}

declare void @simBegin()

declare void @simFlush()

declare void @simEnd()

declare i32 @simShouldContinue()

declare void @simSetPixel(i32, i32, i32)

declare void @simDebug(i32)

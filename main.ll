; ModuleID = 'main.c'
source_filename = "main.c"
target triple = "x86_64-pc-linux-gnu"

@BUF = private global [2 x [2304 x i32]] zeroinitializer
@board = private global ptr @BUF
@boardNext = internal global ptr getelementptr inbounds ([2 x [2304 x i32]], ptr @BUF, i64 0, i64 1, i64 0)

define i32 @main() {
  tail call void @simBegin()
  %1 = load ptr, ptr @board, align 8
  %2 = getelementptr inbounds i32, ptr %1, i32 1
  store i32 1, ptr %2, align 4
  %3 = getelementptr inbounds i32, ptr %1, i32 66
  store i32 1, ptr %3, align 4
  %4 = getelementptr inbounds i32, ptr %1, i32 128
  store i32 1, ptr %4, align 4
  %5 = getelementptr inbounds i32, ptr %1, i32 129
  store i32 1, ptr %5, align 4
  %6 = getelementptr inbounds i32, ptr %1, i32 130
  store i32 1, ptr %6, align 4
  %7 = tail call i32 @simShouldContinue()
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %126, label %9

9:                                                ; preds = %21, %0
  %10 = phi i1 [ %22, %21 ], [ true, %0 ]
  %11 = phi i32 [ %23, %21 ], [ 0, %0 ]
  %12 = add nsw i32 %11, -1
  %13 = icmp ult i32 %12, 36
  %14 = shl nuw nsw i32 %12, 6
  %15 = shl i32 %11, 6
  %16 = icmp ult i32 %11, 35
  %17 = add nuw nsw i32 %15, 64
  br label %24

18:                                               ; preds = %105
  %19 = add nuw nsw i32 %11, 1
  %20 = icmp eq i32 %19, 36
  br i1 %20, label %121, label %21

21:                                               ; preds = %121, %18
  %22 = phi i1 [ %16, %18 ], [ true, %121 ]
  %23 = phi i32 [ %19, %18 ], [ 0, %121 ]
  br label %9

24:                                               ; preds = %105, %9
  %25 = phi i32 [ 0, %9 ], [ %57, %105 ]
  %26 = load ptr, ptr @board, align 8
  %27 = add nsw i32 %25, -1
  %28 = icmp ult i32 %27, 64
  %29 = select i1 %13, i1 %28, i1 false
  br i1 %29, label %30, label %35

30:                                               ; preds = %24
  %31 = add nuw nsw i32 %27, %14
  %32 = zext i32 %31 to i64
  %33 = getelementptr inbounds i32, ptr %26, i64 %32
  %34 = load i32, ptr %33, align 4
  br label %39

35:                                               ; preds = %24
  br i1 %13, label %39, label %36

36:                                               ; preds = %35
  %37 = add nuw nsw i32 %25, 1
  %38 = icmp ne i32 %25, 63
  br label %55

39:                                               ; preds = %35, %30
  %40 = phi i32 [ %34, %30 ], [ 0, %35 ]
  %41 = or i32 %25, %14
  %42 = zext i32 %41 to i64
  %43 = getelementptr inbounds i32, ptr %26, i64 %42
  %44 = load i32, ptr %43, align 4
  %45 = add nsw i32 %44, %40
  %46 = add nuw nsw i32 %25, 1
  %47 = icmp ne i32 %25, 63
  %48 = select i1 %13, i1 %47, i1 false
  br i1 %48, label %49, label %55

49:                                               ; preds = %39
  %50 = add nuw nsw i32 %46, %14
  %51 = zext i32 %50 to i64
  %52 = getelementptr inbounds i32, ptr %26, i64 %51
  %53 = load i32, ptr %52, align 4
  %54 = add nsw i32 %53, %45
  br label %55

55:                                               ; preds = %49, %39, %36
  %56 = phi i1 [ true, %49 ], [ %47, %39 ], [ %38, %36 ]
  %57 = phi i32 [ %46, %49 ], [ %46, %39 ], [ %37, %36 ]
  %58 = phi i32 [ %54, %49 ], [ %45, %39 ], [ 0, %36 ]
  %59 = select i1 %10, i1 %28, i1 false
  br i1 %59, label %60, label %66

60:                                               ; preds = %55
  %61 = add nuw nsw i32 %27, %15
  %62 = zext i32 %61 to i64
  %63 = getelementptr inbounds i32, ptr %26, i64 %62
  %64 = load i32, ptr %63, align 4
  %65 = add nsw i32 %64, %58
  br label %67

66:                                               ; preds = %55
  br i1 %10, label %67, label %81

67:                                               ; preds = %66, %60
  %68 = phi i32 [ %65, %60 ], [ %58, %66 ]
  %69 = or i32 %25, %15
  %70 = zext i32 %69 to i64
  %71 = getelementptr inbounds i32, ptr %26, i64 %70
  %72 = load i32, ptr %71, align 4
  %73 = add nsw i32 %72, %68
  %74 = select i1 %10, i1 %56, i1 false
  br i1 %74, label %75, label %81

75:                                               ; preds = %67
  %76 = add nuw nsw i32 %57, %15
  %77 = zext i32 %76 to i64
  %78 = getelementptr inbounds i32, ptr %26, i64 %77
  %79 = load i32, ptr %78, align 4
  %80 = add nsw i32 %79, %73
  br label %81

81:                                               ; preds = %75, %67, %66
  %82 = phi i32 [ %80, %75 ], [ %73, %67 ], [ %58, %66 ]
  %83 = select i1 %16, i1 %28, i1 false
  br i1 %83, label %84, label %90

84:                                               ; preds = %81
  %85 = add nuw nsw i32 %27, %17
  %86 = zext i32 %85 to i64
  %87 = getelementptr inbounds i32, ptr %26, i64 %86
  %88 = load i32, ptr %87, align 4
  %89 = add nsw i32 %88, %82
  br label %91

90:                                               ; preds = %81
  br i1 %16, label %91, label %105

91:                                               ; preds = %90, %84
  %92 = phi i32 [ %89, %84 ], [ %82, %90 ]
  %93 = or i32 %25, %17
  %94 = zext i32 %93 to i64
  %95 = getelementptr inbounds i32, ptr %26, i64 %94
  %96 = load i32, ptr %95, align 4
  %97 = add nsw i32 %96, %92
  %98 = select i1 %16, i1 %56, i1 false
  br i1 %98, label %99, label %105

99:                                               ; preds = %91
  %100 = add nuw nsw i32 %57, %17
  %101 = zext i32 %100 to i64
  %102 = getelementptr inbounds i32, ptr %26, i64 %101
  %103 = load i32, ptr %102, align 4
  %104 = add nsw i32 %103, %97
  br label %105

105:                                              ; preds = %99, %91, %90
  %106 = phi i32 [ %104, %99 ], [ %97, %91 ], [ %82, %90 ]
  %107 = or i32 %25, %15
  %108 = zext i32 %107 to i64
  %109 = getelementptr inbounds i32, ptr %26, i64 %108
  %110 = load i32, ptr %109, align 4
  %111 = icmp eq i32 %110, 0
  %112 = icmp eq i32 %106, 3
  %113 = add i32 %106, -3
  %114 = icmp ult i32 %113, 2
  %115 = select i1 %111, i1 %112, i1 %114
  %116 = zext i1 %115 to i32
  %117 = load ptr, ptr @boardNext, align 8
  %118 = getelementptr inbounds i32, ptr %117, i64 %108
  store i32 %116, ptr %118, align 4
  %119 = select i1 %115, i32 0, i32 16777215
  tail call void @simSetPixel(i32 %25, i32 %11, i32 %119)
  %120 = icmp ult i32 %57, 64
  br i1 %120, label %24, label %18

121:                                              ; preds = %18
  %122 = load ptr, ptr @board, align 8
  %123 = load ptr, ptr @boardNext, align 8
  store ptr %123, ptr @board, align 8
  store ptr %122, ptr @boardNext, align 8
  tail call void @simFlush()
  %124 = tail call i32 @simShouldContinue()
  %125 = icmp eq i32 %124, 0
  br i1 %125, label %126, label %21

126:                                              ; preds = %121, %0
  tail call void @simEnd()
  ret i32 0
}

declare void @simBegin()

declare void @simFlush()

declare void @simEnd()

declare i32 @simShouldContinue()

declare void @simSetPixel(i32, i32, i32)

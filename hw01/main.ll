; ModuleID = 'main.c'
source_filename = "main.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nounwind sspstrong uwtable
define dso_local i32 @main(i32 noundef %0, ptr nocapture noundef readnone %1) local_unnamed_addr #0 {
  tail call void (...) @simBegin() #2
  %3 = tail call i32 (...) @simShouldContinue() #2
  %4 = icmp eq i32 %3, 0
  br i1 %4, label %36, label %5

5:                                                ; preds = %2, %32
  %6 = phi i32 [ %33, %32 ], [ 0, %2 ]
  br label %7

7:                                                ; preds = %10, %5
  %8 = phi i32 [ 0, %5 ], [ %11, %10 ]
  %9 = add nuw nsw i32 %8, %6
  br label %13

10:                                               ; preds = %28
  %11 = add nuw nsw i32 %8, 1
  %12 = icmp eq i32 %11, 360
  br i1 %12, label %32, label %7, !llvm.loop !5

13:                                               ; preds = %28, %7
  %14 = phi i32 [ 0, %7 ], [ %30, %28 ]
  %15 = add nuw nsw i32 %14, %6
  %16 = xor i32 %15, %9
  %17 = icmp ult i32 %16, 2
  br i1 %17, label %28, label %18

18:                                               ; preds = %13
  %19 = icmp ult i32 %16, 4
  br i1 %19, label %28, label %24

20:                                               ; preds = %24
  %21 = add nuw nsw i32 %25, 1
  %22 = mul nsw i32 %21, %21
  %23 = icmp ugt i32 %22, %16
  br i1 %23, label %28, label %24, !llvm.loop !7

24:                                               ; preds = %18, %20
  %25 = phi i32 [ %21, %20 ], [ 2, %18 ]
  %26 = urem i32 %16, %25
  %27 = icmp eq i32 %26, 0
  br i1 %27, label %28, label %20

28:                                               ; preds = %24, %20, %18, %13
  %29 = phi i32 [ 0, %13 ], [ 16777215, %18 ], [ 0, %24 ], [ 16777215, %20 ]
  tail call void @simSetPixel(i32 noundef %14, i32 noundef %8, i32 noundef %29) #2
  %30 = add nuw nsw i32 %14, 1
  %31 = icmp eq i32 %30, 640
  br i1 %31, label %10, label %13, !llvm.loop !8

32:                                               ; preds = %10
  %33 = add nuw nsw i32 %6, 1
  tail call void (...) @simFlush() #2
  %34 = tail call i32 (...) @simShouldContinue() #2
  %35 = icmp eq i32 %34, 0
  br i1 %35, label %36, label %5, !llvm.loop !9

36:                                               ; preds = %32, %2
  tail call void (...) @simEnd() #2
  ret i32 0
}

declare void @simBegin(...) local_unnamed_addr #1

declare i32 @simShouldContinue(...) local_unnamed_addr #1

declare void @simFlush(...) local_unnamed_addr #1

declare void @simEnd(...) local_unnamed_addr #1

declare void @simSetPixel(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

attributes #0 = { nounwind sspstrong uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{!"clang version 16.0.6"}
!5 = distinct !{!5, !6}
!6 = !{!"llvm.loop.mustprogress"}
!7 = distinct !{!7, !6}
!8 = distinct !{!8, !6}
!9 = distinct !{!9, !6}

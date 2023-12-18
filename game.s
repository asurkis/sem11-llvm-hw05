# @0 --- 0
# @1 --- frame number
# @2 --- row
# @3 --- column
# @4 --- row ^ column
# @5 --- is pixel prime
# @6 --- k in prime loop
# @29 --- 2
# @30 --- column count
# @31 --- row count

simBegin
        li @0 0
        li @1 -1
        li @29 2
        li @30 640
        li @31 360
        j simLoopCond
bb simLoopCond
        li @2 -1
        addi @1 @1 1
        simShouldContinue @3
        be @0 @3 simLoopEnd rowLoopCond
bb rowLoopCond
        li @3 -1
        addi @2 @2 1
        blt @2 @31 colLoopCond rowLoopEnd

bb colLoopCond
        addi @3 @3 1
        blt @3 @30 colLoopBody1 rowLoopCond
bb colLoopBody1
        add @4 @1 @2
        add @6 @1 @3
        xor @4 @4 @6
        li @6 1
        blt @4 @29 pixelNotPrime primeLoopCond

bb primeLoopCond
        addi @6 @6 1
        mul @7 @6 @6
        blt @4 @7 pixelPrime primeLoopBody
bb primeLoopBody
        rem @7 @4 @6
        be @0 @7 pixelNotPrime primeLoopCond
bb pixelPrime
        li @5 16777215
        j colLoopBody2
bb pixelNotPrime
        li @5 0
        j colLoopBody2

bb colLoopBody2
        simSetPixel @3 @2 @5
        j colLoopCond

bb rowLoopEnd
        simFlush
        j simLoopCond
bb simLoopEnd
        simEnd
        ret

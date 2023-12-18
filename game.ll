; ModuleID = 'main.c'
source_filename = "main.c"
target triple = "x86_64-pc-linux-gnu"

@REG = private global [32 x i32] zeroinitializer

define i32 @main() {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  call void @simBegin()
  store i32 640, ptr %1, align 4
  store i32 360, ptr %2, align 4
  br label %10

10:                                               ; preds = %256, %0
  %11 = call i32 @simShouldContinue()
  %12 = icmp ne i32 %11, 0
  br i1 %12, label %13, label %14

13:                                               ; preds = %10
  store i32 0, ptr %5, align 4
  br label %17

14:                                               ; preds = %10
  %15 = call i32 @simShouldContinue()
  %16 = icmp ne i32 %15, 0
  store i32 0, ptr %5, align 4
  br label %266

17:                                               ; preds = %137, %13
  %18 = load i32, ptr %5, align 4
  %19 = load i32, ptr %2, align 4
  %20 = icmp slt i32 %18, %19
  br i1 %20, label %21, label %22

21:                                               ; preds = %17
  store i32 0, ptr %4, align 4
  br label %26

22:                                               ; preds = %17
  %23 = load i32, ptr %5, align 4
  %24 = load i32, ptr %2, align 4
  %25 = icmp slt i32 %23, %24
  store i32 0, ptr %4, align 4
  br label %145

26:                                               ; preds = %90, %21
  %27 = load i32, ptr %4, align 4
  %28 = load i32, ptr %1, align 4
  %29 = icmp slt i32 %27, %28
  br i1 %29, label %30, label %38

30:                                               ; preds = %26
  %31 = load i32, ptr %5, align 4
  %32 = load i32, ptr %3, align 4
  %33 = add i32 %31, %32
  %34 = load i32, ptr %4, align 4
  %35 = load i32, ptr %3, align 4
  %36 = add i32 %34, %35
  %37 = xor i32 %33, %36
  store i32 %37, ptr %6, align 4
  store i32 1, ptr %7, align 4
  store i32 2, ptr %8, align 4
  br label %49

38:                                               ; preds = %26
  %39 = load i32, ptr %4, align 4
  %40 = load i32, ptr %1, align 4
  %41 = icmp slt i32 %39, %40
  %42 = load i32, ptr %5, align 4
  %43 = load i32, ptr %3, align 4
  %44 = add i32 %42, %43
  %45 = load i32, ptr %4, align 4
  %46 = load i32, ptr %3, align 4
  %47 = add i32 %45, %46
  %48 = xor i32 %44, %47
  store i32 %48, ptr %6, align 4
  store i32 1, ptr %7, align 4
  store i32 2, ptr %8, align 4
  br label %96

49:                                               ; preds = %78, %30
  %50 = load i32, ptr %7, align 4
  %51 = icmp ne i32 %50, 0
  %52 = load i32, ptr %8, align 4
  %53 = load i32, ptr %8, align 4
  %54 = mul i32 %52, %53
  %55 = load i32, ptr %6, align 4
  %56 = icmp sle i32 %54, %55
  %57 = and i1 %51, %56
  br i1 %57, label %58, label %63

58:                                               ; preds = %49
  %59 = load i32, ptr %6, align 4
  %60 = load i32, ptr %8, align 4
  %61 = srem i32 %59, %60
  %62 = icmp eq i32 %61, 0
  br i1 %62, label %76, label %77

63:                                               ; preds = %49
  %64 = load i32, ptr %7, align 4
  %65 = icmp ne i32 %64, 0
  %66 = load i32, ptr %8, align 4
  %67 = load i32, ptr %8, align 4
  %68 = mul i32 %66, %67
  %69 = load i32, ptr %6, align 4
  %70 = icmp sle i32 %68, %69
  %71 = and i1 %65, %70
  %72 = load i32, ptr %6, align 4
  %73 = load i32, ptr %8, align 4
  %74 = srem i32 %72, %73
  %75 = icmp eq i32 %74, 0
  br i1 %75, label %81, label %82

76:                                               ; preds = %58
  store i32 0, ptr %7, align 4
  br label %78

77:                                               ; preds = %58
  br label %78

78:                                               ; preds = %77, %76
  %79 = load i32, ptr %8, align 4
  %80 = add i32 %79, 1
  store i32 %80, ptr %8, align 4
  br label %49

81:                                               ; preds = %63
  store i32 0, ptr %7, align 4
  br label %83

82:                                               ; preds = %63
  br label %83

83:                                               ; preds = %82, %81
  %84 = load i32, ptr %8, align 4
  %85 = add i32 %84, 1
  store i32 %85, ptr %8, align 4
  %86 = load i32, ptr %7, align 4
  %87 = icmp ne i32 %86, 0
  br i1 %87, label %88, label %89

88:                                               ; preds = %83
  store i32 16777215, ptr %9, align 4
  br label %90

89:                                               ; preds = %83
  store i32 0, ptr %9, align 4
  br label %90

90:                                               ; preds = %89, %88
  %91 = load i32, ptr %4, align 4
  %92 = load i32, ptr %5, align 4
  %93 = load i32, ptr %9, align 4
  call void @simSetPixel(i32 %91, i32 %92, i32 %93)
  %94 = load i32, ptr %4, align 4
  %95 = add i32 %94, 1
  store i32 %95, ptr %4, align 4
  br label %26

96:                                               ; preds = %125, %38
  %97 = load i32, ptr %7, align 4
  %98 = icmp ne i32 %97, 0
  %99 = load i32, ptr %8, align 4
  %100 = load i32, ptr %8, align 4
  %101 = mul i32 %99, %100
  %102 = load i32, ptr %6, align 4
  %103 = icmp sle i32 %101, %102
  %104 = and i1 %98, %103
  br i1 %104, label %105, label %110

105:                                              ; preds = %96
  %106 = load i32, ptr %6, align 4
  %107 = load i32, ptr %8, align 4
  %108 = srem i32 %106, %107
  %109 = icmp eq i32 %108, 0
  br i1 %109, label %123, label %124

110:                                              ; preds = %96
  %111 = load i32, ptr %7, align 4
  %112 = icmp ne i32 %111, 0
  %113 = load i32, ptr %8, align 4
  %114 = load i32, ptr %8, align 4
  %115 = mul i32 %113, %114
  %116 = load i32, ptr %6, align 4
  %117 = icmp sle i32 %115, %116
  %118 = and i1 %112, %117
  %119 = load i32, ptr %6, align 4
  %120 = load i32, ptr %8, align 4
  %121 = srem i32 %119, %120
  %122 = icmp eq i32 %121, 0
  br i1 %122, label %128, label %129

123:                                              ; preds = %105
  store i32 0, ptr %7, align 4
  br label %125

124:                                              ; preds = %105
  br label %125

125:                                              ; preds = %124, %123
  %126 = load i32, ptr %8, align 4
  %127 = add i32 %126, 1
  store i32 %127, ptr %8, align 4
  br label %96

128:                                              ; preds = %110
  store i32 0, ptr %7, align 4
  br label %130

129:                                              ; preds = %110
  br label %130

130:                                              ; preds = %129, %128
  %131 = load i32, ptr %8, align 4
  %132 = add i32 %131, 1
  store i32 %132, ptr %8, align 4
  %133 = load i32, ptr %7, align 4
  %134 = icmp ne i32 %133, 0
  br i1 %134, label %135, label %136

135:                                              ; preds = %130
  store i32 16777215, ptr %9, align 4
  br label %137

136:                                              ; preds = %130
  store i32 0, ptr %9, align 4
  br label %137

137:                                              ; preds = %136, %135
  %138 = load i32, ptr %4, align 4
  %139 = load i32, ptr %5, align 4
  %140 = load i32, ptr %9, align 4
  call void @simSetPixel(i32 %138, i32 %139, i32 %140)
  %141 = load i32, ptr %4, align 4
  %142 = add i32 %141, 1
  store i32 %142, ptr %4, align 4
  %143 = load i32, ptr %5, align 4
  %144 = add i32 %143, 1
  store i32 %144, ptr %5, align 4
  br label %17

145:                                              ; preds = %209, %22
  %146 = load i32, ptr %4, align 4
  %147 = load i32, ptr %1, align 4
  %148 = icmp slt i32 %146, %147
  br i1 %148, label %149, label %157

149:                                              ; preds = %145
  %150 = load i32, ptr %5, align 4
  %151 = load i32, ptr %3, align 4
  %152 = add i32 %150, %151
  %153 = load i32, ptr %4, align 4
  %154 = load i32, ptr %3, align 4
  %155 = add i32 %153, %154
  %156 = xor i32 %152, %155
  store i32 %156, ptr %6, align 4
  store i32 1, ptr %7, align 4
  store i32 2, ptr %8, align 4
  br label %168

157:                                              ; preds = %145
  %158 = load i32, ptr %4, align 4
  %159 = load i32, ptr %1, align 4
  %160 = icmp slt i32 %158, %159
  %161 = load i32, ptr %5, align 4
  %162 = load i32, ptr %3, align 4
  %163 = add i32 %161, %162
  %164 = load i32, ptr %4, align 4
  %165 = load i32, ptr %3, align 4
  %166 = add i32 %164, %165
  %167 = xor i32 %163, %166
  store i32 %167, ptr %6, align 4
  store i32 1, ptr %7, align 4
  store i32 2, ptr %8, align 4
  br label %215

168:                                              ; preds = %197, %149
  %169 = load i32, ptr %7, align 4
  %170 = icmp ne i32 %169, 0
  %171 = load i32, ptr %8, align 4
  %172 = load i32, ptr %8, align 4
  %173 = mul i32 %171, %172
  %174 = load i32, ptr %6, align 4
  %175 = icmp sle i32 %173, %174
  %176 = and i1 %170, %175
  br i1 %176, label %177, label %182

177:                                              ; preds = %168
  %178 = load i32, ptr %6, align 4
  %179 = load i32, ptr %8, align 4
  %180 = srem i32 %178, %179
  %181 = icmp eq i32 %180, 0
  br i1 %181, label %195, label %196

182:                                              ; preds = %168
  %183 = load i32, ptr %7, align 4
  %184 = icmp ne i32 %183, 0
  %185 = load i32, ptr %8, align 4
  %186 = load i32, ptr %8, align 4
  %187 = mul i32 %185, %186
  %188 = load i32, ptr %6, align 4
  %189 = icmp sle i32 %187, %188
  %190 = and i1 %184, %189
  %191 = load i32, ptr %6, align 4
  %192 = load i32, ptr %8, align 4
  %193 = srem i32 %191, %192
  %194 = icmp eq i32 %193, 0
  br i1 %194, label %200, label %201

195:                                              ; preds = %177
  store i32 0, ptr %7, align 4
  br label %197

196:                                              ; preds = %177
  br label %197

197:                                              ; preds = %196, %195
  %198 = load i32, ptr %8, align 4
  %199 = add i32 %198, 1
  store i32 %199, ptr %8, align 4
  br label %168

200:                                              ; preds = %182
  store i32 0, ptr %7, align 4
  br label %202

201:                                              ; preds = %182
  br label %202

202:                                              ; preds = %201, %200
  %203 = load i32, ptr %8, align 4
  %204 = add i32 %203, 1
  store i32 %204, ptr %8, align 4
  %205 = load i32, ptr %7, align 4
  %206 = icmp ne i32 %205, 0
  br i1 %206, label %207, label %208

207:                                              ; preds = %202
  store i32 16777215, ptr %9, align 4
  br label %209

208:                                              ; preds = %202
  store i32 0, ptr %9, align 4
  br label %209

209:                                              ; preds = %208, %207
  %210 = load i32, ptr %4, align 4
  %211 = load i32, ptr %5, align 4
  %212 = load i32, ptr %9, align 4
  call void @simSetPixel(i32 %210, i32 %211, i32 %212)
  %213 = load i32, ptr %4, align 4
  %214 = add i32 %213, 1
  store i32 %214, ptr %4, align 4
  br label %145

215:                                              ; preds = %244, %157
  %216 = load i32, ptr %7, align 4
  %217 = icmp ne i32 %216, 0
  %218 = load i32, ptr %8, align 4
  %219 = load i32, ptr %8, align 4
  %220 = mul i32 %218, %219
  %221 = load i32, ptr %6, align 4
  %222 = icmp sle i32 %220, %221
  %223 = and i1 %217, %222
  br i1 %223, label %224, label %229

224:                                              ; preds = %215
  %225 = load i32, ptr %6, align 4
  %226 = load i32, ptr %8, align 4
  %227 = srem i32 %225, %226
  %228 = icmp eq i32 %227, 0
  br i1 %228, label %242, label %243

229:                                              ; preds = %215
  %230 = load i32, ptr %7, align 4
  %231 = icmp ne i32 %230, 0
  %232 = load i32, ptr %8, align 4
  %233 = load i32, ptr %8, align 4
  %234 = mul i32 %232, %233
  %235 = load i32, ptr %6, align 4
  %236 = icmp sle i32 %234, %235
  %237 = and i1 %231, %236
  %238 = load i32, ptr %6, align 4
  %239 = load i32, ptr %8, align 4
  %240 = srem i32 %238, %239
  %241 = icmp eq i32 %240, 0
  br i1 %241, label %247, label %248

242:                                              ; preds = %224
  store i32 0, ptr %7, align 4
  br label %244

243:                                              ; preds = %224
  br label %244

244:                                              ; preds = %243, %242
  %245 = load i32, ptr %8, align 4
  %246 = add i32 %245, 1
  store i32 %246, ptr %8, align 4
  br label %215

247:                                              ; preds = %229
  store i32 0, ptr %7, align 4
  br label %249

248:                                              ; preds = %229
  br label %249

249:                                              ; preds = %248, %247
  %250 = load i32, ptr %8, align 4
  %251 = add i32 %250, 1
  store i32 %251, ptr %8, align 4
  %252 = load i32, ptr %7, align 4
  %253 = icmp ne i32 %252, 0
  br i1 %253, label %254, label %255

254:                                              ; preds = %249
  store i32 16777215, ptr %9, align 4
  br label %256

255:                                              ; preds = %249
  store i32 0, ptr %9, align 4
  br label %256

256:                                              ; preds = %255, %254
  %257 = load i32, ptr %4, align 4
  %258 = load i32, ptr %5, align 4
  %259 = load i32, ptr %9, align 4
  call void @simSetPixel(i32 %257, i32 %258, i32 %259)
  %260 = load i32, ptr %4, align 4
  %261 = add i32 %260, 1
  store i32 %261, ptr %4, align 4
  %262 = load i32, ptr %5, align 4
  %263 = add i32 %262, 1
  store i32 %263, ptr %5, align 4
  %264 = load i32, ptr %3, align 4
  %265 = add i32 %264, 1
  store i32 %265, ptr %3, align 4
  call void @simFlush()
  br label %10

266:                                              ; preds = %386, %14
  %267 = load i32, ptr %5, align 4
  %268 = load i32, ptr %2, align 4
  %269 = icmp slt i32 %267, %268
  br i1 %269, label %270, label %271

270:                                              ; preds = %266
  store i32 0, ptr %4, align 4
  br label %275

271:                                              ; preds = %266
  %272 = load i32, ptr %5, align 4
  %273 = load i32, ptr %2, align 4
  %274 = icmp slt i32 %272, %273
  store i32 0, ptr %4, align 4
  br label %394

275:                                              ; preds = %339, %270
  %276 = load i32, ptr %4, align 4
  %277 = load i32, ptr %1, align 4
  %278 = icmp slt i32 %276, %277
  br i1 %278, label %279, label %287

279:                                              ; preds = %275
  %280 = load i32, ptr %5, align 4
  %281 = load i32, ptr %3, align 4
  %282 = add i32 %280, %281
  %283 = load i32, ptr %4, align 4
  %284 = load i32, ptr %3, align 4
  %285 = add i32 %283, %284
  %286 = xor i32 %282, %285
  store i32 %286, ptr %6, align 4
  store i32 1, ptr %7, align 4
  store i32 2, ptr %8, align 4
  br label %298

287:                                              ; preds = %275
  %288 = load i32, ptr %4, align 4
  %289 = load i32, ptr %1, align 4
  %290 = icmp slt i32 %288, %289
  %291 = load i32, ptr %5, align 4
  %292 = load i32, ptr %3, align 4
  %293 = add i32 %291, %292
  %294 = load i32, ptr %4, align 4
  %295 = load i32, ptr %3, align 4
  %296 = add i32 %294, %295
  %297 = xor i32 %293, %296
  store i32 %297, ptr %6, align 4
  store i32 1, ptr %7, align 4
  store i32 2, ptr %8, align 4
  br label %345

298:                                              ; preds = %327, %279
  %299 = load i32, ptr %7, align 4
  %300 = icmp ne i32 %299, 0
  %301 = load i32, ptr %8, align 4
  %302 = load i32, ptr %8, align 4
  %303 = mul i32 %301, %302
  %304 = load i32, ptr %6, align 4
  %305 = icmp sle i32 %303, %304
  %306 = and i1 %300, %305
  br i1 %306, label %307, label %312

307:                                              ; preds = %298
  %308 = load i32, ptr %6, align 4
  %309 = load i32, ptr %8, align 4
  %310 = srem i32 %308, %309
  %311 = icmp eq i32 %310, 0
  br i1 %311, label %325, label %326

312:                                              ; preds = %298
  %313 = load i32, ptr %7, align 4
  %314 = icmp ne i32 %313, 0
  %315 = load i32, ptr %8, align 4
  %316 = load i32, ptr %8, align 4
  %317 = mul i32 %315, %316
  %318 = load i32, ptr %6, align 4
  %319 = icmp sle i32 %317, %318
  %320 = and i1 %314, %319
  %321 = load i32, ptr %6, align 4
  %322 = load i32, ptr %8, align 4
  %323 = srem i32 %321, %322
  %324 = icmp eq i32 %323, 0
  br i1 %324, label %330, label %331

325:                                              ; preds = %307
  store i32 0, ptr %7, align 4
  br label %327

326:                                              ; preds = %307
  br label %327

327:                                              ; preds = %326, %325
  %328 = load i32, ptr %8, align 4
  %329 = add i32 %328, 1
  store i32 %329, ptr %8, align 4
  br label %298

330:                                              ; preds = %312
  store i32 0, ptr %7, align 4
  br label %332

331:                                              ; preds = %312
  br label %332

332:                                              ; preds = %331, %330
  %333 = load i32, ptr %8, align 4
  %334 = add i32 %333, 1
  store i32 %334, ptr %8, align 4
  %335 = load i32, ptr %7, align 4
  %336 = icmp ne i32 %335, 0
  br i1 %336, label %337, label %338

337:                                              ; preds = %332
  store i32 16777215, ptr %9, align 4
  br label %339

338:                                              ; preds = %332
  store i32 0, ptr %9, align 4
  br label %339

339:                                              ; preds = %338, %337
  %340 = load i32, ptr %4, align 4
  %341 = load i32, ptr %5, align 4
  %342 = load i32, ptr %9, align 4
  call void @simSetPixel(i32 %340, i32 %341, i32 %342)
  %343 = load i32, ptr %4, align 4
  %344 = add i32 %343, 1
  store i32 %344, ptr %4, align 4
  br label %275

345:                                              ; preds = %374, %287
  %346 = load i32, ptr %7, align 4
  %347 = icmp ne i32 %346, 0
  %348 = load i32, ptr %8, align 4
  %349 = load i32, ptr %8, align 4
  %350 = mul i32 %348, %349
  %351 = load i32, ptr %6, align 4
  %352 = icmp sle i32 %350, %351
  %353 = and i1 %347, %352
  br i1 %353, label %354, label %359

354:                                              ; preds = %345
  %355 = load i32, ptr %6, align 4
  %356 = load i32, ptr %8, align 4
  %357 = srem i32 %355, %356
  %358 = icmp eq i32 %357, 0
  br i1 %358, label %372, label %373

359:                                              ; preds = %345
  %360 = load i32, ptr %7, align 4
  %361 = icmp ne i32 %360, 0
  %362 = load i32, ptr %8, align 4
  %363 = load i32, ptr %8, align 4
  %364 = mul i32 %362, %363
  %365 = load i32, ptr %6, align 4
  %366 = icmp sle i32 %364, %365
  %367 = and i1 %361, %366
  %368 = load i32, ptr %6, align 4
  %369 = load i32, ptr %8, align 4
  %370 = srem i32 %368, %369
  %371 = icmp eq i32 %370, 0
  br i1 %371, label %377, label %378

372:                                              ; preds = %354
  store i32 0, ptr %7, align 4
  br label %374

373:                                              ; preds = %354
  br label %374

374:                                              ; preds = %373, %372
  %375 = load i32, ptr %8, align 4
  %376 = add i32 %375, 1
  store i32 %376, ptr %8, align 4
  br label %345

377:                                              ; preds = %359
  store i32 0, ptr %7, align 4
  br label %379

378:                                              ; preds = %359
  br label %379

379:                                              ; preds = %378, %377
  %380 = load i32, ptr %8, align 4
  %381 = add i32 %380, 1
  store i32 %381, ptr %8, align 4
  %382 = load i32, ptr %7, align 4
  %383 = icmp ne i32 %382, 0
  br i1 %383, label %384, label %385

384:                                              ; preds = %379
  store i32 16777215, ptr %9, align 4
  br label %386

385:                                              ; preds = %379
  store i32 0, ptr %9, align 4
  br label %386

386:                                              ; preds = %385, %384
  %387 = load i32, ptr %4, align 4
  %388 = load i32, ptr %5, align 4
  %389 = load i32, ptr %9, align 4
  call void @simSetPixel(i32 %387, i32 %388, i32 %389)
  %390 = load i32, ptr %4, align 4
  %391 = add i32 %390, 1
  store i32 %391, ptr %4, align 4
  %392 = load i32, ptr %5, align 4
  %393 = add i32 %392, 1
  store i32 %393, ptr %5, align 4
  br label %266

394:                                              ; preds = %458, %271
  %395 = load i32, ptr %4, align 4
  %396 = load i32, ptr %1, align 4
  %397 = icmp slt i32 %395, %396
  br i1 %397, label %398, label %406

398:                                              ; preds = %394
  %399 = load i32, ptr %5, align 4
  %400 = load i32, ptr %3, align 4
  %401 = add i32 %399, %400
  %402 = load i32, ptr %4, align 4
  %403 = load i32, ptr %3, align 4
  %404 = add i32 %402, %403
  %405 = xor i32 %401, %404
  store i32 %405, ptr %6, align 4
  store i32 1, ptr %7, align 4
  store i32 2, ptr %8, align 4
  br label %417

406:                                              ; preds = %394
  %407 = load i32, ptr %4, align 4
  %408 = load i32, ptr %1, align 4
  %409 = icmp slt i32 %407, %408
  %410 = load i32, ptr %5, align 4
  %411 = load i32, ptr %3, align 4
  %412 = add i32 %410, %411
  %413 = load i32, ptr %4, align 4
  %414 = load i32, ptr %3, align 4
  %415 = add i32 %413, %414
  %416 = xor i32 %412, %415
  store i32 %416, ptr %6, align 4
  store i32 1, ptr %7, align 4
  store i32 2, ptr %8, align 4
  br label %464

417:                                              ; preds = %446, %398
  %418 = load i32, ptr %7, align 4
  %419 = icmp ne i32 %418, 0
  %420 = load i32, ptr %8, align 4
  %421 = load i32, ptr %8, align 4
  %422 = mul i32 %420, %421
  %423 = load i32, ptr %6, align 4
  %424 = icmp sle i32 %422, %423
  %425 = and i1 %419, %424
  br i1 %425, label %426, label %431

426:                                              ; preds = %417
  %427 = load i32, ptr %6, align 4
  %428 = load i32, ptr %8, align 4
  %429 = srem i32 %427, %428
  %430 = icmp eq i32 %429, 0
  br i1 %430, label %444, label %445

431:                                              ; preds = %417
  %432 = load i32, ptr %7, align 4
  %433 = icmp ne i32 %432, 0
  %434 = load i32, ptr %8, align 4
  %435 = load i32, ptr %8, align 4
  %436 = mul i32 %434, %435
  %437 = load i32, ptr %6, align 4
  %438 = icmp sle i32 %436, %437
  %439 = and i1 %433, %438
  %440 = load i32, ptr %6, align 4
  %441 = load i32, ptr %8, align 4
  %442 = srem i32 %440, %441
  %443 = icmp eq i32 %442, 0
  br i1 %443, label %449, label %450

444:                                              ; preds = %426
  store i32 0, ptr %7, align 4
  br label %446

445:                                              ; preds = %426
  br label %446

446:                                              ; preds = %445, %444
  %447 = load i32, ptr %8, align 4
  %448 = add i32 %447, 1
  store i32 %448, ptr %8, align 4
  br label %417

449:                                              ; preds = %431
  store i32 0, ptr %7, align 4
  br label %451

450:                                              ; preds = %431
  br label %451

451:                                              ; preds = %450, %449
  %452 = load i32, ptr %8, align 4
  %453 = add i32 %452, 1
  store i32 %453, ptr %8, align 4
  %454 = load i32, ptr %7, align 4
  %455 = icmp ne i32 %454, 0
  br i1 %455, label %456, label %457

456:                                              ; preds = %451
  store i32 16777215, ptr %9, align 4
  br label %458

457:                                              ; preds = %451
  store i32 0, ptr %9, align 4
  br label %458

458:                                              ; preds = %457, %456
  %459 = load i32, ptr %4, align 4
  %460 = load i32, ptr %5, align 4
  %461 = load i32, ptr %9, align 4
  call void @simSetPixel(i32 %459, i32 %460, i32 %461)
  %462 = load i32, ptr %4, align 4
  %463 = add i32 %462, 1
  store i32 %463, ptr %4, align 4
  br label %394

464:                                              ; preds = %493, %406
  %465 = load i32, ptr %7, align 4
  %466 = icmp ne i32 %465, 0
  %467 = load i32, ptr %8, align 4
  %468 = load i32, ptr %8, align 4
  %469 = mul i32 %467, %468
  %470 = load i32, ptr %6, align 4
  %471 = icmp sle i32 %469, %470
  %472 = and i1 %466, %471
  br i1 %472, label %473, label %478

473:                                              ; preds = %464
  %474 = load i32, ptr %6, align 4
  %475 = load i32, ptr %8, align 4
  %476 = srem i32 %474, %475
  %477 = icmp eq i32 %476, 0
  br i1 %477, label %491, label %492

478:                                              ; preds = %464
  %479 = load i32, ptr %7, align 4
  %480 = icmp ne i32 %479, 0
  %481 = load i32, ptr %8, align 4
  %482 = load i32, ptr %8, align 4
  %483 = mul i32 %481, %482
  %484 = load i32, ptr %6, align 4
  %485 = icmp sle i32 %483, %484
  %486 = and i1 %480, %485
  %487 = load i32, ptr %6, align 4
  %488 = load i32, ptr %8, align 4
  %489 = srem i32 %487, %488
  %490 = icmp eq i32 %489, 0
  br i1 %490, label %496, label %497

491:                                              ; preds = %473
  store i32 0, ptr %7, align 4
  br label %493

492:                                              ; preds = %473
  br label %493

493:                                              ; preds = %492, %491
  %494 = load i32, ptr %8, align 4
  %495 = add i32 %494, 1
  store i32 %495, ptr %8, align 4
  br label %464

496:                                              ; preds = %478
  store i32 0, ptr %7, align 4
  br label %498

497:                                              ; preds = %478
  br label %498

498:                                              ; preds = %497, %496
  %499 = load i32, ptr %8, align 4
  %500 = add i32 %499, 1
  store i32 %500, ptr %8, align 4
  %501 = load i32, ptr %7, align 4
  %502 = icmp ne i32 %501, 0
  br i1 %502, label %503, label %504

503:                                              ; preds = %498
  store i32 16777215, ptr %9, align 4
  br label %505

504:                                              ; preds = %498
  store i32 0, ptr %9, align 4
  br label %505

505:                                              ; preds = %504, %503
  %506 = load i32, ptr %4, align 4
  %507 = load i32, ptr %5, align 4
  %508 = load i32, ptr %9, align 4
  call void @simSetPixel(i32 %506, i32 %507, i32 %508)
  %509 = load i32, ptr %4, align 4
  %510 = add i32 %509, 1
  store i32 %510, ptr %4, align 4
  %511 = load i32, ptr %5, align 4
  %512 = add i32 %511, 1
  store i32 %512, ptr %5, align 4
  %513 = load i32, ptr %3, align 4
  %514 = add i32 %513, 1
  store i32 %514, ptr %3, align 4
  call void @simFlush()
  call void @simEnd()
  ret i32 0
}

declare void @simBegin()

declare void @simFlush()

declare void @simEnd()

declare i32 @simShouldContinue()

declare void @simSetPixel(i32, i32, i32)

declare void @simDebug(i32)

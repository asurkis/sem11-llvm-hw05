#pragma once

#include "hw01/sim.h"

#include <istream>
#include <sstream>
#include <stdexcept>
#include <string>
#include <unordered_map>

#include <llvm/IR/Constants.h>
#include <llvm/IR/GlobalValue.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/InstrTypes.h>
#include <llvm/IR/Instructions.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Metadata.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Value.h>

using namespace llvm;

inline LLVMContext context;
inline Module *module = new Module("main.c", context);
inline IRBuilder<> builder(context);

// Type *charTy = builder.getInt8Ty();
inline Type *boolTy = builder.getInt1Ty();
inline Type *intTy = builder.getInt32Ty();
inline Type *longTy = builder.getInt64Ty();
inline Type *ptrTy = builder.getPtrTy();
inline Type *voidTy = builder.getVoidTy();

inline Constant *getInt(int32_t val) { return ConstantInt::get(intTy, val, true); }
inline Constant *getLong(int64_t val) { return ConstantInt::get(longTy, val, true); }
inline Constant *getBool(int val) { return ConstantInt::get(boolTy, val); }

inline constexpr size_t N_REGS = 32;
inline Type *varRegsTy = ArrayType::get(intTy, N_REGS);
inline GlobalVariable *varRegs = new GlobalVariable(
    *module, varRegsTy, false, GlobalVariable::PrivateLinkage, ConstantAggregateZero::get(intTy), "REG");

inline Constant *getReg(int reg) { return ConstantExpr::getInBoundsGetElementPtr(intTy, varRegs, getInt(reg)); }

inline Constant *getReg(const char *regName) {
    if (regName[0] != '@')
        throw std::runtime_error("Register name should start with @");
    int regX = std::atoi(regName + 1);
    return getReg(regX);
}

inline FunctionType *fnMainTy = FunctionType::get(intTy, false);
inline Function *fnMain = Function::Create(fnMainTy, Function::ExternalLinkage, "main", module);

inline FunctionType *voidFnTy = FunctionType::get(voidTy, false);
inline FunctionCallee fnSimBegin = module->getOrInsertFunction("simBegin", voidFnTy);
inline FunctionCallee fnSimFlush = module->getOrInsertFunction("simFlush", voidFnTy);
inline FunctionCallee fnSimEnd = module->getOrInsertFunction("simEnd", voidFnTy);

inline FunctionType *fnSimShouldContinueTy = FunctionType::get(intTy, false);
inline FunctionCallee fnSimShouldContinue = module->getOrInsertFunction("simShouldContinue", fnSimShouldContinueTy);

inline FunctionType *fnSimSetPixelTy = FunctionType::get(voidTy, {intTy, intTy, intTy}, false);
inline FunctionCallee fnSimSetPixel = module->getOrInsertFunction("simSetPixel", fnSimSetPixelTy);

inline FunctionType *fnSimDebugTy = FunctionType::get(voidTy, {intTy}, false);
inline FunctionCallee fnSimDebug = module->getOrInsertFunction("simDebug", fnSimDebugTy);

inline BasicBlock *getOrMakeBB(std::unordered_map<std::string, BasicBlock *> &bbs, const std::string &name) {
    auto iter = bbs.find(name);
    if (iter != bbs.end())
        return iter->second;
    return bbs[name] = BasicBlock::Create(context, name, fnMain);
}

inline void defineMain(std::istream &is) {
    module->setTargetTriple("x86_64-pc-linux-gnu");

    std::unordered_map<std::string, BasicBlock *> bbs;
    BasicBlock *entry = BasicBlock::Create(context, "", fnMain);
    builder.SetInsertPoint(entry);

    std::string line;
    while (std::getline(is, line)) {
        std::istringstream iss(line);
        std::string kind;
        iss >> kind;

#define MY_BINOP(op)                                                                                                   \
    std::string regDstName, regSrc1Name, regSrc2Name;                                                                  \
    iss >> regDstName >> regSrc1Name >> regSrc2Name;                                                                   \
    Constant *regDst = getReg(regDstName.data());                                                                      \
    Constant *regSrc1 = getReg(regSrc1Name.data());                                                                    \
    Constant *regSrc2 = getReg(regSrc2Name.data());                                                                    \
    LoadInst *loaded1 = builder.CreateLoad(intTy, regSrc1);                                                            \
    LoadInst *loaded2 = builder.CreateLoad(intTy, regSrc2);                                                            \
    Value *calced = builder.Create##op(loaded1, loaded2);                                                              \
    builder.CreateStore(calced, regDst);

        if (kind == "bb") { // Start basic block
            std::string name;
            iss >> name;
            BasicBlock *bb = getOrMakeBB(bbs, name);
            builder.SetInsertPoint(bb);
        } else if (kind == "ret") { // Return from main
            builder.CreateRet(getInt(0));
        } else if (kind == "j") { // Jump
            std::string name;
            iss >> name;
            BasicBlock *bb = getOrMakeBB(bbs, name);
            builder.CreateBr(bb);
        } else if (kind == "be") { // Branch if equals
            std::string reg1Name, reg2Name, bbThenName, bbElseName;
            iss >> reg1Name >> reg2Name >> bbThenName >> bbElseName;
            Constant *reg1 = getReg(reg1Name.data());
            Constant *reg2 = getReg(reg2Name.data());
            Value *loaded1 = builder.CreateLoad(intTy, reg1);
            Value *loaded2 = builder.CreateLoad(intTy, reg2);
            Value *cmpRes = builder.CreateICmpEQ(loaded1, loaded2);
            BasicBlock *bbThen = getOrMakeBB(bbs, bbThenName);
            BasicBlock *bbElse = getOrMakeBB(bbs, bbElseName);
            builder.CreateCondBr(cmpRes, bbThen, bbElse);
        } else if (kind == "blt") { // Branch if less
            std::string reg1Name, reg2Name, bbThenName, bbElseName;
            iss >> reg1Name >> reg2Name >> bbThenName >> bbElseName;
            Constant *reg1 = getReg(reg1Name.data());
            Constant *reg2 = getReg(reg2Name.data());
            Value *loaded1 = builder.CreateLoad(intTy, reg1);
            Value *loaded2 = builder.CreateLoad(intTy, reg2);
            Value *cmpRes = builder.CreateICmpSLT(loaded1, loaded2);
            BasicBlock *bbThen = getOrMakeBB(bbs, bbThenName);
            BasicBlock *bbElse = getOrMakeBB(bbs, bbElseName);
            builder.CreateCondBr(cmpRes, bbThen, bbElse);
        } else if (kind == "li") {
            std::string regDstName;
            int val = 0;
            iss >> regDstName >> val;
            Constant *regDst = getReg(regDstName.data());
            builder.CreateStore(getInt(val), regDst);
        } else if (kind == "addi") { // @dst := @src + val
            std::string regDstName, regSrcName;
            int val = 0;
            iss >> regDstName >> regSrcName >> val;
            Constant *regDst = getReg(regDstName.data());
            Constant *regSrc = getReg(regSrcName.data());
            LoadInst *loaded = builder.CreateLoad(intTy, regSrc);
            Value *calced = builder.CreateAdd(loaded, getInt(val));
            builder.CreateStore(calced, regDst);
        } else if (kind == "add") { // @dst := @src1 + @src2
            MY_BINOP(Add)
        } else if (kind == "xor") { // @dst := @src1 ^ @src2
            MY_BINOP(Xor)
        } else if (kind == "mul") { // @dst := @src1 * @src2
            MY_BINOP(Mul)
        } else if (kind == "rem") { // @dst := @src1 % @src2
            MY_BINOP(SRem)
        } else if (kind == "simBegin") {
            builder.CreateCall(fnSimBegin);
        } else if (kind == "simFlush") {
            builder.CreateCall(fnSimFlush);
        } else if (kind == "simEnd") {
            builder.CreateCall(fnSimEnd);
        } else if (kind == "simShouldContinue") {
            std::string regName;
            iss >> regName;
            Constant *reg = getReg(regName.data());
            CallInst *shouldContinue = builder.CreateCall(fnSimShouldContinue);
            builder.CreateStore(shouldContinue, reg);
        } else if (kind == "simSetPixel") {
            std::string reg1Name, reg2Name, reg3Name;
            iss >> reg1Name >> reg2Name >> reg3Name;
            Constant *reg1 = getReg(reg1Name.data());
            Constant *reg2 = getReg(reg2Name.data());
            Constant *reg3 = getReg(reg3Name.data());
            LoadInst *loaded1 = builder.CreateLoad(intTy, reg1);
            LoadInst *loaded2 = builder.CreateLoad(intTy, reg2);
            LoadInst *loaded3 = builder.CreateLoad(intTy, reg3);
            builder.CreateCall(fnSimSetPixel, {loaded1, loaded2, loaded3});
        } else if (kind == "simDebug") {
            std::string regName;
            iss >> regName;
            Constant *reg = getReg(regName.data());
            LoadInst *loaded = builder.CreateLoad(intTy, reg);
            builder.CreateCall(fnSimDebug, {loaded});
        }
    }
}

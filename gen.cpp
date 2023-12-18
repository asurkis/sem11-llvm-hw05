#include "hw01/sim.h"

#include "MyLanguageBaseVisitor.h"
#include "MyLanguageLexer.h"
#include "MyLanguageParser.h"

#include <any>
#include <iostream>
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

#include "ANTLRInputStream.h"
#include "CommonTokenStream.h"

using namespace llvm;

LLVMContext context;
Module *module = new Module("main.c", context);
IRBuilder<> builder(context);

// Type *charTy = builder.getInt8Ty();
Type *boolTy = builder.getInt1Ty();
Type *intTy = builder.getInt32Ty();
Type *longTy = builder.getInt64Ty();
Type *ptrTy = builder.getPtrTy();
Type *voidTy = builder.getVoidTy();

Constant *getInt(int32_t val) { return ConstantInt::get(intTy, val, true); }
Constant *getLong(int64_t val) { return ConstantInt::get(longTy, val, true); }
Constant *getBool(int val) { return ConstantInt::get(boolTy, val); }

constexpr size_t N_REGS = 32;
Type *varRegsTy = ArrayType::get(intTy, N_REGS);
GlobalVariable *varRegs = new GlobalVariable(
    *module, varRegsTy, false, GlobalVariable::PrivateLinkage, ConstantAggregateZero::get(intTy), "REG");

Constant *getReg(int reg) { return ConstantExpr::getInBoundsGetElementPtr(intTy, varRegs, getInt(reg)); }

Constant *getReg(const char *regName) {
    if (regName[0] != '@')
        throw std::runtime_error("Register name should start with @");
    int regX = std::atoi(regName + 1);
    return getReg(regX);
}

FunctionType *fnMainTy = FunctionType::get(intTy, false);
Function *fnMain = Function::Create(fnMainTy, Function::ExternalLinkage, "main", module);

FunctionType *voidFnTy = FunctionType::get(voidTy, false);
FunctionCallee fnSimBegin = module->getOrInsertFunction("simBegin", voidFnTy);
FunctionCallee fnSimFlush = module->getOrInsertFunction("simFlush", voidFnTy);
FunctionCallee fnSimEnd = module->getOrInsertFunction("simEnd", voidFnTy);

FunctionType *fnSimShouldContinueTy = FunctionType::get(intTy, false);
FunctionCallee fnSimShouldContinue = module->getOrInsertFunction("simShouldContinue", fnSimShouldContinueTy);

FunctionType *fnSimSetPixelTy = FunctionType::get(voidTy, {intTy, intTy, intTy}, false);
FunctionCallee fnSimSetPixel = module->getOrInsertFunction("simSetPixel", fnSimSetPixelTy);

FunctionType *fnSimDebugTy = FunctionType::get(voidTy, {intTy}, false);
FunctionCallee fnSimDebug = module->getOrInsertFunction("simDebug", fnSimDebugTy);

BasicBlock *getOrMakeBB(std::unordered_map<std::string, BasicBlock *> &bbs, const std::string &name) {
    auto iter = bbs.find(name);
    if (iter != bbs.end())
        return iter->second;
    return bbs[name] = BasicBlock::Create(context, name, fnMain);
}

void defineMain(std::istream &is) {
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

class MyVisitor : public MyLanguageBaseVisitor {
    std::unordered_map<std::string, AllocaInst *> vars;

  public:
    std::any visitProgram(MyLanguageParser::ProgramContext *ctx) override {
        module->setTargetTriple("x86_64-pc-linux-gnu");
        BasicBlock *entry = BasicBlock::Create(context, "", fnMain);
        builder.SetInsertPoint(entry);
        return visitChildren(ctx);
    }

    std::any visitDeclVar(MyLanguageParser::DeclVarContext *ctx) override {
        std::string name = ctx->IDENT()->getText();
        AllocaInst *pos = builder.CreateAlloca(intTy);
        if (vars.find(name) != vars.end())
            throw std::runtime_error("Redefinition of var " + name);
        vars[name] = pos;
        return {};
    }

    std::any visitStmtAssn(MyLanguageParser::StmtAssnContext *ctx) override {
        std::string name = ctx->IDENT()->getText();
        auto found = vars.find(name);
        if (found == vars.end())
            throw std::runtime_error("Assignment to undeclared variable " + name);
        AllocaInst *ptr = found->second;
        Value *val = std::any_cast<Value *>(visit(ctx->children[2]));
        builder.CreateStore(val, ptr);
        return {};
    }

    std::any visitExprVar(MyLanguageParser::ExprVarContext *ctx) override {
        std::string name = ctx->IDENT()->getText();
        auto found = vars.find(name);
        if (found == vars.end())
            throw std::runtime_error("Assignment to undeclared variable " + name);
        AllocaInst *ptr = found->second;
        Value *val = builder.CreateLoad(intTy, ptr);
        return val;
    }

    std::any visitExprConst(MyLanguageParser::ExprConstContext *ctx) override {
        return static_cast<Value *>(getInt(std::stoi(ctx->CONST()->getText())));
    }

    std::any visitExprSimShouldContinue(MyLanguageParser::ExprSimShouldContinueContext *ctx) override {
        return static_cast<Value *>(builder.CreateCall(fnSimShouldContinue));
    }

    std::any visitExprAdd(MyLanguageParser::ExprAddContext *ctx) override {
        Value *lhs = std::any_cast<Value *>(visit(ctx->children[0]));
        Value *rhs = std::any_cast<Value *>(visit(ctx->children[2]));
        Value *res = builder.CreateAdd(lhs, rhs);
        return res;
    }

    virtual std::any visitStmtWhile(MyLanguageParser::StmtWhileContext *ctx) override {
        BasicBlock *condBB = BasicBlock::Create(context, "", fnMain);
        BasicBlock *bodyBB = BasicBlock::Create(context, "", fnMain);
        BasicBlock *exitBB = BasicBlock::Create(context, "", fnMain);
        builder.CreateBr(condBB);
        builder.SetInsertPoint(condBB);
        Value *val = std::any_cast<Value *>(visit(ctx->children[1]));
        builder.CreateCondBr(val, bodyBB, exitBB);
        builder.SetInsertPoint(bodyBB);
        visit(ctx->children[2]);
        builder.CreateBr(condBB);
        builder.SetInsertPoint(exitBB);
        return visitChildren(ctx);
    }

    virtual std::any visitStmtFor(MyLanguageParser::StmtForContext *ctx) override { return visitChildren(ctx); }

    virtual std::any visitStmtSimSetPixel(MyLanguageParser::StmtSimSetPixelContext *ctx) override {
        return visitChildren(ctx);
    }

    virtual std::any visitStmtSimFlush(MyLanguageParser::StmtSimFlushContext *ctx) override {
        return visitChildren(ctx);
    }

    virtual std::any visitIfStmt(MyLanguageParser::IfStmtContext *ctx) override { return visitChildren(ctx); }
};

int main() {
    antlr4::ANTLRInputStream inputStream(std::cin);
    MyLanguageLexer lexer(&inputStream);
    antlr4::CommonTokenStream tokenStream(&lexer);
    MyLanguageParser parser(&tokenStream);

    MyLanguageParser::ProgramContext *tree = parser.program();

    MyVisitor visitor;
    visitor.visitProgram(tree);

    outs() << *module;
    return 0;
}

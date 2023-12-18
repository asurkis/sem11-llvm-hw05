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

class MyVisitor : public MyLanguageBaseVisitor {
    std::unordered_map<std::string, AllocaInst *> vars;

  public:
    std::any visitProgram(MyLanguageParser::ProgramContext *ctx) override {
        module->setTargetTriple("x86_64-pc-linux-gnu");
        BasicBlock *entry = BasicBlock::Create(context, "", fnMain);
        builder.SetInsertPoint(entry);
        visit(ctx->children[0]);
        builder.CreateCall(fnSimBegin);
        visit(ctx->children[1]);
        builder.CreateCall(fnSimEnd);
        builder.CreateRet(getInt(0));
        return {};
    }

    std::any visitDeclVar(MyLanguageParser::DeclVarContext *ctx) override {
        std::string name = ctx->IDENT()->getText();
        AllocaInst *pos = builder.CreateAlloca(intTy);
        if (vars.find(name) != vars.end())
            throw std::runtime_error("Redefinition of var " + name);
        vars[name] = pos;
        return {};
    }

    std::any visitStmtSimSetPixel(MyLanguageParser::StmtSimSetPixelContext *ctx) override {
        Value *col = std::any_cast<Value *>(visit(ctx->children[3]));
        Value *row = std::any_cast<Value *>(visit(ctx->children[5]));
        Value *color = std::any_cast<Value *>(visit(ctx->children[7]));
        builder.CreateCall(fnSimSetPixel, {col, row, color});
        return {};
    }

    std::any visitStmtSimFlush(MyLanguageParser::StmtSimFlushContext *ctx) override {
        builder.CreateCall(fnSimFlush);
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

    std::any visitExprBoolParens(MyLanguageParser::ExprBoolParensContext *ctx) override {
        return visit(ctx->children[1]);
    }

    std::any visitExprIntParens(MyLanguageParser::ExprIntParensContext *ctx) override {
        return visit(ctx->children[1]);
    }

    std::any visitExprConst(MyLanguageParser::ExprConstContext *ctx) override {
        return static_cast<Value *>(getInt(std::stoi(ctx->CONST()->getText())));
    }

    std::any visitExprSimShouldContinue(MyLanguageParser::ExprSimShouldContinueContext *ctx) override {
        Value *val32 = builder.CreateCall(fnSimShouldContinue);
        Value *val1 = builder.CreateICmpNE(val32, getInt(0));
        return val1;
    }

    ////////////////////////////////////////////////////////////////
    // Бинарные операции, ОЧЕНЬ много копипасты

    std::any visitExprBoolOr(MyLanguageParser::ExprBoolOrContext *ctx) override {
        Value *lhs = std::any_cast<Value *>(visit(ctx->children[0]));
        Value *rhs = std::any_cast<Value *>(visit(ctx->children[2]));
        Value *res = builder.CreateOr(lhs, rhs);
        return res;
    }

    std::any visitExprBoolAnd(MyLanguageParser::ExprBoolAndContext *ctx) override {
        Value *lhs = std::any_cast<Value *>(visit(ctx->children[0]));
        Value *rhs = std::any_cast<Value *>(visit(ctx->children[2]));
        Value *res = builder.CreateAnd(lhs, rhs);
        return res;
    }

    std::any visitExprEQ(MyLanguageParser::ExprEQContext *ctx) override {
        Value *lhs = std::any_cast<Value *>(visit(ctx->children[0]));
        Value *rhs = std::any_cast<Value *>(visit(ctx->children[2]));
        Value *res = builder.CreateICmpEQ(lhs, rhs);
        return res;
    }

    std::any visitExprNE(MyLanguageParser::ExprNEContext *ctx) override {
        Value *lhs = std::any_cast<Value *>(visit(ctx->children[0]));
        Value *rhs = std::any_cast<Value *>(visit(ctx->children[2]));
        Value *res = builder.CreateICmpNE(lhs, rhs);
        return res;
    }

    std::any visitExprLT(MyLanguageParser::ExprLTContext *ctx) override {
        Value *lhs = std::any_cast<Value *>(visit(ctx->children[0]));
        Value *rhs = std::any_cast<Value *>(visit(ctx->children[2]));
        Value *res = builder.CreateICmpSLT(lhs, rhs);
        return res;
    }

    std::any visitExprGT(MyLanguageParser::ExprGTContext *ctx) override {
        Value *lhs = std::any_cast<Value *>(visit(ctx->children[0]));
        Value *rhs = std::any_cast<Value *>(visit(ctx->children[2]));
        Value *res = builder.CreateICmpSGT(lhs, rhs);
        return res;
    }

    std::any visitExprLE(MyLanguageParser::ExprLEContext *ctx) override {
        Value *lhs = std::any_cast<Value *>(visit(ctx->children[0]));
        Value *rhs = std::any_cast<Value *>(visit(ctx->children[2]));
        Value *res = builder.CreateICmpSLE(lhs, rhs);
        return res;
    }

    std::any visitExprGE(MyLanguageParser::ExprGEContext *ctx) override {
        Value *lhs = std::any_cast<Value *>(visit(ctx->children[0]));
        Value *rhs = std::any_cast<Value *>(visit(ctx->children[2]));
        Value *res = builder.CreateICmpSGE(lhs, rhs);
        return res;
    }

    std::any visitExprBitXor(MyLanguageParser::ExprBitXorContext *ctx) override {
        Value *lhs = std::any_cast<Value *>(visit(ctx->children[0]));
        Value *rhs = std::any_cast<Value *>(visit(ctx->children[2]));
        Value *res = builder.CreateXor(lhs, rhs);
        return res;
    }

    std::any visitExprAdd(MyLanguageParser::ExprAddContext *ctx) override {
        Value *lhs = std::any_cast<Value *>(visit(ctx->children[0]));
        Value *rhs = std::any_cast<Value *>(visit(ctx->children[2]));
        Value *res = builder.CreateAdd(lhs, rhs);
        return res;
    }

    std::any visitExprMul(MyLanguageParser::ExprMulContext *ctx) override {
        Value *lhs = std::any_cast<Value *>(visit(ctx->children[0]));
        Value *rhs = std::any_cast<Value *>(visit(ctx->children[2]));
        Value *res = builder.CreateMul(lhs, rhs);
        return res;
    }

    std::any visitExprMod(MyLanguageParser::ExprModContext *ctx) override {
        Value *lhs = std::any_cast<Value *>(visit(ctx->children[0]));
        Value *rhs = std::any_cast<Value *>(visit(ctx->children[2]));
        Value *res = builder.CreateSRem(lhs, rhs);
        return res;
    }

    ////////////////////////////////////////////////////////////////

    std::any visitStmtWhile(MyLanguageParser::StmtWhileContext *ctx) override {
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

    std::any visitIfStmt(MyLanguageParser::IfStmtContext *ctx) override {
        BasicBlock *thenBB = BasicBlock::Create(context, "", fnMain);
        BasicBlock *elseBB = BasicBlock::Create(context, "", fnMain);
        BasicBlock *exitBB = BasicBlock::Create(context, "", fnMain);
        Value *val = std::any_cast<Value *>(visit(ctx->children[1]));
        builder.CreateCondBr(val, thenBB, elseBB);
        builder.SetInsertPoint(thenBB);
        visit(ctx->children[2]);
        builder.CreateBr(exitBB);
        builder.SetInsertPoint(elseBB);
        if (ctx->children.size() > 4)
            visit(ctx->children[4]);
        builder.CreateBr(exitBB);
        builder.SetInsertPoint(exitBB);
        return {};
    }
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

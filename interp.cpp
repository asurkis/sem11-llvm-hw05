#include "gen.hpp"

#include <llvm-c/Target.h>
#include <llvm/ExecutionEngine/ExecutionEngine.h>
#include <llvm/ExecutionEngine/GenericValue.h>
#include <memory>

int main() {
    defineMain();

    std::unique_ptr<Module> ptr(module);
    ExecutionEngine *ee = EngineBuilder(std::move(ptr)).create();
    ee->addGlobalMapping("simBegin", reinterpret_cast<uint64_t>(simBegin));
    ee->addGlobalMapping("simFlush", reinterpret_cast<uint64_t>(simFlush));
    ee->addGlobalMapping("simEnd", reinterpret_cast<uint64_t>(simEnd));
    ee->addGlobalMapping("simShouldContinue", reinterpret_cast<uint64_t>(simShouldContinue));
    ee->addGlobalMapping("simSetPixel", reinterpret_cast<uint64_t>(simSetPixel));
    ee->finalizeObject();

    ArrayRef<GenericValue> noargs;
    ee->runFunction(fnMain, noargs);
    return 0;
}

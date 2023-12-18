#include "gen.hpp"

#include <iostream>

int main() {
    defineMain(std::cin);
    outs() << *module;
    return 0;
}

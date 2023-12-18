CC=clang
CXX=clang++

game.exe: game.ll
	$(CC) -o game.exe game.ll -lm cmake-build/hw01/libsim.a cmake-build/hw01/third-party/SDL2/libSDL2.a

game.ll: gen
	cmake-build/gen < game.s > game.ll

gen: cmake-build
	cmake --build cmake-build

cmake-build:
	mkdir -p cmake-build
	CC=$(CC) CXX=$(CXX) cmake -S . -B cmake-build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

clean:
	rm -rf cmake-build game.ll game.exe

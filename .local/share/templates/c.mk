CC=cc
MKDIR=mkdir
RM=rm

default: 
	echo "Use 'make build' to build the program'"

prepare:
	$(MKDIR) -p bin build

build: prepare
	$(CC) -c src/main.c -o build/main.o
	$(CC) -o bin/main build/*.o

test: build
	./bin/main

clean:
	$(RM) bin build -rf

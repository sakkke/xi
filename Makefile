BUILD_DIR ?= build

.PHONY: build clean

build:
	./xibootstrap -t dir $(BUILD_DIR)

clean:
	sudo rm -rf build

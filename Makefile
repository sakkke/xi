BUILD_DIR ?= build

.PHONY: bootstrap build clean

build:
	./xibootstrap -t dir $(BUILD_DIR)

bootstrap:
	sudo xargs -a xiiso.devdeps apt-get install -y

clean:
	sudo rm -rf build

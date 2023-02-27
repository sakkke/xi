BUILD_DIR ?= build
SUITE ?= bullseye

.PHONY: bootstrap build clean

build:
	./xibootstrap --debug --suite $(SUITE) -s cwd -t dir $(BUILD_DIR)

bootstrap:
	sudo xargs -a xiiso.devdeps apt-get install -y

clean:
	sudo rm -rf build

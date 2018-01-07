# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: iron android ios iron-cross swarm evm all test clean
.PHONY: iron-linux iron-linux-386 iron-linux-amd64 iron-linux-mips64 iron-linux-mips64le
.PHONY: iron-linux-arm iron-linux-arm-5 iron-linux-arm-6 iron-linux-arm-7 iron-linux-arm64
.PHONY: iron-darwin iron-darwin-386 iron-darwin-amd64
.PHONY: iron-windows iron-windows-386 iron-windows-amd64

GOBIN = $(shell pwd)/build/bin
GO ?= latest

iron:
	build/env.sh go run build/ci.go install ./cmd/iron
	@echo "Done building."
	@echo "Run \"$(GOBIN)/iron\" to launch iron."

swarm:
	build/env.sh go run build/ci.go install ./cmd/swarm
	@echo "Done building."
	@echo "Run \"$(GOBIN)/swarm\" to launch swarm."

all:
	build/env.sh go run build/ci.go install

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/iron.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/iron.framework\" to use the library."

test: all
	build/env.sh go run build/ci.go test

clean:
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/jteeuwen/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go install ./cmd/abigen

# Cross Compilation Targets (xgo)

iron-cross: iron-linux iron-darwin iron-windows iron-android iron-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/iron-*

iron-linux: iron-linux-386 iron-linux-amd64 iron-linux-arm iron-linux-mips64 iron-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/iron-linux-*

iron-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/iron
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/iron-linux-* | grep 386

iron-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/iron
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/iron-linux-* | grep amd64

iron-linux-arm: iron-linux-arm-5 iron-linux-arm-6 iron-linux-arm-7 iron-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/iron-linux-* | grep arm

iron-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/iron
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/iron-linux-* | grep arm-5

iron-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/iron
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/iron-linux-* | grep arm-6

iron-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/iron
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/iron-linux-* | grep arm-7

iron-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/iron
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/iron-linux-* | grep arm64

iron-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/iron
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/iron-linux-* | grep mips

iron-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/iron
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/iron-linux-* | grep mipsle

iron-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/iron
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/iron-linux-* | grep mips64

iron-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/iron
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/iron-linux-* | grep mips64le

iron-darwin: iron-darwin-386 iron-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/iron-darwin-*

iron-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/iron
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/iron-darwin-* | grep 386

iron-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/iron
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/iron-darwin-* | grep amd64

iron-windows: iron-windows-386 iron-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/iron-windows-*

iron-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/iron
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/iron-windows-* | grep 386

iron-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/iron
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/iron-windows-* | grep amd64

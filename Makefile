# mygosql makefile
# v1.0.0
# Last modified: jbono @ 20190801

# Config
BINARY=mygosql
VERSION=v1.0.0
APPNAME=MYGOSQL
TARGET=all

# Build stuff
LDFLAGS=-ldflags="\
	-s \
	-w "

sources := $(wildcard *.go)

cmd = GOOS=$(1) GOARCH=$(2) go build ${LDFLAGS} -o build/$(BINARY)_${VERSION}_$(1)_$(2)$(3) $(sources)
tar = cd build && tar -cvzf $(APPNAME)_${VERSION}_$(1)_$(2).tar.gz $(BINARY)_${VERSION}_$(1)_$(2)$(3) && rm $(BINARY)_${VERSION}_$(1)_$(2)$(3)
zip = cd build && zip $(APPNAME)_${VERSION}_$(1)_$(2).zip $(BINARY)_${VERSION}_$(1)_$(2)$(3) && rm $(BINARY)_${VERSION}_$(1)_$(2)$(3)

.PHONY: all
all: release

.PHONY: deps
deps: 
	go get -u -v "github.com/go-sql-driver/mysql"
	go get -u -v "github.com/jedib0t/go-pretty/table"
	go get -u -v "github.com/BurntSushi/toml"


.PHONY: release
release: darwin linux windows

.PHONY: install
install: 
	go build -o ${BINARY}
	mv ${BINARY} $(GOPATH)/bin

.PHONY: dev
dev: darwin-dev linux-dev windows-dev

.PHONY: clean
clean:
	rm -rf build/*

##### LINUX BUILDS #####
.PHONY: linux
linux: linux_arm.tar.gz linux_arm64.tar.gz linux_386.tar.gz linux_amd64.tar.gz

.PHONY: linux-dev
linux-dev: linux_386 linux_amd64 linux_arm linux_arm64

.PHONY: linux_386
linux_386: $(sources)
	$(call cmd,linux,386,)

.PHONY: linux_386.tar.gz
linux_386.tar.gz: linux_386
	$(call tar,linux,386)

.PHONY: linux_amd64
linux_amd64: $(sources)
	$(call cmd,linux,amd64,)

.PHONY: linux_amd64.tar.gz
linux_amd64.tar.gz: linux_amd64
	$(call tar,linux,amd64)

.PHONY: linux_arm
linux_arm: $(sources)
	$(call cmd,linux,arm,)

.PHONY: linux_arm.tar.gz
linux_arm.tar.gz: linux_arm
	$(call tar,linux,arm)

.PHONY: linux_arm64
linux_arm64: $(sources)
	$(call cmd,linux,arm64,)

.PHONY: linux_arm64.tar.gz
linux_arm64.tar.gz: linux_arm64
	$(call tar,linux,arm64)

##### DARWIN (MAC) BUILDS #####
.PHONY: darwin
darwin: darwin_amd64.tar.gz

.PHONY: darwin-dev
darwin-dev: darwin_amd64

.PHONY: darwin_amd64
darwin_amd64: $(sources)
	$(call cmd,darwin,amd64,)

.PHONY: darwin_amd64.tar.gz
darwin_amd64.tar.gz: darwin_amd64
	$(call tar,darwin,amd64)

##### WINDOWS BUILDS #####
.PHONY: windows
windows: windows_386.zip windows_amd64.zip

.PHONY: windows-dev
windows-dev: windows_386 windows_amd64

.PHONY: windows_386
windows_386: $(sources)
	#rsrc -manifest $(BINARY).manifest -ico "img/$(BINARY)_icon.ico" -o rsrc.syso
	$(call cmd,windows,386,.exe)

.PHONY: windows_386.zip
windows_386.zip: windows_386
	$(call zip,windows,386,.exe)

.PHONY: windows_amd64
windows_amd64: $(sources)
	#rsrc -manifest $(BINARY).manifest -ico "img/$(BINARY)_icon.ico" -o rsrc.syso
	$(call cmd,windows,amd64,.exe)

.PHONY: windows_amd64.zip
windows_amd64.zip: windows_amd64
	$(call zip,windows,amd64,.exe)

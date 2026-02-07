style:
	stylua .

check:
	luacheck --codes .

test:
	busted --helper=spec/spec_helper.lua .

all: style check test

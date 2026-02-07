style:
	stylua .

check:
	luacheck .

test:
	busted --helper=spec/spec_helper.lua .

all: style check test

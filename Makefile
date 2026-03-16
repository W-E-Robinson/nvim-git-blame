all: style check test

style:
	stylua .

check:
	luacheck --include-files "plugin/nvim_git_blame.lua" "spec/**/*.lua" "lua/" --codes .

test:
	busted --helper=spec/spec_helper.lua

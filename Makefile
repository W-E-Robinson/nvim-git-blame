style:
	stylua .

check:
	luacheck .

pre-push: style check

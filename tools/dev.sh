#!/bin/sh
set -e
rojo serve test-runner.project.json \
	& rojo sourcemap default.project.json -o sourcemap.json --watch \
	& ROBLOX_DEV=true COMPILE_TARGET="roblox" darklua process --config .darklua.json --watch src/ build/

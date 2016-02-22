maze:
	elm-make Maze.elm --output dist/maze.js

sparkle:
	elm-make Sparkle.elm --output dist/sparkle.js

all: sparkle maze

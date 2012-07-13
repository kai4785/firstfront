cmake_minimum_required(VERSION 2.8.1)

# Explicity declare this is a D project
project (firstfront D)
set( GLOBAL_DMD_DEFS "-w -g" )

# In order for 'import' to find modules, the include directory must be set.
include_directories(${${PROJECT_NAME}_SOURCE_DIR})

set (SOURCES
	firstfront.d
	Grammar.d
	Token.d
	Tokenizer.d
	)

add_executable(${PROJECT_NAME}
	${SOURCES}
	)


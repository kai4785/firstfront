DMD=dmd

# Differentiate between a Linux and Windows build
ifeq (${windir},)
  RM=rm -fr
  BIN_EXT=
  OBJ_EXT=o
else
  RM=del
  BIN_EXT=.exe
  OBJ_EXT=obj
endif

OBJ_DIR=obj
BIN_DIR=bin
SOURCES:=$(wildcard *.d)
OBJS:=$(addprefix ${OBJ_DIR}/,$(patsubst %.d,%.o,${SOURCES}))
TARGET=${BIN_DIR}/kgrlex${BIN_EXT}

release: DFLAGS=-release -O -inline -L-lrt
release: all
debug: DFLAGS=-wi -debug -L-lrt
debug: all
profile: DFLAGS=-wi -profile -L-lrt
profile: all
unittest: DFLAGS=-debug -unittest -L-lrt
unittest: all

all:${OBJS} ${TARGET}

#Compile all object files
${OBJ_DIR}/%.o: %.d
	${DMD} $< -c -of$@

${TARGET}:${OBJS} | ${BIN_DIR}
	${DMD} $? -of${TARGET}

${BIN_DIR}:
	mkdir -p ${BIN_DIR}

${OBJS}: | ${OBJ_DIR}

${OBJ_DIR}:
	mkdir -p ${OBJ_DIR}

.PHONY:clean
clean:
	${RM} ${OBJ_DIR} ${BIN_DIR}

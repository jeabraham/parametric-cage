OPENSCAD ?= $(shell which openscad 2>/dev/null || find /Applications/OpenSCAD*.app -name OpenSCAD 2>/dev/null | head -n1 || echo openscad)
TARGETS=$(shell sed -E '/^module [a-z0-9_-]+\(\).*make ?me.*$$/!d;s/module //;s/\(\).*/.stl/' main.scad)

GENERATED_FILES = 	$(wildcard *.deps) \
					${TARGETS} \
					$(wildcard *.generated.scad)

.phony: all clean

all: ${TARGETS}

.SECONDARY: $(shell echo "${TARGETS}" | sed 's/\.stl/.generated.scad/g')

include $(wildcard *.deps)

%.generated.scad:
	echo 'use <main.scad>\n$*();' > $@

%.stl: %.generated.scad
	${OPENSCAD} -DFN=64 -m make -o $@ -d $@.deps $<

image:
	${OPENSCAD} -DFN=32 --render --camera 7,3,5,70,0,50,265 --imgsize 1600,1000 -o main.png main.scad

clean:
	rm -rf ${GENERATED_FILES}

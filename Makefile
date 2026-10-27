OPENSCAD ?= $(shell which openscad 2>/dev/null || find /Applications/OpenSCAD*.app -name OpenSCAD 2>/dev/null | head -n1 || echo openscad)
HAS_MANIFOLD := $(shell ${OPENSCAD} --help 2>&1 | grep -q manifold && echo "--enable=manifold")
OPENSCAD_FLAGS ?= ${HAS_MANIFOLD} -DFN=64

OUTDIR ?= build

# Extract module targets from main.scad (e.g. make_cage, make_base, make_lock_bolt, make_lock_nut)
MAIN_MODULES := $(shell sed -E '/^module [a-z0-9_-]+\(\).*make ?me.*$$/!d;s/module ([a-z0-9_-]+)\(\).*/\1/' main.scad)

TARGETS_3MF := $(patsubst %,${OUTDIR}/%.3mf,${MAIN_MODULES}) \
               ${OUTDIR}/sizing_rings.3mf \
               ${OUTDIR}/ruler.3mf

TARGETS_STL := $(patsubst %,${OUTDIR}/%.stl,${MAIN_MODULES}) \
               ${OUTDIR}/sizing_rings.stl \
               ${OUTDIR}/ruler.stl

.PHONY: all 3mf stl clean image cage base bolt nut rings ruler

# Default builds all 3MF files into $(OUTDIR)
all: 3mf

3mf: ${TARGETS_3MF}

stl: ${TARGETS_STL}

# Convenience shortcuts (default to 3MF)
cage:  ${OUTDIR}/make_cage.3mf
base:  ${OUTDIR}/make_base.3mf
bolt:  ${OUTDIR}/make_lock_bolt.3mf
nut:   ${OUTDIR}/make_lock_nut.3mf
rings: ${OUTDIR}/sizing_rings.3mf
ruler: ${OUTDIR}/ruler.3mf

.SECONDARY: $(patsubst %,${OUTDIR}/%.generated.scad,${MAIN_MODULES})

-include $(wildcard ${OUTDIR}/*.deps)

${OUTDIR}:
	@mkdir -p ${OUTDIR}

${OUTDIR}/%.generated.scad: | ${OUTDIR}
	@printf 'use <../main.scad>\n$*();\n' > $@

# Rules for main.scad targets
${OUTDIR}/%.3mf: ${OUTDIR}/%.generated.scad
	${OPENSCAD} ${OPENSCAD_FLAGS} -m make -o $@ -d $@.deps $<

${OUTDIR}/%.stl: ${OUTDIR}/%.generated.scad
	${OPENSCAD} ${OPENSCAD_FLAGS} -m make -o $@ -d $@.deps $<

# Rules for sizing rings
${OUTDIR}/sizing_rings.3mf: parametric\ cage\ gauge\ -\ rings.scad | ${OUTDIR}
	${OPENSCAD} ${OPENSCAD_FLAGS} -m make -o $@ -d $@.deps "$<"

${OUTDIR}/sizing_rings.stl: parametric\ cage\ gauge\ -\ rings.scad | ${OUTDIR}
	${OPENSCAD} ${OPENSCAD_FLAGS} -m make -o $@ -d $@.deps "$<"

# Rules for ruler (length gauge)
${OUTDIR}/ruler.3mf: parametric\ cage\ gauge\ -\ length.scad | ${OUTDIR}
	${OPENSCAD} ${OPENSCAD_FLAGS} -m make -o $@ -d $@.deps "$<"

${OUTDIR}/ruler.stl: parametric\ cage\ gauge\ -\ length.scad | ${OUTDIR}
	${OPENSCAD} ${OPENSCAD_FLAGS} -m make -o $@ -d $@.deps "$<"

image: | ${OUTDIR}
	${OPENSCAD} -DFN=32 --render --camera 7,3,5,70,0,50,265 --imgsize 1600,1000 -o ${OUTDIR}/main.png main.scad

clean:
	rm -rf ${OUTDIR}

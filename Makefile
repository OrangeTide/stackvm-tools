CFLAGS += -Wall

all ::
clean ::

## common stuff
QCOMMONDIR := qcommon

## q3asm
Q3ASMDIR := asm
Q3ASMOBJS := $(Q3ASMDIR)/q3asm.o $(Q3ASMDIR)/cmdlib.o
$(Q3ASMDIR)/q3asm : $(Q3ASMOBJS)
$(Q3ASMDIR)/q3asm : CPPFLAGS += -I$(Q3ASMDIR) -I$(QCOMMONDIR)/..
q3asm : $(Q3ASMDIR)/q3asm ; cp $< $@
all :: q3asm
clean :: ; $(RM) q3asm $(Q3ASMDIR)/q3asm $(Q3ASMOBJS)

## q3lcc - common (needs for lburg, dagcheck and main compiler)
Q3LCCCOREDIR := lcc
Q3RCCDIR := $(Q3LCCCOREDIR)/src
Q3LCCDIR := $(Q3LCCCOREDIR)/etc
Q3CPPDIR := $(Q3LCCCOREDIR)/cpp

## q3lcc - lburg
LBURGDIR := $(Q3LCCCOREDIR)/lburg
LBURGOBJ := \
	$(LBURGDIR)/lburg.o \
	$(LBURGDIR)/gram.o
LBURG := $(LBURGDIR)/lburg
$(LBURG) : $(LBURGOBJ)
all :: $(LBURG)
clean :: ; $(RM) $(LBURG) $(LBURGOBJ) $(LBURGDIR)/gram.c

## q3lcc - dagcheck.c
DAGCHECK_C := $(Q3RCCDIR)/dagcheck.c
$(DAGCHECK_C) : $(LBURG) $(Q3RCCDIR)/dagcheck.md
	$(LBURG) $(Q3RCCDIR)/dagcheck.md $@
clean :: ; $(RM) $(DAGCHECK_C)

## q3rcc - core compiler
Q3RCCOBJ := \
  $(Q3RCCDIR)/alloc.o \
  $(Q3RCCDIR)/bind.o \
  $(Q3RCCDIR)/bytecode.o \
  $(Q3RCCDIR)/dag.o \
  $(Q3RCCDIR)/dagcheck.o \
  $(Q3RCCDIR)/decl.o \
  $(Q3RCCDIR)/enode.o \
  $(Q3RCCDIR)/error.o \
  $(Q3RCCDIR)/event.o \
  $(Q3RCCDIR)/expr.o \
  $(Q3RCCDIR)/gen.o \
  $(Q3RCCDIR)/init.o \
  $(Q3RCCDIR)/inits.o \
  $(Q3RCCDIR)/input.o \
  $(Q3RCCDIR)/lex.o \
  $(Q3RCCDIR)/list.o \
  $(Q3RCCDIR)/main.o \
  $(Q3RCCDIR)/null.o \
  $(Q3RCCDIR)/output.o \
  $(Q3RCCDIR)/prof.o \
  $(Q3RCCDIR)/profio.o \
  $(Q3RCCDIR)/simp.o \
  $(Q3RCCDIR)/stmt.o \
  $(Q3RCCDIR)/string.o \
  $(Q3RCCDIR)/sym.o \
  $(Q3RCCDIR)/symbolic.o \
  $(Q3RCCDIR)/trace.o \
  $(Q3RCCDIR)/tree.o \
  $(Q3RCCDIR)/types.o
$(Q3RCCDIR)/rcc : $(Q3RCCOBJ)
	$(CC) $(LDFLAGS) $(TARGET_ARCH) $^ $(LOADLIBES) $(LDLIBS) -o $@
$(Q3RCCDIR)/rcc : CPPFLAGS += -I$(Q3RCCDIR)
q3rcc : $(Q3RCCDIR)/rcc ; cp $< $@
all :: q3rcc
clean :: ; $(RM) $(Q3RCCOBJ) q3rcc $(Q3RCCDIR)/rcc

## q3cpp
Q3CPPOBJ := \
  $(Q3CPPDIR)/cpp.o \
  $(Q3CPPDIR)/lex.o \
  $(Q3CPPDIR)/nlist.o \
  $(Q3CPPDIR)/tokens.o \
  $(Q3CPPDIR)/macro.o \
  $(Q3CPPDIR)/eval.o \
  $(Q3CPPDIR)/include.o \
  $(Q3CPPDIR)/hideset.o \
  $(Q3CPPDIR)/getopt.o \
  $(Q3CPPDIR)/unix.o
$(Q3CPPDIR)/cpp : $(Q3CPPOBJ)
$(Q3CPPDIR)/cpp : CPPFLAGS += -I$(Q3CPPDIR)
q3cpp : $(Q3CPPDIR)/cpp ; cp $< $@
all :: q3cpp
clean :: ; $(RM) $(Q3CPPOBJ) q3cpp $(Q3CPPDIR)/cpp

## q3lcc
Q3LCCOBJ := \
	$(Q3LCCDIR)/bytecode.o \
	$(Q3LCCDIR)/lcc.o
$(Q3LCCDIR)/lcc : $(Q3LCCOBJ)
$(Q3LCCDIR)/lcc : CPPFLAGS += -I$(Q3RCCDIR) -I$(QCOMMONDIR)/..
q3lcc : $(Q3LCCDIR)/lcc ; cp $< $@
all :: q3lcc
clean :: ; $(RM) $(Q3LCCOBJ) q3lcc $(Q3LCCDIR)/lcc



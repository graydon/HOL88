# where you keep local executables
BINDIR		= /usr/local/bin

# man directory for local man pages (usually /usr/man/manl)
MANDIR		= /usr/man/manl
MANEXT		= l

# command which will print things on a LaserWriter
LPR		= /usr/ucb/lpr
PRINTER		= lw

WINDOW_LIB	= -lsuntool -lsunwindow -lpixrect

OFILES	 	= actions.o emalloc.o events.o expr.o func.o func_fix.o misc.o \
		  objects.o parse.o selection.o symbols.o tooltool.o windows.o

OPTIONS		= -O

.c.o:
	cc $(OPTIONS) -c $<

.y.o:
	yacc $<
	cc $(OPTIONS) -c -o $*.o y.tab.c
	rm y.tab.c

tooltool: $(OFILES)
	cc $(OPTIONS) -o tooltool $(OFILES) $(WINDOW_LIB) -lm

install: tooltool
	cp tooltool $(BINDIR)
	cp tooltool.man $(MANDIR)/tooltool.$(MANEXT)

manual:
	cd doc; make manual LPR="$(LPR)" PRINTER="$(PRINTER)"

shar:
	cd doc/doc; make shar
	rm -f MANIFEST*
	makekit -s45k -oMANIFEST Makefile samples doc README *.[chy] *.icon *.man samples/* doc/Makefile doc/*.uu*

patch: Makefile *.man *.[chy]
	rm -f patch temp
	-for i in Makefile *.man *.[chy] ; do \
	   diff -c $${i}.orig $$i >>temp ; \
	done
	sed '/^No differences encountered/d' <temp >patch
	rm temp

newver:
	for i in Makefile *.[chy] ; do \
	   cp $$i $${i}.orig ; \
	done

clean:
	rm -f *.o y.output tooltool core Part*

#dependencies

actions.o: tooltool.h

emalloc.o: tooltool.h

events.o: tooltool.h

expr.o: tooltool.h

func.o: tooltool.h

func_fix.o: tooltool.h

misc.o: tooltool.h

objects.o: tooltool.h

parse.o: tooltool.h lex.c

selection.o: tooltool.h

symbols.o: tooltool.h

tooltool.o: tooltool.h

windows.o: tooltool.h

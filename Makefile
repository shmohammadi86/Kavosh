#===============================================================================
# Kavosh -- exact network motif discovery
# https://github.com/shmohammadi86/Kavosh
#===============================================================================

CXX      ?= g++
PREFIX   ?= /usr/local

WARNINGS  = -Wall -Wno-unused-variable -Wno-unused-but-set-variable -Wno-write-strings
OPTFLAGS ?= -O2
CXXFLAGS ?= -std=c++17 $(OPTFLAGS) $(WARNINGS)
CPPFLAGS += -I./include

PROGRAM   = Kavosh

CXX_SRC   = src/main.cpp src/graph.cpp src/ZeroOneTree.cpp src/randomGenerator.cpp
C_SRC     = nauty/nauty.c nauty/naugraph.c nauty/nautil.c

OBJ       = $(CXX_SRC:.cpp=.o) $(C_SRC:.c=.o)

.PHONY: all check install clean distclean

all: $(PROGRAM)

$(PROGRAM): $(OBJ)
	$(CXX) $(CXXFLAGS) -o $@ $(OBJ)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c -o $@ $<

# nauty ships as C but is included from C++ translation units; build it as C++
# so the two halves agree on linkage.
%.o: %.c
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c -o $@ $<

# Smoke test: enumerate size-3 subgraphs in the yeast transcription network.
check: $(PROGRAM)
	@rm -rf result && mkdir -p result
	./$(PROGRAM) -i networks/yeast -s 3 -r 10 -o result
	@test -s result/adjMatrix.txt || { echo "FAIL: adjMatrix.txt not produced"; exit 1; }
	@test -s result/ZScore.txt    || { echo "FAIL: ZScore.txt not produced";    exit 1; }
	@echo "OK: Kavosh smoke test passed"

install: $(PROGRAM)
	install -d $(DESTDIR)$(PREFIX)/bin
	install -m 0755 $(PROGRAM) $(DESTDIR)$(PREFIX)/bin/$(PROGRAM)

clean:
	rm -f $(PROGRAM) $(OBJ) *~ src/*~ include/*~ core

distclean: clean
	rm -rf result

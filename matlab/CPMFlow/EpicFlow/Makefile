CCPP=g++ -std=c++11
CC=gcc

LAPACKCFLAGS=#-DTHREADEDLAPACK
LAPACKLDFLAGS=-L/usr/lib64/atlas/ -llapack

CFLAGS=-DFINTEGER=int -fPIC -Wall -g -O3 -msse4 $(LAPACKCFLAGS) # -fopenmp -DUSE_OPENMP
LDFLAGS=-fPIC -Wall -g -O3 -msse4 -ljpeg -lpng -lgfortran -L/usr/local/lib $(LAPACKLDFLAGS)  #-fopenmp 

SOURCES_CPP := $(shell find . -name '*.cpp')
SOURCES_C := $(shell find . -name '*.c')
OBJ := $(SOURCES_CPP:%.cpp=%.o) $(SOURCES_C:%.c=%.o) 
HEADERS := $(shell find . -name '*.h')

all: epicflow

.cpp.o:  %.cpp %.h
	$(CCPP) -o $@ $(CFLAGS) -c $+

.c.o:  %.c %.h
	$(CC) -o $@ $(CFLAGS) -c $+

epicflow: $(HEADERS) $(OBJ)
	$(CCPP) -o $@ $^ $(LDFLAGS)

epicflow-static: $(HEADERS) $(OBJ)
	$(CCPP) -o $@ $^ -static  /usr/lib/x86_64-linux-gnu/libjpeg.a /usr/local/lib/libpng.a /usr/lib/x86_64-linux-gnu/libz.a /usr/lib/x86_64-linux-gnu/libm.a /usr/lib/liblapack.a /usr/lib/gcc/x86_64-linux-gnu/4.8/libgfortran.a /usr/lib/libblas.a


clean:
	rm -f $(OBJ) epicflow


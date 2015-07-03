# EupsPkg config file. Sourced by 'eupspkg'

# The prefix to append to all binaries (e.g., lsst-g++, lsst-gcc, ...)
# PROGRAM_PREFIX=lsst-

GCC_VERSION=4.8.5
GMP_VERSION=5.1.3
MPC_VERSION=1.0.3
MPFR_VERSION=3.1.2

prep()
{
	# untar and link everything
	mkdir sources
	cd sources
	tar xjf ../upstream/gcc-$GCC_VERSION.tar.bz2
	tar xzf ../upstream/gmp-$GMP_VERSION.tar.gz
	tar xzf ../upstream/mpc-$MPC_VERSION.tar.gz
	tar xzf ../upstream/mpfr-$MPFR_VERSION.tar.gz

	ln -s gcc-$GCC_VERSION gcc

	cd gcc
	ln -s ../gmp-$GMP_VERSION  gmp
	ln -s ../mpc-$MPC_VERSION  mpc
	ln -s ../mpfr-$MPFR_VERSION mpfr

	cd ../..
	rm -rf upstream
}

config()
{
	mkdir build
	cd build

	../sources/gcc/configure --prefix="$PREFIX" --enable-languages=c,c++,fortran --disable-multilib --program-prefix="$PROGRAM_PREFIX"
}

build()
{
	cd build && make -j$NJOBS
}

install()
{
	clean_old_install

	( cd build && make install; )
	
	install_ups
}

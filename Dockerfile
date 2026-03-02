FROM prereq_toolchain_gcc48
WORKDIR /
RUN wget http://download.oracle.com/berkeley-db/db-4.7.25.NC.tar.gz && \
    tar -xvf db-4.7.25.NC.tar.gz
WORKDIR /db-4.7.25.NC/build_unix
RUN ../dist/configure --enable-cxx && \
    make -j"$(($(nproc) + 1))" && make install && \
    ln -s /usr/local/BerkeleyDB.4.7/lib/* /usr/lib64/

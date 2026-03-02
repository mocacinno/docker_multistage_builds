FROM prereq_toolchain_gcc48
WORKDIR / 
RUN wget https://gitlab.freedesktop.org/xorg/lib/libxtrans/-/archive/xtrans-1.0.2/libxtrans-xtrans-1.0.2.tar.gz && \
    tar -xvf libxtrans-xtrans-1.0.2.tar.gz
WORKDIR /libxtrans-xtrans-1.0.2
RUN sed -i '24i m4_pattern_allow([AS_HELP_STRING])' configure.ac && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install

FROM prereq_toolchain_gcc48
WORKDIR /
RUN wget https://gitlab.freedesktop.org/xorg/util/macros/-/archive/util-macros-1.3.0/macros-util-macros-1.3.0.tar.gz && \
    tar -xvf macros-util-macros-1.3.0.tar.gz
WORKDIR /macros-util-macros-1.3.0
RUN sed -i '24i m4_pattern_allow([AS_HELP_STRING])' configure.ac  && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install

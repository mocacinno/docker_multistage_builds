FROM prereq_toolchain_gcc48
WORKDIR /
RUN wget https://sourceforge.net/projects/boost/files/boost/1.40.0/boost_1_40_0.tar.gz/download -O boost_1_40_0.tar.gz && \
    tar -xvf boost_1_40_0.tar.gz
ENV BOOST_ROOT=/boost_1_40_0
WORKDIR /boost_1_40_0
RUN chmod +x bootstrap.sh && \
    ./bootstrap.sh && \
    ./bjam -j"$(($(nproc) + 1))" install || echo 1

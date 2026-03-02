FROM prereq_toolchain_gcc48
WORKDIR /
RUN wget https://github.com/wxWidgets/wxWidgets/archive/refs/tags/v2.8.9.zip && \
    unzip v2.8.9.zip
WORKDIR /wxWidgets-2.8.9
RUN ./autogen.sh && \
    find . -type f -exec sed -i 's/GSocket/wxGSocket/g' {} \; && \
    find . -type f -exec sed -i 's/typedef struct _GSocket/typedef struct _wxGSocket/' {} \; && \
    find . -type f -exec sed -i 's/class GSocket/class wxGSocket/' {} \; && \
    CXXFLAGS="-fPIC -fpermissive" CFLAGS="-fPIC -fpermissive" ./configure --enable-unicode --enable-debug --prefix=/usr/local/wxwidgets  --with-gtk --enable-shared --enable-monolithic && \
    ln -s /usr/lib64/libjpeg.so.8 /usr/lib64/libjpeg8.so && \
    unlink /usr/lib64/libjpeg.so && \
    ln -s /usr/lib64/libjpeg.so.8.2.2 /usr/lib64/libjpeg.so && \
    CXXFLAGS="-fPIC -fpermissive" CFLAGS="-fPIC" make -j"$(($(nproc) + 1))" LDFLAGS="-lpangocairo-1.0 -lX11 -lcairo -ljpeg8" && \
    make install && \
    ldconfig 

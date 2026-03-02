FROM prereq_toolchain_gcc48
WORKDIR /
RUN wget https://download.gnome.org/sources/pango/1.24/pango-1.24.5.tar.gz
RUN ls -ltrh
RUN file pango-1.24.5.tar.gz
RUN tar -xvf pango-1.24.5.tar.gz
RUN mv /usr/include/freetype2 /opt/freetype2_bak && \
    mkdir -p /usr/local/include/freetype1 && \
    mkdir -p /usr/local/include/freetype
RUN wget https://github.com/LuaDist/freetype/archive/refs/heads/master.zip && \
    unzip master.zip
RUN cp -r /freetype-master/include/freetype/* /usr/local/include/freetype1 && \
    cp -r /freetype-master/include/*.h /usr/local/include/freetype1 && \
    cp -r /usr/local/include/freetype1/* /usr/local/include/freetype
WORKDIR /pango-1.24.5
RUN CPPFLAGS="-I/usr/local/include/freetype1" ./configure && \
    make -j"$(($(nproc) + 1))" && \
    make install && \
    mv /opt/freetype2_bak /usr/include/freetype2 && \
    cp -r /pango-1.24.5/pango/.libs/* /usr/lib64/

FROM prereq_toolchain_gcc48
COPY --from=prereq_lib_wxwidgets289 /usr/local/wxwidgets/include/wx-2.8/wx/ /usr/local/wxwidgets/include/wx-2.8/wx/
COPY --from=prereq_lib_wxwidgets289 /wxWidgets-2.8.9/lib/wx/include/gtk2-unicode-debug-2.8/wx/ /usr/local/wxwidgets/lib/wx/include/gtk2-unicode-debug-2.8/wx/
COPY --from=prereq_lib_wxwidgets289 /wxWidgets-2.8.9/lib/ /usr/lib64/
COPY --from=prereq_lib_openssl098k /usr/local/ssl/include/openssl/ /openssl-0.9.8k/include/openssl/
COPY --from=prereq_lib_boost1400 /usr/local/include/boost/ /usr/local/include/boost/
COPY --from=prereq_lib_boost1400 /usr/local/lib/ /usr/local/lib/
COPY --from=prereq_lib_berkelydb4725 /db-4.7.25.NC/build_unix/ /usr/local/BerkeleyDB.4.7/include
COPY --from=prereq_lib_berkelydb4725 /usr/lib64/ /usr/lib64/


WORKDIR /
RUN wget https://github.com/mocacinno/bitcoin_core_history/archive/refs/heads/v0.2.0_patched.zip  && \
    unzip v0.2.0_patched.zip
WORKDIR /bitcoin_core_history-0.2.0_patched
RUN mkdir -p obj/nogui && \
    zypper --non-interactive install dos2unix && \
    dos2unix * && \
    make -f makefile.mocacinno bitcoin CFLAGS="-I/usr/local/include/boost/ -I/usr/local/wxwidgets/include/wx-2.8/ -I/usr/local/wxwidgets/lib/wx/include/gtk2-unicode-debug-2.8 -I/usr/local/lib/ -I/usr/lib64/wx/include/gtk2-unicode-debug-2.9 -I/openssl-0.9.8k/include -I/usr/local/wxwidgets/lib/ -I/usr/local/BerkeleyDB.4.7/include -I/wxWidgets-2.8.9/lib -I/usr/lib64 -fpermissive -D_FILE_OFFSET_BITS=64 -D__WXDEBUG__ -DWXUSINGDLL -D__WXGTK__ -pthread -march=x86-64 -mtune=generic"
RUN strip bitcoin
RUN zypper addrepo https://download.opensuse.org/repositories/home:plasmaregataos/15.6/home:plasmaregataos.repo && \
    zypper --gpg-auto-import-keys ref -s && \
    zypper --non-interactive install xauth
RUN ln -s /usr/local/wxwidgets/lib/libwx_gtk2ud-2.8.so.0 /usr/lib64/libwx_gtk2ud-2.8.so.0
RUN ln -s /bitcoin_core_history-0.2.0_patched/bitcoin /usr/local/bin
RUN useradd -m -u 10001 bitcoinuser
COPY bitcoin.conf /home/bitcoinuser/.bitcoin/bitcoin.conf
RUN chown -R bitcoinuser:users /home/bitcoinuser
USER bitcoinuser
LABEL org.opencontainers.image.revision="manual-trigger-20260203"

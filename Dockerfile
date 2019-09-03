FROM debian:stretch-slim as builder

RUN apt update && apt install gcc g++ binutils cmake libaio-dev libffi-dev libglib2.0-dev libglib2.0-bin wget -y
RUN wget https://www.percona.com/downloads/Percona-Server-5.6/Percona-Server-5.6.45-86.1/binary/debian/stretch/x86_64/percona-server-common-5.6_5.6.45-86.1-1.stretch_amd64.deb
RUN wget https://www.percona.com/downloads/Percona-Server-5.6/Percona-Server-5.6.45-86.1/binary/debian/stretch/x86_64/libperconaserverclient18.1_5.6.45-86.1-1.stretch_amd64.deb
RUN wget https://www.percona.com/downloads/Percona-Server-5.6/Percona-Server-5.6.45-86.1/binary/debian/stretch/x86_64/libperconaserverclient18.1-dev_5.6.45-86.1-1.stretch_amd64.deb

RUN dpkg -i percona-server-common-5.6_5.6.45-86.1-1.stretch_amd64.deb
RUN dpkg -i libperconaserverclient18.1_5.6.45-86.1-1.stretch_amd64.deb
RUN dpkg -i libperconaserverclient18.1-dev_5.6.45-86.1-1.stretch_amd64.deb
RUN apt --fix-broken install

ADD ./ /workspace
RUN mkdir /workspace/build && cd /workspace/build && cmake -DBUILD_CONFIG=mysql_release -DCMAKE_BUILD_TYPE=release -DCMAKE_INSTALL_PREFIX=/usr/local/sqlparser .. && make && make install
RUN mkdir /workspace/sqladvisor/build && cd /workspace/sqladvisor/build && cmake -DCMAKE_BUILD_TYPE=release .. && make

FROM debian:stretch-slim
RUN apt update && apt install libssl1.1 libglib2.0-bin zlib1g-dev -y

COPY --from=builder /percona-server-common-5.6_5.6.45-86.1-1.stretch_amd64.deb /percona-server-common-5.6_5.6.45-86.1-1.stretch_amd64.deb
COPY --from=builder /libperconaserverclient18.1_5.6.45-86.1-1.stretch_amd64.deb /libperconaserverclient18.1_5.6.45-86.1-1.stretch_amd64.deb
COPY --from=builder /libperconaserverclient18.1-dev_5.6.45-86.1-1.stretch_amd64.deb /libperconaserverclient18.1-dev_5.6.45-86.1-1.stretch_amd64.deb
RUN dpkg -i percona-server-common-5.6_5.6.45-86.1-1.stretch_amd64.deb \
  && dpkg -i libperconaserverclient18.1_5.6.45-86.1-1.stretch_amd64.deb \
  && dpkg -i libperconaserverclient18.1-dev_5.6.45-86.1-1.stretch_amd64.deb \
  && apt --fix-broken install && rm -f percona-server-common-5.6_5.6.45-86.1-1.stretch_amd64.deb libperconaserverclient18.1_5.6.45-86.1-1.stretch_amd64.deb libperconaserverclient18.1-dev_5.6.45-86.1-1.stretch_amd64.deb
COPY --from=builder /usr/local/sqlparser /usr/local/sqlparser
COPY --from=builder /workspace/sqladvisor/build/sqladvisor /usr/local/sqlparser/bin/sqladvisor
ENV PATH="/usr/local/sqlparser/bin:${PATH}"
ENTRYPOINT ["sqladvisor"]

FROM ubuntu:16.04

ARG NETWORK=live

ENV BOOST_ROOT=/tmp/boost_install

ADD ci /tmp/ci

RUN apt-get update -qq && apt-get install -yqq \
    build-essential \
    cmake \
    g++ \
    wget && \
<<<<<<< HEAD
    wget -qO ${BOOST_BASENAME}.tar.gz ${BOOST_URL} && \
    tar xzf ${BOOST_BASENAME}.tar.gz && \
    cd ${BOOST_BASENAME} && \
    ./bootstrap.sh && \
    ./b2 -d0 --prefix=${BOOST_ROOT} link=static install && \
    rm -rf ${BOOST_BASENAME} && \
    rm -f ${BOOST_BASENAME}.tar.gz && \
    cd .. && \
    mkdir /usr/share/bolt/
=======
    /tmp/ci/bootstrap_boost.sh -m
>>>>>>> 283957ee1b4fcb1099c31a1d8c5583c27027d2bf

ADD ./ /tmp/src

RUN mkdir /tmp/build && \
    cd /tmp/build && \
<<<<<<< HEAD
    cmake /tmp/src -DBOOST_ROOT=${BOOST_ROOT} && \
    make bolt_node && \
    cd ..

FROM ubuntu:16.04
COPY --from=0 /tmp/build/bolt_node /usr/bin
COPY docker/node/entry.sh /entry.sh
COPY docker/node/config.json /usr/share/bolt/config.json
=======
    cmake /tmp/src -DBOOST_ROOT=${BOOST_ROOT} -DACTIVE_NETWORK=rai_${NETWORK}_network && \
    make rai_node && \
    cd .. && \
    echo ${NETWORK} > /etc/nano-network

FROM ubuntu:16.04
COPY --from=0 /tmp/build/rai_node /usr/bin
COPY --from=0 /etc/nano-network /etc
COPY docker/node/entry.sh /entry.sh
COPY docker/node/config /usr/share/raiblocks/config
>>>>>>> 283957ee1b4fcb1099c31a1d8c5583c27027d2bf
RUN chmod +x /entry.sh
CMD ["/bin/bash",  "/entry.sh"]

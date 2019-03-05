FROM alpine:3.7
MAINTAINER danielgomesnegri@gmail.com

ENV RELEASE_VERSION=0.4.1
ENV RELEASE_URL=https://github.com/twitter/twemproxy/archive/v$RELEASE_VERSION.tar.gz
ENV SOURCE_PATH=/usr/src
ENV TWENPROXY_PATH=$SOURCE_PATH/twemproxy-$RELEASE_VERSION

RUN set -x \
    && addgroup -S twemproxy \
    && adduser -S -G twemproxy twemproxy \
    && apk add --no-cache 'su-exec>=0.2' \
    && apk add --no-cache --virtual .build-deps \
      curl \
      perl \
      gcc \
      g++ \
      make \
      musl-dev \
      autoconf \
      automake \
      libtool \
      tar \
    && : "------------- twemproxy -------------" \
    && mkdir -p $SOURCE_PATH && cd $SOURCE_PATH \
    && curl -SL $RELEASE_URL -o twemproxy.tar.gz \
    && tar -zxvf twemproxy.tar.gz \
    && (cd $TWENPROXY_PATH; \
      autoreconf -fvi; \
      ./configure --prefix=/usr; \
      make )\
    && make -C $TWENPROXY_PATH install \
    && rm -rf $SOURCE_PATH \
    && : "---------- remove build deps ----------" \
    && apk del .build-deps

COPY nutcracker.yml /etc/nutcracker.yml
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod 0775 /usr/local/bin/docker-entrypoint.sh
RUN ln -s /usr/local/bin/docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 22121
CMD ["nutcracker", "-c", "/etc/nutcracker.yml"]

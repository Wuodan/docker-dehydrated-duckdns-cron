FROM alpine:latest AS build

ARG APP_VERSION=0.7.0

ADD https://github.com/dehydrated-io/dehydrated/releases/download/v$APP_VERSION/dehydrated-$APP_VERSION.tar.gz \
	/src/dehydrated.tar.gz
ADD https://github.com/walcony/letsencrypt-DuckDNS-hook/archive/master.tar.gz \
	/src/duckdns.tar.gz

RUN cd /src && \
	tar -xf dehydrated.tar.gz && \
	tar -xf duckdns.tar.gz && \
	mv dehydrated-$APP_VERSION dehydrated && \
	mv letsencrypt-DuckDNS-hook-master duckdns && \
	rm dehydrated.tar.gz duckdns.tar.gz


FROM alpine:latest

WORKDIR /dehydrated

# Update CA certs, add bash, curl, openssl
RUN apk --no-cache --update add bash ca-certificates curl openssl sudo && \
	addgroup -S runner && \
	adduser -S runner -G runner && \
	mkdir -p hooks/duckdns

COPY --from=build /src/dehydrated/dehydrated /dehydrated/
COPY --from=build /src/dehydrated/LICENSE /dehydrated/
COPY --from=build /src/duckdns/hook.sh /dehydrated/hooks/duckdns/
COPY --from=build /src/duckdns/LICENSE /dehydrated/hooks/duckdns/

ADD --chown=runner:runner dehydrated /etc/periodic/daily/

RUN touch domains.txt && \
	chmod +x /etc/periodic/daily/dehydrated && \
	chown -R runner:runner . && \
	rm -rf /var/cache/apk/* /tmp/* /var/tmp/

ENV DUCKDNS_TOKEN=
ENV DUCKDNS_TOKEN_FILE=
ENV DOMAIN=
ENV USER=runner

CMD /etc/periodic/daily/dehydrated && crond -f

VOLUME /dehydrated/certs

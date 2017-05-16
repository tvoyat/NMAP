FROM alpine:latest

MAINTAINER Thierry VOYAT <thierry.voyat@ac-amiens.fr>


RUN	apk update && \
	apk add tzdata && cp /usr/share/zoneinfo/Europe/Paris /etc/localtime && \
	&& echo "Europe/Paris" >  /etc/timezone \
    && apk del tzdata \
	&& apk add \
        ca-certificates \
        openssl \
        nmap \
        nmap-nselibs \
        nmap-scripts \
	&& update-ca-certificates \
	&& rm -rf /var/cache/apk/*

COPY FILES/. /usr/share/nmap/scripts/

CMD ["/usr/bin/nmap"]

FROM debian:stretch-slim

RUN apt-get update \
	&& apt-get install -y curl iputils-ping psmisc procps  \
	&& curl -s https://packagecloud.io/install/repositories/varnishcache/varnish41/script.deb.sh | bash \
	&& apt-get update \
	&& apt-get install -y varnish=4.1.10-1~stretch

ADD ./conf/default.vcl /etc/varnish/default.vcl

ADD entrypoint.sh /entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]
ENTRYPOINT ["/entrypoint.sh"]

CMD /usr/sbin/varnishd -j unix,user=varnish -F -f /etc/varnish/default.vcl -a 0.0.0.0:80 -s malloc,$VARNISH_CACHE_SIZE

EXPOSE 80

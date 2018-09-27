FROM debian:stretch-slim

RUN apt-get update \
	&& apt-get install -y curl iputils-ping \
	&& curl -s https://packagecloud.io/install/repositories/varnishcache/varnish41/script.deb.sh | bash \
	&& apt-get update \
	&& apt-get install -y varnish=4.1.10-1~stretch

ADD ./conf/default.vcl /etc/varnish/default.vcl

CMD HOST=$(ping -c 1 nginx | grep PING | awk {'print $3'} | tr -d '(' | tr -d ')') && echo $HOST && sed -i "s/{HOST}/$HOST/g" /etc/varnish/default.vcl \
    && /usr/sbin/varnishd -j unix,user=varnish -F -f /etc/varnish/default.vcl -a 0.0.0.0:80 -s malloc,1g

EXPOSE 80

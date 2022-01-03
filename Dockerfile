FROM 		haproxy:2.0.26-buster
MAINTAINER      christian@redislabs.com
RUN 		apt update && apt-get install -y gettext-base
COPY 		run_haproxy /usr/local/bin/run_haproxy
COPY 		haproxy.tpl /usr/local/etc/haproxy/haproxy.tpl
EXPOSE          2112
ENTRYPOINT [ "/usr/local/bin/run_haproxy" ]



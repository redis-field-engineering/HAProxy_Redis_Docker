###################################################################
#		 Example Config for Docker
###################################################################
global
	log stdout  format raw  local0  info
	stats socket /run/admin.sock mode 660 level admin expose-fd listeners
	stats timeout 30s
	user haproxy
	group haproxy
	daemon

	# Default SSL material locations
	ca-base /etc/ssl/certs
	crt-base /etc/ssl/private

	# See: https://ssl-config.mozilla.org/#server=haproxy&server-version=2.0.3&config=intermediate
        ssl-default-bind-ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
        ssl-default-bind-ciphersuites TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
        ssl-default-bind-options ssl-min-ver TLSv1.2 no-tls-tickets

defaults
	log	global
	mode	http
	option	httplog
	option	dontlognull
        timeout connect 5000
        timeout client  50000
        timeout server  50000

###################################################################
#		Stats Frontend
###################################################################
listen  stats   
	bind 		:2112
        mode            http
        log             global

        maxconn 10

        timeout client      100s
        timeout server      100s
        timeout connect     100s
        timeout queue       100s

        stats enable
        stats hide-version
        stats refresh 30s
        stats show-node
        stats auth ${HAPROXY_STATS_USER}:${HAPROXY_STATS_PASSWORD}
        stats uri  /

###################################################################
#		Redis Enterprise Redis Services
###################################################################

# Redis Database on port ${HAPROXY_LISTEN_PORT}
frontend redis-fe-${HAPROXY_LISTEN_PORT}
        bind :${HAPROXY_LISTEN_PORT}
	mode tcp
        default_backend redis-be-${HAPROXY_LISTEN_PORT}
	option tcplog

backend redis-be-${HAPROXY_LISTEN_PORT}
        option tcp-check
	mode tcp
	balance roundrobin

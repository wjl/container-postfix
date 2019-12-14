FROM alpine
LABEL author="wjl@icecavern.net"

# Install packages.
RUN \
	apk update && \
	apk upgrade && \
	apk add --no-cache \
		postfix \
		postfix-pcre \
		postfix-pgsql \
	&& \
	rm -r /var/cache/apk/*

# Entrypoint script.
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

# Expose ports.
EXPOSE \
	# SMTP
	25/tcp \
	# Submission (SSL)
	465/tcp \
	# Submission
	587/tcp

VOLUME \
	# Postfix configuration.
	/etc/postfix \
	# Postfix data.
	/var/spool/postfix

# Check every once in a while to see if the server is still listening on all ports.
HEALTHCHECK --interval=30m --timeout=10s \
  CMD \
  	nc -z localhost  25 && \
  	nc -z localhost 465 && \
  	nc -z localhost 587

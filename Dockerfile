FROM lsiobase/ubuntu:bionic

LABEL maintainer 'Sam Burney <sam@burney.io>'

# Disable dpkg frontend to avoid error rmessages
ENV DEBIAN_FRONTEND=noninteractive

# Install wget and install/updates certificates
RUN apt-get update \
 && apt-get install -f -y -q --no-install-recommends \
    trac \
    trac-accountmanager \
    trac-codecomments \
    trac-customfieldadmin \
    trac-mastertickets \
    trac-navadd \
    trac-tags \
    trac-email2trac \
    git-core \
    mercurial \
    apache2 \
    libapache2-mod-authnz-external \
    libapache2-mod-python \
    php-cli \
    php-mysql \
    php-pear \
    ldap-utils \
 && pear install MDB2-beta#mysqli \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*

COPY ./docker/root/ /

RUN ln -sf /dev/stdout /var/log/apache2/access.log \
	&& ln -sf /dev/stderr /var/log/apache2/error.log

VOLUME ["/trac"]
EXPOSE 80 443

ENTRYPOINT ["/init"]

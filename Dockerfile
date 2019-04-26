FROM lsiobase/ubuntu:bionic

LABEL maintainer 'Sam Burney <sam@burney.io>'

# Disable dpkg frontend to avoid error rmessages
ENV DEBIAN_FRONTEND=noninteractive

# Install wget and install/updates certificates
RUN apt-get update \
   && apt install -f -y -q --no-install-recommends \
      trac \
      trac-accountmanager \
      trac-codecomments \
      trac-customfieldadmin \
      trac-mastertickets \
      trac-navadd \
      trac-tags \
      git-core \
      mercurial \
      apache2 \
      libapache2-mod-authnz-external \
      libapache2-mod-python \
      php-cli \
      php-mysql \
      php-pear \
      ldap-utils \
      postfix \
   ## Install email2trac build dependancies
   && apt build-dep -f -y -q email2trac \
   ## Build latest email2trac
   && git clone https://gitlab.com/surfsara/email2trac.git /usr/src/email2trac \
   && cd /usr/src/email2trac \
   && ./configure --sysconfdir=/etc \
   && make \
   && make install \
   ## Remove email2trac build dependancies
   && cd / \
   && rm -rf /usr/src/email2trac \
   && apt remove -f -y -q autoconf automake autopoint autotools-dev binutils binutils-common binutils-x86-64-linux-gnu bsdmainutils build-essential cpp cpp-7 debhelper dh-autoreconf dh-python dh-strip-nondeterminism docbook-xsl dpkg-dev file g++ g++-7 gcc gcc-7 gcc-7-base gettext gettext-base groff-base intltool-debian libarchive-zip-perl libasan4 libatomic1 libbinutils libbsd0 libc-dev-bin libc6-dev libcc1-0 libcilkrts5 libcroco3 libdpkg-perl libfile-stripnondeterminism-perl libgcc-7-dev libglib2.0-0 libgomp1 libisl19 libitm1 liblsan0 libmpc3 libmpdec2 libmpfr6 libmpx2 libpipeline1 libpython3-stdlib libpython3.6-minimal libpython3.6-stdlib libquadmath0 libsigsegv2 libstdc++-7-dev libtimedate-perl libtool libtsan0 libubsan0 linux-libc-dev m4 make man-db patch po-debconf python3 python3-distutils python3-lib2to3 python3-minimal python3.6 python3.6-minimal sgml-base xml-core xsltproc xz-utils \
   && pear install MDB2-beta#mysqli \
   && apt-get clean \
   && rm -r /var/lib/apt/lists/*

COPY ./docker/root/ /

RUN ln -sf /dev/stdout /var/log/apache2/access.log \
	&& ln -sf /dev/stderr /var/log/apache2/error.log

VOLUME ["/trac"]
EXPOSE 80 443

ENTRYPOINT ["/init"]

FROM alvarobacelar/java-oracle

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

# let "Tomcat Native" live somewhere isolated
ENV TOMCAT_NATIVE_LIBDIR $CATALINA_HOME/native-jni-lib
ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$TOMCAT_NATIVE_LIBDIR
ENV XMX=6000 \
    XMS=1024 \
    MAXPERM=2000

ENV CATALINA_OPTS="-Xms${XMS}M -Xmx${XMX}M -XX:MaxPermSize=${MAXPERM}m -server -XX:+UseParallelGC -Djava.awt.headless=true -Duser.timezone=America/Fortaleza -Duser.language=pt -Duser.region=BR"

RUN  \
        echo 'deb http://deb.debian.org/debian stretch main' >> /etc/apt/sources.list; \
        echo 'deb http://security.debian.org stretch/updates main' >> /etc/apt/sources.list; \
        echo 'deb http://deb.debian.org/debian stretch-updates main' >> /etc/apt/sources.list; \
        echo 'deb http://ftp.debian.org/debian jessie-backports main' >> /etc/apt/sources.list; \

        apt-get update; \
        apt-get install -y -t jessie-backports   --no-install-recommends openssl libapr1 vim  gnupg dirmngr  wget ca-certificates dpkg-dev gcc libapr1-dev libssl-dev make; \ 
        rm -rf /var/lib/apt/lists/*

RUN     \
	nativeBuildDir="$(mktemp -d)"; \
	wget -O apache-tomcat-8.0.35.tar.gz https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.35/bin/apache-tomcat-8.0.35.tar.gz; \
        tar -xvf apache-tomcat-8.0.35.tar.gz --strip-components=1; \
	rm bin/*.bat; \
        rm apache-tomcat-8.0.35.tar.gz*; \
	tar -xvf bin/tomcat-native.tar.gz -C "$nativeBuildDir" --strip-components=1; \
	rm bin/tomcat-native.tar.gz; \
        cd "$nativeBuildDir/native"; \
	gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
	./configure \
		--build="$gnuArch" \
		--libdir="$TOMCAT_NATIVE_LIBDIR" \
		--prefix="$CATALINA_HOME" \
		--with-apr="$(which apr-1-config)" \
		--with-java-home="$(docker-java-home)" \
		--with-ssl=yes;\
	make -j "$(nproc)"; \
        make install ; \
	rm -rf "$nativeBuildDir" 

RUN set -e \
	&& nativeLines="$(catalina.sh configtest 2>&1)" \
	&& nativeLines="$(echo "$nativeLines" | grep 'Apache Tomcat Native')" \
	&& nativeLines="$(echo "$nativeLines" | sort -u)" \
	&& if ! echo "$nativeLines" | grep 'INFO: Loaded APR based Apache Tomcat Native library' >&2; then \
		echo >&2 "$nativeLines"; \
		exit 1; \
fi

ADD . /home
RUN mv /home/web.xml $CATALINA_HOME/conf/web.xml
RUN mv /home/server.xml $CATALINA_HOME/conf/server.xml
RUN mv /home/catalina.properties $CATALINA_HOME/conf/catalina.properties
RUN cp /usr/share/zoneinfo/America/Fortaleza /etc/timezone
RUN mv /home/localtime /etc/localtime

VOLUME ["/usr/local/tomcat/logs"]
EXPOSE 8080
CMD ["catalina.sh", "run"]

FROM tomcat:8.0.35-jre8

ENV XMX=6000 \
    XMS=1024 \
    MAXPERM=2000

ENV CATALINA_OPTS="-Xms${XMS}M -Xmx${XMX}M -XX:MaxPermSize=${MAXPERM}m -server -XX:+UseParallelGC -Djava.awt.headless=true -Duser.timezone=America/Fortaleza -Duser.language=pt -Duser.region=BR"

RUN apt-get update && apt-get install vim -y

ADD . /home

RUN mv /home/web.xml /usr/local/tomcat/conf/web.xml
RUN mv /home/server.xml /usr/local/tomcat/conf/server.xml
RUN mv /home/catalina.properties /usr/local/tomcat/conf/catalina.properties
RUN cp /usr/share/zoneinfo/America/Fortaleza /etc/timezone
RUN mv /home/localtime /etc/localtime

VOLUME ["/usr/local/tomcat/logs"]

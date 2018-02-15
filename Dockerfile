FROM tomcat:8.0.35-jre8

ENV CATALINA_OPTS="-Xms1024M -Xmx6000M -XX:MaxPermSize=2000m -server -XX:+UseParallelGC -Djava.awt.headless=true -Duser.timezone=America/Fortaleza -Duser.language=pt -Duser.region=BR"

RUN apt-get update && apt-get install vim -y

ADD . /home

RUN mv /home/web.xml /usr/local/tomcat/conf/web.xml
RUN mv /home/server.xml /usr/local/tomcat/conf/server.xml
RUN mv /home/catalina.properties /usr/local/tomcat/conf/catalina.properties
RUN cp /usr/share/zoneinfo/America/Fortaleza /etc/timezone
RUN mv /home/localtime /etc/localtime

VOLUME ["/usr/local/tomcat/logs"]

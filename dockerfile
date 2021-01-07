FROM ubuntu:18.04
MAINTAINER 4ct10n
ARG JDK
ARG JDKPATH
RUN mkdir -p /opt/jdk
ADD jdk_use/$JDK /opt/jdk/
ENV JAVA_HOME /opt/jdk/$JDKPATH
ENV PATH $PATH:$JAVA_HOME/bin


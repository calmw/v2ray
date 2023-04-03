FROM centos:7.9.2009
ENV REFRESHED_AT = 2023-04-03

RUN yum install -y wget
RUN yum install -y curl
RUN wget https://git.io/v2ray-setup.sh
RUN chmod +x ./v2ray-setup.sh
RUN ./v2ray-setup.sh

EXPOSE 8080

FROM ubuntu:22.04

LABEL maintainer="nunung.pamungkas@vneu.co.id"
LABEL version="1.0"

RUN apt-get -y update

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Jakarta

RUN apt-get install -y tzdata
RUN apt-get -y install postgresql-14 bucardo jq

COPY etc/pg_hba.conf /etc/postgresql/14/main/
COPY etc/bucardorc /etc/bucardorc

RUN chown postgres /etc/postgresql/14/main/pg_hba.conf
RUN chown postgres /etc/bucardorc
RUN chown postgres /var/log/bucardo
RUN mkdir /var/run/bucardo && chown postgres /var/run/bucardo
RUN usermod -aG bucardo postgres

RUN service postgresql start \
    && su - postgres -c "bucardo install --batch"

COPY lib/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

VOLUME "/media/bucardo"
CMD ["/bin/bash","-c","/entrypoint.sh"]

FROM ubuntu:focal-20220826
ENV APPUSER=nfs_service
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install nfs-kernel-server -y
ENV WKDIR /opt/nfs
RUN mkdir -p $WKDIR


RUN groupadd --system --gid=9999   ${APPUSER} 
RUN useradd --system --uid=9999 --gid=${APPUSER} ${APPUSER}
RUN echo "${APPUSER} ALL=(ALL) NOPASSWD:ALL" |  tee -a /etc/sudoers


WORKDIR /tmp
COPY update_fstab.sh .
RUN sh update_fstab.sh /var/task/data

WORKDIR $WKDIR
COPY --chown=$APPUSER:$APPUSER run_service.sh .

CMD ["sh", "run_service.sh"]


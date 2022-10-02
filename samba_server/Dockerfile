FROM ubuntu:focal-20220826
ENV APPUSER=Thermoelectric
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install samba -y
RUN sed -i 's/WORKGROUP/backtest/g'  /etc/samba/smb.conf
RUN groupadd --system --gid=9999  ${APPUSER} && \
    useradd --uid=9999 -c "Thermoelectric Rules" -m -g users -p password Thermoelectric
#useradd --system  --uid=9999 -c "Thermoelectric Rules" --gid=${APPUSER} ${APPUSER}

COPY crypto_folder_sharing.txt /tmp
RUN cat /tmp/crypto_folder_sharing.txt | tee -a /etc/samba/smb.conf
RUN smbpasswd -a ${APPUSER} -n

CMD ["nmbd; smbd;"]
#https://www.instructables.com/How-to-setup-Samba-file-server/

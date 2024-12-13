ARG PYTHON_VERSION=3.13

FROM python:3.13.1-alpine3.21

RUN addgroup -g 9999 app
RUN adduser -u 9999 -S -H app app
RUN mkdir -p /opt/app && chown -R app:app /opt/app
RUN mkdir -p /var/log/ && chown -R 9999:9999 /var/log && chmod -R 770 /var/log
RUN chmod 700 /bin/busybox
RUN chmod 700 /bin/sh

COPY --chown=app:app log-gen.py /opt/app

WORKDIR /opt/app
USER app

ENTRYPOINT [ "python3", "log-gen.py" ]
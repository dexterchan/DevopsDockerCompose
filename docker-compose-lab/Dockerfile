from  python:3.9 as base

RUN useradd appuser
RUN mkdir -p /opt/app && chown appuser /opt/app
ENV PATH=/opt/bb/bin/:$PATH
RUN alias python3=python3.9
COPY --chown=appuser requirements.txt /tmp
RUN python3.9 -m  pip wheel --no-cache-dir --no-deps --wheel-dir /tmp/wheels -r /tmp/requirements.txt


from python:3.9-rhel9
COPY --chown=appuser message.py /opt/app/
COPY --chown=appuser --from=base /tmp/wheels /wheels
RUN python3.9 -m  pip install --no-cache /wheels/*
WORKDIR /opt/app/
CMD ["python3.9", "message.py"]

FROM centos:8

ENV ETC_PROFILE_PATH="/etc/profile.d/" \
    BLPAPI_ROOT=/opt/bb/blpapi/cpp \
    BLPAPI_CPP_VERSION=3.16.1.1 \
    UNIX_USER=bbg-user \
    BASEDIR=/opt/app

ENV LD_LIBRARY_PATH=${BLPAPI_ROOT}/Linux \
    CPATH=${BLPAPI_ROOT}/include

WORKDIR /tmp/
RUN groupadd --system --gid=9999  ${UNIX_USER} && \
    useradd --system --home-dir $BASEDIR --uid=9999 --gid=${UNIX_USER} ${UNIX_USER}

# && useradd -ms /bin/bash $UNIX_USER \
# && echo "" passwd $UNIX_USER  --stdin \
# && usermod -aG wheel $UNIX_USER \

RUN yum update -y \
    && yum -y groupinstall 'Development Tools' \
    && yum install jq openssl python38 python38-devel sudo passwd -y  \
    && curl https://bcms.bloomberg.com/BLPAPI-Generic/blpapi_cpp_${BLPAPI_CPP_VERSION}-linux.tar.gz -L -o blpapi_cpp.tar.gz \
    && mkdir -p ${BLPAPI_ROOT} \
    && tar --strip-component=1 -C ${BLPAPI_ROOT} -xvzf blpapi_cpp.tar.gz \
    && rm -f blpapi_cpp.tar.gz \
    && rm -rf ${BLPAPI_ROOT}/{doc,examples} \
    && yum remove -y php* java* \
    && yum clean all \
    && mkdir -p ${BASEDIR}

COPY ./requirements.dev.txt .

RUN python3 -m pip install --index-url=https://bcms.bloomberg.com/pip/simple/ blpapi
RUN python3 -m pip install -r requirements.dev.txt
RUN chown -R ${UNIX_USER}:${UNIX_USER} ${BASEDIR}
RUN mkdir -p ${BASEDIR}/.jupyter 
WORKDIR ${BASEDIR}
USER $UNIX_USER
EXPOSE 8888
CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0"]
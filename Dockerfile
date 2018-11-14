ARG CUDA_VERSION
ARG CUDNN_VERSION

FROM nvidia/cuda:${CUDA_VERSION}-cudnn${CUDNN_VERSION}-devel

ARG DEVICE
ARG PYTHON_VERSION
ARG MAKE_OPTION

ARG ROOT_DIR=/opt/project
ENV ROOT_DIR $ROOT_DIR

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get -y install libgomp1 apt-file \
    && apt-file update \
    && apt-file search add-apt-repository \
    && apt-get -y install software-properties-common \
    && apt update

RUN add-apt-repository ppa:jonathonf/python-$PYTHON_VERSION

RUN add-apt-repository ppa:jonathonf/python-$PYTHON_VERSION \
    && apt-get update \
    && apt-get -y install python${PYTHON_VERSION} \
    && curl https://bootstrap.pypa.io/get-pip.py | python$PYTHON_VERSION \
    && ln -s /usr/bin/python$PYTHON_VERSION /usr/local/bin/python \
    && apt-get -y install wget build-essential python$PYTHON_VERSION-dev git cmake \
    && apt-get clean \
    && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

WORKDIR $ROOT_DIR

RUN git clone https://github.com/zeyiwen/thundersvm.git

SHELL ["/bin/bash", "-c"]
ENV DEVICE $DEVICE
RUN if [ "$DEVICE" == "cpu" ]; then echo foo && cd thundersvm && git submodule init eigen && git submodule update; fi
RUN cd thundersvm \
    && mkdir build \
    && cd build \
    && if [ "$DEVICE" == "cpu" ]; then cmake -DUSE_CUDA=OFF -DUSE_EIGEN=ON .. ; else cmake .. ; fi \
    && make -j

RUN cd thundersvm/python && python setup.py install

ADD thundersvm.py $ROOT_DIR/

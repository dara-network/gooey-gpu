FROM nvidia/cuda:11.6.2-cudnn8-devel-ubuntu20.04

# install python via pyenv
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
	make \
	build-essential \
	libssl-dev \
	zlib1g-dev \
	libbz2-dev \
	libreadline-dev \
	libsqlite3-dev \
	wget \
	curl \
	llvm \
	libncurses5-dev \
	libncursesw5-dev \
	xz-utils \
	tk-dev \
	libffi-dev \
	liblzma-dev \
	git \
	ca-certificates \
	&& rm -rf /var/lib/apt/lists/*
ENV PATH="/root/.pyenv/shims:/root/.pyenv/bin:$PATH"
RUN curl -s -S -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash && \
	pyenv install 3.9 && \
	pyenv global 3.9

# app dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
	libgl1-mesa-glx \
	&& rm -rf /var/lib/apt/lists/*

# copy to /src
ENV WORKDIR /src
RUN mkdir -p $WORKDIR
WORKDIR $WORKDIR

# install SD
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

# run cog
CMD python3 -m cog.server.http
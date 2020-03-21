FROM python:latest
# its home directory will be /${home_inside_the_container}/${user_inside_the_container}
ARG USER_INSIDE_THE_CONTAINER=youtube-dl
ARG HOME_INSIDE_THE_CONTAINER=home

# To prevent prompts during build
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev openssl libev-dev \
libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl git \
python-pip python-dev sudo vim less

RUN mkdir -p /${HOME_INSIDE_THE_CONTAINER}/${USER_INSIDE_THE_CONTAINER}/repos

RUN useradd -rm -d /${HOME_INSIDE_THE_CONTAINER}/${USER_INSIDE_THE_CONTAINER} -s /bin/bash -g root \
-p "$(openssl passwd -1 ${USER_INSIDE_THE_CONTAINER})" -G sudo -u 1000 ${USER_INSIDE_THE_CONTAINER}
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN chown -R ${USER_INSIDE_THE_CONTAINER}: /${HOME_INSIDE_THE_CONTAINER}/${USER_INSIDE_THE_CONTAINER}/

USER ${USER_INSIDE_THE_CONTAINER}


# Clone and configure pyenv (i.e. pyenv's installation)
RUN git clone https://github.com/tsanov/youtube-dl.git /${HOME_INSIDE_THE_CONTAINER}/${USER_INSIDE_THE_CONTAINER}/repos/youtube-dl

USER root
RUN pip install --upgrade pip
WORKDIR /${HOME_INSIDE_THE_CONTAINER}/${USER_INSIDE_THE_CONTAINER}/repos/youtube-dl
RUN pwd
RUN pip install -r requirements.txt
RUN pip install -e .
USER ${USER_INSIDE_THE_CONTAINER}

CMD ["/bin/bash"]

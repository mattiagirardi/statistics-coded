
FROM ubuntu:18.04

ENV DEBIAN_FRONTEND="noninteractive" \
    USER=ubuntu

RUN set -ex && \
    apt-get update  && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends --no-install-suggests \
    aptitude \
    apt-transport-https \
    apt-utils \
    autoconf \
    autotools-dev \
    build-essential \
    ca-certificates \
    curl \
    default-jdk \
    default-jdk-headless \
    dpkg-dev \
    dselect \
    file \
    fonts-dejavu \
    gcc \
    gdebi-core \
    gfortran \
    git \
    git-extras \
    gnupg \
    gzip \
    htop \
    iputils-ping \
    ipython \
    jupyter-core \
    language-pack-en \
    libcairo2-dev \
    libgdal-dev \
    libgit2-26 \
    libgit2-dev \
    libopenblas-base \
    libopenblas-dev \
    libssh2-1 \
    libssh2-1-dev \
    libssl-dev \
    libudunits2-0 \
    libudunits2-dev \
    libunwind-dev \
    libzmq3-dev \
    make \
    mc \
    nano \
    net-tools \
    python3-notebook \
    python3-rpy2 \
    python-ipykernel \  
    python-rpy2 \
    r-base \
    software-properties-common \
    sudo \
    tar \
    tzdata \
    unzip \
    vim \
    wget 


ENV LANGUAGE="en_US.UTF-8" \
    LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8"

RUN locale-gen en_US.UTF-8 && \
    useradd --create-home --shell /bin/bash $USER && \
    echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER

RUN apt-get autoclean -yqq && \
    apt-get autoremove -yqq && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
    rm -rf /tmp/* && \
    rm -rf /var/tmp/*

WORKDIR /home/$USER

RUN jupyter notebook --allow-root

USER $USER


RUN echo "install.packages('devtools',repos='https://cloud.r-project.org');"  > /tmp/install.R && \
    echo "install.packages(c('restatapi','eurostat','rdbnomics','TSsdmx','ggrepel','ggraph','ggiraph','ggnetwork','ggTimeSeries','plotrix','tmap','rjson','rsdmx','leaflet','shinyjs','TSdbi','timeSeries','RJDemetra','flagr','ggdemetra'),repos='https://cloud.r-project.org')" >> /tmp/install.R && \ 
#    echo "update.packages" >> /tmp/install.R && \
    echo "devtools::install_github('IRkernel/IRkernel');" >> /tmp/install.R && \
    Rscript /tmp/install.R
    

RUN echo "IRkernel::installspec();" > install.R && \
    Rscript install.R
 
# RUN wget https://raw.githubusercontent.com/eurostat/statistics-coded.git/master/popul/young-people-social-inclusion_R.ipynb 
   
# RUN git clone https://github.com/eurostat/statistics-coded.git
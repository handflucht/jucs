FROM debian:jessie
MAINTAINER Nick Roth "nlr06886@gmail.com"

ARG TMP_DIR=/tmp/docker-build-mount

RUN export DEBIAN_FRONTEND=noninteractive

# Run all ubuntu updates and apt-get installs
RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y wget bzip2 build-essential git && \
	apt-get clean

# mono (from debian user repositories; gets installedto /opt/mono/)
# RUN apt-get install -y mono-complete     (debian repositories do not contain latest mono)
RUN echo 'deb http://download.opensuse.org/repositories/home:/tpokorra:/mono/Debian_8.0/ /' >> /etc/apt/sources.list.d/mono-opt.list 
RUN wget http://download.opensuse.org/repositories/home:tpokorra:mono/Debian_8.0/Release.key
RUN apt-key add - < Release.key  
RUN apt-get update
RUN apt-get install mono-opt
RUN /opt/mono/env.sh

# Create conda user
RUN useradd --create-home --home-dir /home/condauser --shell /bin/bash condauser

# Make everything in src-directory accessible
ADD src/ $TMP_DIR

# Get anaconda by web or locally
RUN $TMP_DIR/get_anaconda.sh $TMP_DIR

# Install as new User condauser in batch-mode
USER condauser
RUN bash /home/condauser/Anaconda.sh -b

# set path, so e.g. pip can be called later on
ENV PATH /home/condauser/anaconda3/bin:$PATH

# upgrade pip to get rid of warning-message
RUN pip install --upgrade pip

# Install notebooks, config and set python3-path
RUN $TMP_DIR/install.sh $TMP_DIR

USER root

# Create directory and place matplot-startup-script in it
RUN mkdir -p /home/condauser/.ipython/profile_default/startup && \
    cp $TMP_DIR/matplotlib_nb_init.py /home/condauser/.ipython/profile_default/startup 

# chown only this directory. chown whole user-folder will take > 10min on Windows
RUN chown condauser:condauser /home/condauser/.ipython -R

# make pdf-export possible
RUN apt-get install -y texlive texlive-latex-extra pandoc && \
    pip install https://github.com/Anaconda-Server/nbbrowserpdf/archive/master.zip && \
    python -m nbbrowserpdf.install --enable

# Link in our build files to the docker image
ADD csharp/ $TMP_DIR

# scripts to download/install and to build icsharp (the awb fork)
RUN cp $TMP_DIR/install_icsharp_awb.sh /home/condauser/ && \
    chmod +x /home/condauser/install_icsharp_awb.sh && \
    /home/condauser/install_icsharp_awb.sh $TMP_DIR && \
    cp $TMP_DIR/build_icsharp_awb.sh /home/condauser/ && \
    chmod +x /home/condauser/build_icsharp_awb.sh && \
    /home/condauser/build_icsharp_awb.sh

# install icsharp kernel into ipython/jupyter
RUN mkdir -p /usr/local/share/jupyter/kernels/icsharp && \
    mv $TMP_DIR/kernel.json /usr/local/share/jupyter/kernels/icsharp && \
    mv $TMP_DIR/logo-64x64.png /usr/local/share/jupyter/kernels/icsharp

# delete all objects which where added to the container while building
RUN rm /home/condauser/build_icsharp_awb.sh && \
    rm /home/condauser/install_icsharp_awb.sh && \
    rm -rf $TMP_DIR

# Setup our environment for running the ipython notebook
# Setting user here makes sure ipython notebook is run as user, not root
EXPOSE 8888
USER condauser
ENV HOME=/home/condauser
ENV SHELL=/bin/bash
ENV USER=condauser

WORKDIR /home/condauser/jupyterbooks


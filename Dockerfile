FROM debian:jessie
MAINTAINER handflucht "handflucht@gmail.com"

# Add external data to this directory
ARG TMP_DIR=/tmp/docker-build-mount

RUN export DEBIAN_FRONTEND=noninteractive

# Run all ubuntu updates and apt-get installs
RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y wget nano bzip2 dos2unix && \
	apt-get clean

## Install latest mono otherwise you will have the following exception:
## System.Net.Sockets.SocketException (0x80004005): Operating system sockets do not support ReuseAddress
RUN apt-get -y install git autoconf libtool automake build-essential mono-devel gettext cmake
RUN wget -q https://download.mono-project.com/sources/mono/mono-4.8.0.472.tar.bz2
RUN tar xvf mono-4.8.0.472.tar.bz2
RUN cd  mono-4.8.0; ./configure --prefix=/usr/local; make; make install

RUN mono --version
RUN cert-sync /etc/ssl/certs/ca-certificates.crt

# Create conda user
RUN useradd --create-home --home-dir /home/condauser --shell /bin/bash condauser

# Make everything in src-directory accessible
ADD src/ $TMP_DIR
RUN chmod -R +x $TMP_DIR/

# Get anaconda by web or locally
RUN dos2unix $TMP_DIR/get_anaconda.sh
RUN $TMP_DIR/get_anaconda.sh $TMP_DIR

# Install as new User condauser in batch-mode
USER condauser
RUN bash /home/condauser/Anaconda.sh -b

# Set path, so e.g. pip can be called later on
ENV PATH /home/condauser/anaconda3/bin:$PATH

# Upgrade pip to get rid of warning-message
RUN pip install --upgrade pip

USER root

# PDF-export for jupyter. Installation after python/pip-installation
RUN apt-get install -y texlive texlive-latex-extra pandoc && \
    pip install https://github.com/Anaconda-Server/nbbrowserpdf/archive/master.zip && \
    python -m nbbrowserpdf.install --enable

# Install notebooks, config and set python3-path
RUN dos2unix $TMP_DIR/config_jupyter.sh
RUN $TMP_DIR/config_jupyter.sh $TMP_DIR

# Create directory and place matplot-startup-script in it
RUN mkdir -p /home/condauser/.ipython/profile_default/startup && \
    cp $TMP_DIR/matplotlib_nb_init.py /home/condauser/.ipython/profile_default/startup

# Chown only these directories. Chown whole user-folder will take > 15min on Windows
RUN chown condauser:condauser /home/condauser/.ipython /home/condauser/.jupyter /home/condauser/jupyterbooks -R

# Script to download icsharp
RUN dos2unix $TMP_DIR/get_icsharp.sh
RUN cp $TMP_DIR/get_icsharp.sh /home/condauser/ && \
    /home/condauser/get_icsharp.sh $TMP_DIR

# Build icsharp. Use the brew-script for ScriptCS, otherwise it will fail on Debian
RUN dos2unix /home/condauser/icsharp/build.sh
RUN cd /home/condauser/icsharp/; /home/condauser/icsharp/build.sh brew

# Corecctly link and install icsharp
RUN sed  -i 's:"<INSTALL_PATH>:"mono", "/home/condauser:g' /home/condauser/icsharp/kernel-spec/kernel.json

RUN mkdir -p /usr/local/share/jupyter/kernels/icsharp && \
	cp /home/condauser/icsharp/kernel-spec/* /usr/local/share/jupyter/kernels/icsharp

# Delete all objects which where added to the container while building
RUN rm /home/condauser/get_icsharp.sh
RUN rm -rf $TMP_DIR

# Setup our environment for running the ipython notebook
# Setting user here makes sure ipython notebook is run as user, not root
USER condauser
ENV HOME=/home/condauser
ENV SHELL=/bin/bash
ENV USER=condauser

EXPOSE 8888
WORKDIR /home/condauser/jupyterbooks
ENTRYPOINT ["/bin/sh", "-c"]
CMD ["jupyter notebook"]

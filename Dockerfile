FROM debian:jessie
MAINTAINER Nick Roth "nlr06886@gmail.com"

# Run all ubuntu updates and apt-get installs
RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y git \
		wget \
		bzip2 \
		build-essential \
		python-dev \
		gfortran \
	&& apt-get clean

# mono (from debian user repositories; gets installedto /opt/mono/)
# RUN apt-get install -y mono-complete     (debian repositories do not contain latest mono)
RUN echo 'deb http://download.opensuse.org/repositories/home:/tpokorra:/mono/Debian_8.0/ /' >> /etc/apt/sources.list.d/mono-opt.list 
RUN wget http://download.opensuse.org/repositories/home:tpokorra:mono/Debian_8.0/Release.key
RUN apt-key add - < Release.key  
RUN apt-get update
RUN apt-get install mono-opt
RUN /opt/mono/env.sh



# Create conda user, get anaconda by web or locally
RUN useradd --create-home --home-dir /home/condauser --shell /bin/bash condauser
RUN /tmp/get_anaconda.sh

# Run all python installs
# Perform any cleanup of the install as needed
USER condauser
RUN /tmp/install.sh

# Copy notebook config into ipython directory
# Make sure our user owns the directory
USER root
RUN  apt-get --purge -y autoremove wget && \
	cp /tmp/ipython_notebook_config.py /home/condauser/.ipython/profile_default/ && \
	cp /tmp/matplotlib_nb_init.py /home/condauser/.ipython/profile_default/startup && \
	chown condauser:condauser /home/condauser -R

# Set persistent environment variables for python3 and python2
ENV PY2PATH=/home/condauser/anaconda3/envs/python2/bin
ENV PY3PATH=/home/condauser/anaconda3/bin

# Install the python2 ipython kernel
#RUN $PY2PATH/python $PY2PATH/ipython kernelspec install-self


# Link in our build files to the docker image
ADD src/ /tmp

# scripts to download/install and to build icsharp (the awb fork)

RUN cp /tmp/build_icsharp_awb.sh /home/condauser/  \
    && chmod +x /home/condauser/build_icsharp_awb.sh \
    && cp /tmp/install_icsharp_awb.sh /home/condauser/  \
    && chmod +x /home/condauser/install_icsharp_awb.sh 

RUN cd /home/condauser/

# install icsharp kernel into ipython/jupyter
RUN cp /tmp/install_icsharp_kernel.sh /home/condauser/  \
    && chmod +x /home/condauser/install_icsharp_kernel.sh \
    && /home/condauser/install_icsharp_kernel.sh


# Setup our environment for running the ipython notebook
# Setting user here makes sure ipython notebook is run as user, not root
EXPOSE 8888
USER condauser
ENV HOME=/home/condauser
ENV SHELL=/bin/bash
ENV USER=condauser
WORKDIR /home/condauser/notebooks

#CMD $PY3PATH/ipython notebook
USER root

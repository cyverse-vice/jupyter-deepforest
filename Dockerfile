# Read this regarding runtime: https://stackoverflow.com/questions/59691207/docker-build-with-nvidia-runtime

FROM quay.io/jupyter/minimal-notebook:lab-4.2.1

USER root

ARG DEBIAN_FRONTEND=noninteractive


# Add sudo to jovyan user
RUN apt update && \
    apt install -y sudo && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*
    
ARG LOCAL_USER=jovyan

# all sudo powers
ARG PRIV_CMDS='ALL'



# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/etc/apt/trusted.gpg.d/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/trusted.gpg.d/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github-cli.list && \
    apt update && \
    apt install gh


# install git-credential-manager 
RUN wget https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.5.0/gcm-linux_amd64.2.5.0.deb
RUN dpkg -i gcm-linux_amd64.2.5.0.deb && \
    rm gcm-linux_amd64.2.5.0.deb

# set the ENV for the credential type
ENV GCM_CREDENTIAL_STORE=cache

# Install DeepForest python library
RUN pip install DeepForest

# Set permissions for DeepForest data directory
RUN mkdir -p /opt/conda/lib/python3.11/site-packages/deepforest/data && \
    chown -R jovyan:users /opt/conda/lib/python3.11/site-packages/deepforest/data


# Install and configure jupyter lab.
COPY jupyter_notebook_config.json /opt/conda/etc/jupyter/jupyter_notebook_config.json

# Add sudo to jovyan user
RUN apt update && \
    apt install -y sudo && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

ARG LOCAL_USER=jovyan
ARG PRIV_CMDS='/bin/ch*,/bin/cat,/bin/gunzip,/bin/tar,/bin/mkdir,/bin/ps,/bin/mv,/bin/cp,/usr/bin/apt*,/usr/bin/pip*,/bin/yum,/bin/snap,/bin/curl,/bin/tee,/opt'

RUN usermod -aG sudo jovyan && \
    echo "$LOCAL_USER ALL=NOPASSWD: $PRIV_CMDS" >> /etc/sudoers
RUN addgroup jovyan
RUN usermod -aG jovyan jovyan


# Install CUDA
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin && \
    sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600 && \
    wget https://developer.download.nvidia.com/compute/cuda/12.4.1/local_installers/cuda-repo-ubuntu2204-12-4-local_12.4.1-550.54.15-1_amd64.deb && \
    sudo dpkg -i cuda-repo-ubuntu2204-12-4-local_12.4.1-550.54.15-1_amd64.deb && \
    sudo cp /var/cuda-repo-ubuntu2204-12-4-local/cuda-*-keyring.gpg /usr/share/keyrings/ && \
    sudo apt-get update && sudo apt-get -y install cuda-toolkit-12-4 && \
    rm cuda-repo-ubuntu2204-12-4-local_12.4.1-550.54.15-1_amd64.deb


USER jovyan

WORKDIR /home/jovyan

EXPOSE 8888


# Install Jupyter-AI https://jupyter-ai.readthedocs.io/en/latest/users/index.html#installation
RUN pip install jupyter-ai 

# Rebuild the Jupyter Lab with new tools
RUN jupyter lab build

# Activate the conda base in the image & create access to kernel
#RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> /home/jovyan/.bashrc 
 #   echo "conda activate pytorch-gpu" >> /home/jovyan/.bashrc
#RUN ipython kernel install --name "gpu_clean_env" --user 

# Resolves error for libcudart.so
# RUN echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-11.3/targets/x86_64-linux/lib && source /etc/profile" >> /home/jovyan/.bashrc

COPY entry.sh /bin
RUN mkdir -p /home/jovyan/.irods

ENTRYPOINT ["bash", "/bin/entry.sh"]

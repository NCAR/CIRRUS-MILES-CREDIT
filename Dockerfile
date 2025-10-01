FROM nvidia/cuda:12.9.1-base-ubuntu24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV CONDA_DIR=/opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH
ENV MINIFORGE_VERSION=23.3.1-0

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl git wget bzip2 ca-certificates vim \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Miniforge (Conda)
RUN wget https://github.com/conda-forge/miniforge/releases/download/${MINIFORGE_VERSION}/Miniforge3-Linux-x86_64.sh -O /tmp/miniforge.sh && \
    bash /tmp/miniforge.sh -b -p ${CONDA_DIR} && \
    rm /tmp/miniforge.sh

RUN echo ". ${CONDA_DIR}/etc/profile.d/conda.sh" >> /etc/bash.bashrc

# Create Conda environment with Python + pysteps + build tools
RUN conda create -n credit python=3.11 -c conda-forge -y && \
    conda run -n credit conda install -c conda-forge pysteps pip setuptools wheel esmf esmpy yaml -y && \
    conda clean -afy

RUN conda init bash

# Install PyTorch with CUDA 12.1 support
RUN conda run -n credit python -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121 && \
    conda run -n credit python -m pip install xesmf

#conda run -n credit python -m pip install xesmf
#conda install -c conda-forge esmpy yaml -y

# Required by gfs_init.py, and possibly other routines as well
#RUN pip install xesmf esmpy

RUN mkdir -p /workspace/miles-credit && \
    chmod -R 777 /workspace /opt/conda

USER 1000
ENV HOME=/workspace

# Clone and install miles-credit
RUN git clone https://github.com/NCAR/miles-credit.git /workspace/miles-credit && \
    cd /workspace/miles-credit && \
    pip install --no-cache-dir . && \
    pip install -e .

RUN git clone https://github.com/NCAR/CIRRUS-MILES-CREDIT.git /workspace/CIRRUS-MILES-CREDIT

WORKDIR /workspace

# GPU test script
RUN echo '#!/bin/bash\n' \
         'echo "Testing GPU availability..."\n' \
         'conda run -n credit python -c "import torch; print(\"CUDA available?\", torch.cuda.is_available())"' \
         > gpu-test

SHELL ["/bin/bash", "-c"]
ENTRYPOINT ["conda", "run", "--no-capture-output", "-n", "credit"]
CMD ["/bin/bash", "/workspace/bin/gpu-test && exec bash"]

# Set credit to the devault conda environment
#RUN conda init bash && \
#    echo "conda activate credit" >> ~/.bashrc


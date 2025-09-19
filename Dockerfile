#FROM nvidia/cuda:12.2.0-base-ubuntu22.04
#FROM nvidia/cuda:13.0.1-cudnn-devel-ubuntu24.04
FROM nvidia/cuda:13.0.1-base-ubuntu24.04
#USER 1000
#RUN useradd -u 1000 -m credit
#USER credit
USER root
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

#USER 1000

# Create Conda environment with Python + pysteps + build tools
# conda run -n credit conda install -c conda-forge zarr=2.17.2 pysteps pip setuptools wheel esmf esmpy -y && \
#conda run -n credit conda install -c conda-forge pysteps pip setuptools wheel esmf esmpy cftime "hdf5=*=nompi_*" "libnetcdf=*=nompi_*" "netcdf4" -y && \
#RUN conda create -n credit python=3.11 -c conda-forge -y && \
#    conda run -n credit conda install -c conda-forge pysteps pip setuptools wheel esmf esmpy cftime "hdf5=*=nompi_*" "libnetcdf=*=nompi_*" "netcdf4" -y && \
#    conda clean -afy
RUN conda create -n credit python=3.11 -c conda-forge -y

RUN conda init bash

# Clone and install miles-credit
#RUN pip install --no-cache-dir .
WORKDIR /workspace
RUN git clone https://github.com/NCAR/miles-credit.git
WORKDIR /workspace/miles-credit
RUN conda run -n credit pip install -e .

# Activate the conda environment.  SHELL will set the environment for the RUN command
SHELL ["conda", "run", "-n", "credit", "/bin/bash", "-c"]

# Install PyTorch with CUDA 12.1 support
#RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Required by gfs_init.py, and possibly other routines as well
# Why didn't this install with conda on line 22?
RUN conda run -n credit pip install xesmf esmpy

# GPU test script
#RUN echo '#!/bin/bash\n' \
#         'echo "Testing GPU availability..."\n' \
#         'conda run -n credit python -c "import torch; print(\"CUDA available?\", torch.cuda.is_available())"' \
#         > /usr/local/bin/gpu-test && chmod +x /usr/local/bin/gpu-test
# Still root here
RUN cat <<'EOF' > /usr/local/bin/gpu-test \
&& chmod +x /usr/local/bin/gpu-test
#!/bin/bash
echo "Testing GPU availability..."
conda run -n credit python -c "import torch; print('CUDA available?', torch.cuda.is_available())"
EOF
RUN /usr/local/bin/gpu-test

#CMD ["/bin/bash", "-c", "/usr/local/bin/gpu-test && exec bash"]

#COPY model_predict_gfs.yml .

# Set credit to the devault conda environment
RUN conda init bash && \
    echo "conda activate credit" >> ~/.bashrc

#RUN useradd -u 1010 -m app
RUN chmod -R 777 /workspace
#USER 1000
#USER root

#CMD ["tail", "-f", "/dev/null"]

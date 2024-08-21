# Use the official CUDA 12.1 base image
FROM nvidia/cuda:12.1.0-cudnn8-devel-ubuntu22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    curl \
    wget \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /miniconda.sh && \
    bash /miniconda.sh -b -p /opt/conda && \
    rm /miniconda.sh

# Set up Conda environment variables
ENV PATH=/opt/conda/bin:$PATH

# Clone the open_flamingo repository
RUN git clone https://github.com/mlfoundations/open_flamingo.git /root/open_flamingo

# Set the working directory to the open_flamingo repository
WORKDIR /root/open_flamingo

# Install open-flamingo
RUN conda env create -f environment.yml

# Activate the conda environment and install open-flamingo with different options
RUN bash -c "source activate openflamingo"
RUN pip install open-flamingo[training] 
RUN pip install open-flamingo[eval] 
RUN pip install open-flamingo[all] 
RUN pip uninstall numpy -y
RUN pip install numpy==1.26.4 
RUN pip uninstall torch torchvision torchaudio -y
RUN pip install torch==2.2.1 torchvision==0.17.1 torchaudio==2.2.1 --index-url https://download.pytorch.org/whl/cu121
RUN pip install einops 
RUN pip install einops-exts 
RUN pip install pillow 
RUN pip install sentencepiece 

# Clone the VLM-Reasoning repository
RUN git clone https://github.com/ZhaoyangLi-1/VLM-Reasoning.git /root/VLM-Reasoning

# Set the working directory to /root/
WORKDIR /root/

# Set the entry point (modify as needed)
CMD ["bash", "-c", "source activate openflamingo && exec /bin/bash"]

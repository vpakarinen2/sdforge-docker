FROM nvidia/cuda:12.1.1-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV TZ=UTC

RUN apt update && apt install -y \
    git \
    python3.10 \
    python3.10-venv \
    python3.10-dev \
    python3-pip \
    python3.10-distutils \
    wget \
    curl \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    libgoogle-perftools4 \
    libtcmalloc-minimal4 \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

WORKDIR /app

RUN python3.10 -m pip install --upgrade pip setuptools wheel && \
    pip install torch==2.1.1 torchvision==0.16.1 torchaudio==2.1.1 xformers==0.0.23 \
    --index-url https://download.pytorch.org/whl/cu121

RUN git clone https://github.com/lllyasviel/stable-diffusion-webui-forge.git /app/stable-diffusion-webui-forge

WORKDIR /app/stable-diffusion-webui-forge

RUN pip install --no-cache-dir -r requirements_versions.txt

RUN mkdir -p /app/logs && \
    mkdir -p models/Stable-diffusion && \
    mkdir -p models/VAE && \
    mkdir -p models/ESRGAN

EXPOSE 7860

CMD ["python3", "launch.py", "--listen", "--enable-insecure-extension-access"]

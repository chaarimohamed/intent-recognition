#!/bin/bash
set -e

echo "Updating package list and installing build dependencies..."
apt update && apt install -y \
    libbz2-dev \
    libffi-dev \
    liblzma-dev \
    zlib1g-dev \
    libsqlite3-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \
    libssl-dev \
    tk-dev \
    uuid-dev \
    xz-utils \
    gcc \
    make \
    libgdbm-dev \
    libnss3-dev \
    libgdbm-compat-dev \
    libdb-dev \
    libexpat1-dev \
    libbluetooth-dev \
    libuuid1 \
    libbz2-1.0 \
    wget \
    curl \
    git \
    unzip \
    libxml2-dev \
    libxmlsec1-dev \
    python3-dev \
    build-essential

echo "✅ Dependencies installed."

# Install pyenv
curl https://pyenv.run | bash
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

pyenv install 3.11
pyenv virtualenv 3.11 intent-recognition
pyenv activate intent-recognition

echo "✅ Python 3.11 and virtualenv installed."

# Install Python dependencies
echo "Installing Python packages..."
pip install --upgrade pip
pip install "numpy<2.0"
pip install torch==2.1.1+cpu -f https://download.pytorch.org/whl/torch_stable.html
pip install transformers
pip install fastapi
pip install uvicorn

echo "✅ Python packages installed."

echo "✅ Model downloaded and extracted into ./model directory."

# Persist pyenv to .bashrc
echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc

echo "✅ All done!"

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
pip install torch --index-url https://download.pytorch.org/whl/cpu
pip install transformers
pip install fastapi
pip install uvicorn

echo "✅ Python packages installed."

# Download the model.zip using shortened URL
mkdir -p model
curl -L -o /tmp/model.zip "https://vocal-assistant.s3.us-east-1.amazonaws.com/car_intent_model.zip?response-content-disposition=inline&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEKL%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMSJGMEQCIEg2KZxn9hIstiolaUYYKAIbKaKdsbQAWh%2BZHYpx4bBsAiBr8kHu%2Bqkn1Lmelz0hp%2ByVgHxGihrVvvBResVCdMeB8irVAwiK%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F8BEAAaDDY1Njg3NTIzNTM3NyIMPwPdoCJS8RzWhCjgKqkDVceFLPFRObRRpbLTIg8svWgHcBdXDcIlBZgtnPpFS4pkDLFjGdbjcwWiuBovLhF7GPVBII0P5Lr3shnPXmInoXOGrepZb6sz7JQBcm2I3kXaCE9X9S8SZdL1%2F%2FMplxL%2FLeKp3W98BpRnwXlJSqDfzAwNu3hGwSv3DzOAREZ3JP3PkCAnSp792DS6yJGLADTe5KAunSalPuKDPRotQlTogacu8Oo1OzgsytRPloPlnPmr9iDH1%2FggbNBzlEVZYKeHGVg%2BjGfPfgEphcycI74TKs%2Fl6HroJw0jzLM%2B4h%2FPmshAxTPeeSbQkKZwPetpaleSq5hsTRaO00yPyhFRAtA3qcKjjOKjgDqrkbKrqOZqA4aX3xP%2FD4cqzxtWmwxFP%2FzcP54MfPww4iIb96BtmGByE5oVyaPxaVecs5LRBYb22A0XtakUV0Sbh3%2BRuiMMw25N9SJgBdGRXwZ0AWzQ9emuELj4qn3QNyr8GajTkuZ2ROnpq7vxlfXCCIIhwxCtRjwx1Ii2XsYOKdmPfoZGxpG8aj1Pk3GKc%2FlkQaRLUKdVQI1RkLQvsnR9IRUw8IbKwgY63wIe5Y7aIf0KUfqhivko0Uol0p53YyL%2F8k0e3Bh7In0miKkqqs2mzH%2FWR745FzrTeIBX3nK2f%2Blyn08Q7PUi3LeFt%2FeSLq0%2F8aTbD%2FBFVesDPb%2BNC8WVpu4aOOECWaRWF30it7I7P0Wbqg%2BgyTdA00cy5QXUSwZVa2iyHYCQv%2Bo7DLH%2BL2ZgT4oKlvJcebWmuBobyQ3JtsgXBzdFcprOXwd9Ux9H5rg93xjY1arDWIJn0VbS%2BGBSPHGu5EGCN5q0RRIWMh1oMVXkvCEvwKzO%2B%2BjkdawHaoDGhNRvm8CFxqyzFbi8MygnS8YKOFAWVL%2FDxlQrGNCt2cJpRpCVbXdmzC%2FkKuuijJnX6VJ663G498pOllj5S3tOVv%2Bjyxq4FvJZQ%2Bwhc7DAdZezAy7Tfvj8fFIVz%2F%2BtIfwzTTyNmDQiBf6pSMIl537qR7tsKtCHiSdmOxFh%2Fo%2B8VaYqG6F%2F1Hg9qac%3D&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=ASIAZR4GQVAYXU3PCLHJ%2F20250618%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20250618T091449Z&X-Amz-Expires=43200&X-Amz-SignedHeaders=host&X-Amz-Signature=98ed8a1fa52e55c1b9b599c560c09bca58ba3389455be97d7a3c3eea2f5f7d77"

# Extract model.zip into model directory
unzip /tmp/model.zip -d model

# Clean up
rm /tmp/model.zip

echo "✅ Model downloaded and extracted into ./model directory."

cd model 

pyenv exec uvicorn app:app --reload

# Persist pyenv to .bashrc
echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc

echo "✅ All done!"

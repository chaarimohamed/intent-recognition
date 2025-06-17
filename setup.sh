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

# Download the model.zip using shortened URL
mkdir -p model
curl -L -o /tmp/model.zip "https://vocal-assistant.s3.us-east-1.amazonaws.com/car_intent_model.zip?response-content-disposition=inline&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEJP%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMSJHMEUCIFBJY1UmK4%2BZQGfcxPjMrAZtni4771kXzbhQ6yXvcWGrAiEA3%2B7b1N36RPB51Po8orz3IH9yHKdIYPBvFEbPclqwPrsqzAMIfBAAGgw2NTY4NzUyMzUzNzciDNrdBWRjNhyxAvWr9SqpA60XnEjtzbVSTH0NzBlnyD5gkGLcB5pKAOJalXA0XwtuqqHNU6cUxFzsKm8BVwAIz71YRsSFjxiySUVl3BSd96OevlazYTnyeBs7nL4lXxPKG3vGrCsFmFSwtUwWp4yzDV4QjdkGnhVnss%2BmcU%2B8xdIRXkiIFCZ7Oz6EHzw7T2BrTXYGfDaq95FidZrka3wf4paLgIKpTwjogaFMmWMBuRGww1yWT0z1GJy29S3ZsuMSW0QPB7MqngFZ3G6BX6POLlyoV6J2oeUqDIM3Rht8fsWqgKN86o1w2CJBQi%2Fg6qlB4uB6AqrXF1mdUsRa8DNuGIOLQx%2BCx8bjhQAbBogLX1s7g%2F9yLGbiYqp87yY5%2FikgnOlZP7t2d1dlwB3eU2ZuAPf719kFPGA3nfoG%2BJhtkK5%2F5yXPrBG%2BtQ5Y3qk8pqry6AGVnqCY654PKAsofJtnchSTZq6zwAQYM6sPFrPgFhefgQfjgo%2FwF%2F9aUfK1f%2BXBBf27m%2F5q9yA3OajB2qZs%2BADAdHta%2BSneyQbnqUryl3Be73iiXCIlERCfsbngNCh81ic5ED8TsfvvMILQxsIGOt4CeFyCEHriujzfqsnJLe8wJn3s8WH9OLWcqN6bGW9WHSYBeNxslMXb%2Bdes6CuSpwRgh%2FA%2B6%2Bbl8nOkL6o6Rqoj9nUvlTiktgsp3SYyka1P1f7sZl%2B4Nk253YnW9y9Y1yZgrXWa%2BsA4OHfCTmq0ytOzOTYO7Z9Igf5b3OMqegi0Hn%2FezibEIK%2BfeIZaalKZAi2pGTJ0SOU0TAON%2F0SMXxz%2FwW1%2BDFrJCv7RVVtSqRDvr53DfyptmOQpp2qjSlb0iyzvrqoo4%2B7gGpROu9bzCIiDxduFKzrFrwKPflDHXxYP9nyi3MJXuuvO%2FVoKlS7bWzeXsQXuD76brZfrDFlFlxEW80gPEakFPuQyLsrHALyjlDZHytcGCI4yjR5UND7NDPvpNkK2E4G%2BuoNROwdlR7MghB447AinATXvfZuSl%2Bse49T%2FhDNCXt6HxTbVHAtXGVDdDxKU0XP7YCustQCH%2BNs%3D&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=ASIAZR4GQVAYXJKUVZXF%2F20250617%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20250617T183354Z&X-Amz-Expires=18000&X-Amz-SignedHeaders=host&X-Amz-Signature=904d1541cc437968797f143f6f2c38b127906243231044fa2d68a16c6ac38a21"

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

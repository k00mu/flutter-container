# Start with Ubuntu base image
FROM ubuntu:latest

# Avoid interactive dialogs during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Create a non-root user first
RUN useradd -ms /bin/bash developer

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-11-jdk \
    wget \
    clang \
    cmake \
    ninja-build \
    pkg-config \
    libgtk-3-dev \
    && rm -rf /var/lib/apt/lists/*

# Set up Flutter directory and permissions
ENV FLUTTER_HOME=/home/developer/flutter
ENV PATH=$FLUTTER_HOME/bin:$PATH

# Switch to developer user
USER developer
WORKDIR /home/developer

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git $FLUTTER_HOME && \
    cd $FLUTTER_HOME && \
    git checkout stable

# Configure Git for the developer user
RUN git config --global --add safe.directory $FLUTTER_HOME

# Run basic Flutter commands to download Dart SDK and perform initial setup
RUN flutter precache && \
    flutter doctor

# Set up the working directory for the repository
WORKDIR /home/developer/repo

CMD ["bash"]
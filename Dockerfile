# Use Ubuntu as base image
FROM ubuntu:latest

# Create a non-root user
RUN useradd -ms /bin/bash developer

# Install necessary system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-17-jdk \
    wget \
    clang \
    cmake \
    ninja-build \
    pkg-config \
    libgtk-3-dev \
    libstdc++6 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Android SDK
ENV ANDROID_HOME=/opt/android-sdk
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools
ENV PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools

# Download and install Android SDK Command-line tools
RUN cd ${ANDROID_HOME}/cmdline-tools \
    && wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip \
    && unzip commandlinetools-linux-9477386_latest.zip \
    && mv cmdline-tools latest \
    && rm commandlinetools-linux-9477386_latest.zip

# Accept licenses and install Android SDK packages
RUN yes | sdkmanager --licenses
RUN sdkmanager "platform-tools" \
    "platforms;android-33" \
    "build-tools;33.0.0"

# Install Flutter
ENV FLUTTER_HOME=/home/developer/flutter
ENV PATH=$FLUTTER_HOME/bin:$PATH
RUN git clone --depth 1 -b stable https://github.com/flutter/flutter.git $FLUTTER_HOME
RUN git config --global --add safe.directory $FLUTTER_HOME

# Set ownership for developer user
RUN chown -R developer:developer /home/developer
RUN chown -R developer:developer ${ANDROID_HOME}

# Switch to developer user
USER developer
WORKDIR /home/developer

# Run basic Flutter commands to download Dart SDK and perform initial setup
RUN flutter config --enable-web && \
    flutter precache && \
    flutter precache --web && \
    flutter doctor

# Set up the working directory for the repository
WORKDIR /home/developer/repo

# Command to keep container running
CMD ["bash"]
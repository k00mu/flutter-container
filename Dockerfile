# Use the Flutter image from GitHub Container Registry
FROM ghcr.io/cirruslabs/flutter:latest

# Create a non-root user
RUN useradd -ms /bin/bash developer

# Set ownership for developer user
RUN chown -R developer:developer ${ANDROID_HOME}
RUN chown -R developer:developer ${FLUTTER_HOME}
RUN chown -R developer:developer /home/developer

# Switch to developer user
USER developer
WORKDIR /home/developer/repo

# Expose ports
EXPOSE 5555
EXPOSE 8080

# Command to keep container running
CMD ["bash"]
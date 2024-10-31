# Use a base image with Node.js, as it's required for React Native
FROM gitpod/workspace-full:latest

# Install Java (required for Android development)
RUN sudo apt-get update && sudo apt-get install -y openjdk-11-jdk && \
    sudo apt-get clean

# Install Android SDK
ENV ANDROID_SDK_ROOT="/usr/lib/android-sdk"
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O cmdline-tools.zip && \
    sudo mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    sudo unzip cmdline-tools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
    sudo mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
    rm cmdline-tools.zip && \
    yes | ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "platform-tools" "platforms;android-33" "build-tools;33.0.0"

# Update environment variables
ENV PATH="${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${PATH}"

# Use node version 16
RUN nvm install v16
RUN nvm use v16

# Install React Native CLI
RUN npm install -g react-native-cli

# Accept licenses (automated)
RUN yes | ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager --licenses

# Install Gradle (required for building React Native apps)
RUN wget https://services.gradle.org/distributions/gradle-7.4.2-bin.zip -P /tmp && \
    sudo unzip -d /opt/gradle /tmp/gradle-7.4.2-bin.zip && \
    sudo ln -s /opt/gradle/gradle-7.4.2/bin/gradle /usr/bin/gradle && \
    rm /tmp/gradle-7.4.2-bin.zip

# Set the environment variable for Java Home
ENV JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"

# Clean up to reduce the image size
RUN sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Verify installations
RUN node --version && npm --version && java --version && gradle --version && adb --version

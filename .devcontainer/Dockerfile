FROM openjdk:8

ARG FLUTTER_VERSION=v1.9.1+hotfix.6
ARG ANDROID_VERSION=29
ARG ANDROID_SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip"

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# However, for Linux, this user's GID/UID must match your local
# user UID/GID to avoid permission issues with bind mounts. Update USER_UID / USER_GID 
# if yours is not 1000. See https://aka.ms/vscode-remote/containers/non-root-user.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV ANDROID_TOOLS_ROOT=/home/$USERNAME/android_sdk
ENV ANDROID_HOME="${ANDROID_TOOLS_ROOT}"
ARG ANDROID_SDK_ARCHIVE="${ANDROID_TOOLS_ROOT}/archive"

ENV FLUTTER_ROOT=/home/$USERNAME/flutter
ARG FLUTTER_ARCHIVE="${FLUTTER_ROOT}/archive.tar.xz"
ARG FLUTTER_URL="https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"

# Configure apt and install packages
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \ 
    #
    # Install Flutter and Android sdk pres
    # 
    && apt-get install -y \
      git \
      procps \
      curl \
      unzip \
      lib32stdc++6 \
      android-sdk \
      xz-utils \
      make \
      libglu1-mesa \
      chromium \
    
    # Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user.
    && groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # [Optional] Add sudo support
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \



    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* 



USER $USERNAME

                                   
    
# Android
RUN mkdir -p "${ANDROID_TOOLS_ROOT}" \
    && wget -q "${ANDROID_SDK_URL}" -O "${ANDROID_SDK_ARCHIVE}" --show-progress \
    && unzip -q -d "${ANDROID_TOOLS_ROOT}" "${ANDROID_SDK_ARCHIVE}" \
    && rm "${ANDROID_SDK_ARCHIVE}" \

    && yes "y" | "${ANDROID_TOOLS_ROOT}"/tools/bin/sdkmanager --licenses \
	  && "${ANDROID_TOOLS_ROOT}"/tools/bin/sdkmanager --update  \
	  && "${ANDROID_TOOLS_ROOT}"/tools/bin/sdkmanager \
      tools \
      platform-tools \
      emulator \
      "build-tools;29.0.2" \
      "platforms;android-29" > /dev/null \

# Flutter
    && mkdir -p "${FLUTTER_ROOT}" \
    && wget -q "${FLUTTER_URL}" -O "${FLUTTER_ARCHIVE}" --show-progress \
    && tar xf "${FLUTTER_ARCHIVE}" -C "${FLUTTER_ROOT}/.." \
    && rm "${FLUTTER_ARCHIVE}" 
    
ENV PATH=$FLUTTER_ROOT/bin:$FLUTTER_ROOT/bin/cache/dart-sdk/bin:$ANDROID_HOME/tools/bin:$ANDROID_HOME/tools:$PATH

# Disable analytics and crash reporting on the builder.
RUN flutter config  --no-analytics \

    # Perform an artifact precache so that no extra assets need to be downloaded on demand.
    && flutter precache \

    # Accept licenses.
    && yes "y" | flutter doctor --android-licenses \

    # Perform a doctor run.
    && flutter doctor -v 

#WEB Support
RUN flutter channel dev \ 
    && flutter upgrade  \
    && flutter config --enable-web

ENV CHROME_EXECUTABLE=chromium

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=

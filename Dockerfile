FROM debian:11 AS build-env

RUN apt-get update && apt-get install -y \
    curl \
    fonts-droid-fallback \
    gdb \
    git \
    lib32stdc++6 \
    libgconf-2-4 \
    libglu1-mesa \
    libgtk-3-0 \
    libstdc++6 \
    libxi6 \
    libxrender1 \
    libxslt1.1 \
    libxtst6 \
    python3 \
    unzip \
    wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV FLUTTER_VERSION=3.35.2
ENV FLUTTER_HOME=/usr/local/flutter

RUN git clone https://github.com/flutter/flutter.git ${FLUTTER_HOME} && \
    cd ${FLUTTER_HOME} && \
    git checkout tags/${FLUTTER_VERSION} -b ${FLUTTER_VERSION}

ENV PATH="${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin:${PATH}"

RUN flutter doctor -v
RUN flutter config --enable-web

RUN mkdir /app/
WORKDIR /app/
COPY . /app/

RUN flutter pub get
RUN flutter build web --release

FROM nginx:1.21.1-alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

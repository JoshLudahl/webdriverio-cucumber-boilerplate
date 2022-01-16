FROM node:17.2.0-slim AS build

# We need wget and gnupg with newer versions of Node.
RUN apt-get update && apt-get -y install wget gnupg

# Install chrome + required tools
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable non-free main" >> /etc/apt/sources.list && \
    wget http://dl-ssl.google.com/linux/linux_signing_key.pub && \
    apt-key add linux_signing_key.pub

RUN apt-get update && \
    apt-get -y install google-chrome-stable bzip2 git && \
    apt-get clean

# Copy in package*.json only so we can cache dependencies
COPY package*.json .npmrc src/

WORKDIR /src

# Install npm modules
RUN npm install

# Copy in the rest of the source
COPY . .

# Build/transpile
RUN npm run transpile

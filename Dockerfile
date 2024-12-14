FROM node:18-alpine
USER jenkins
RUN apk add --no-cache coreutils shadow
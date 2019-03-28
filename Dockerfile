FROM node:lts-alpine AS builder

WORKDIR /app
COPY package*.json /app/
RUN npm ci
COPY ./ /app/
RUN npm run build


FROM nginx:stable-alpine

LABEL \
  org.label-schema.schema-version="1.0" \
  org.label-schema.name="vm_image-frontend" \
  org.label-schema.vcs-url="https://github.com/mexious/vm_image-frontend/" \
  maintainer="Developer Mexious <care@mexious.com>"

COPY --from=builder /app/build/ /usr/share/nginx/html/
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

ARG BUILD_DATE
ARG VCS_REF
LABEL \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.vcs-ref=$VCS_REF

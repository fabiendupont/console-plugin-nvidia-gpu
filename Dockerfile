
FROM registry.access.redhat.com/ubi8/nodejs-16:latest AS builder
USER root
RUN corepack enable yarn
USER 1001

COPY . /opt/app-root/src
RUN yarn install --frozen-lockfile && yarn build

FROM registry.access.redhat.com/ubi8/ubi-minimal:latest
RUN microdnf install nginx \
    && microdnf clean all \
    && rm -rf /var/cache/yum
COPY default.conf "${NGINX_CONFIGURATION_PATH}"
COPY --from=builder /opt/app-root/src/dist .
USER 1001
CMD /usr/libexec/s2i/run

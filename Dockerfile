FROM registry.access.redhat.com/ubi8/nodejs-16:latest AS builder
COPY --chown=1001:0 . $APP_ROOT/src
USER root
RUN corepack enable yarn && yarn install && yarn build

FROM registry.access.redhat.com/ubi8/nginx-118
COPY --from=builder /opt/app-root/src/default.conf "${NGINX_CONFIGURATION_PATH}"
COPY --from=builder /opt/app-root/src/dist .
CMD nginx -g "daemon off"

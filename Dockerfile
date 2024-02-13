FROM alpine:latest as download
RUN  apk update && apk add curl zip ca-certificates
ARG TARGETARCH
RUN curl -L https://snell-version-service.skyxim.workers.dev/download/${TARGETARCH} -o snell.zip \
    && unzip snell.zip -d / && chmod +x /snell-server 


FROM debian:stable-slim
RUN mkdir -p /usr/local/bin && mkdir -p /etc/snell
COPY --from=download /snell-server /usr/local/bin/snell-server
# COPY --from=download /glibc.apk /glibc.apk
# COPY --from=download /glibc-bin.apk /glibc-bin.apk
# RUN apk add --force-overwrite --allow-untrusted /glibc.apk /glibc-bin.apk && apk add --no-cache libstdc++ && rm /glibc.apk /glibc-bin.apk  && rm -rf /var/cache/apk/* && chmod +x /usr/local/bin/snell-server
ENTRYPOINT [ "/usr/local/bin/snell-server","-c","/etc/snell/snell.conf"]
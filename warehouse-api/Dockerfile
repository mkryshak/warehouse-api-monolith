FROM registry.nginx.net/nginx-unit:1.17

LABEL maintainer="Matt Kryshak <matt.kryshak@nginx.com>"

RUN mkdir -p /var/lib/unit/certs /www \
  && touch /var/log/access.log \
  && touch /var/log/error.log

COPY tls /var/lib/unit/certs
COPY unit /var/lib/unit
COPY www /www

RUN ln -sf /dev/stdout /var/log/access.log \
  && ln -sf /dev/stderr /var/log/error.log \
  && ln -sf /dev/stdout /var/log/unit.log

EXPOSE 80 443

CMD ["unitd", "--no-daemon", "--control", "unix:/var/run/control.unit.sock"]

FROM cytopia/phpcs:3

COPY entrypoint.sh \
     problem-matcher.json \
     /action/

RUN chmod +x /action/entrypoint.sh

RUN apk update && \
    apk upgrade && \
    apk add git

ENTRYPOINT ["/action/entrypoint.sh"]

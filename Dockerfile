FROM cytopia/phpcs:3-php7.4

COPY entrypoint.sh \
     problem-matcher.json \
     /action/

RUN chmod +x /action/entrypoint.sh

RUN apk update && \
    apk upgrade && \
    apk add git composer php8-simplexml php8-tokenizer php8-xmlreader php8-xmlwriter

ENTRYPOINT ["/action/entrypoint.sh"]

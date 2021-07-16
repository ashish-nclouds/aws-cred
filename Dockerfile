FROM python:3-alpine

RUN apk --no-cache add jq && \
      rm -rf /var/cache/apk/*

COPY requirements.txt /requirements.txt
RUN pip3 install -r /requirements.txt

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

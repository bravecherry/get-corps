FROM python:3.8-alpine

EXPOSE 5000
VOLUME /home

WORKDIR /home

COPY requirements.txt requirements.txt
RUN apk add --no-cache --virtual .build-deps \
        build-base \
        coreutils \
        gd-dev \
        libxslt-dev \
        linux-headers \
        make \
        gcc \
        perl-dev \
        readline-dev \
    && apk add --no-cache mysql-client \
    && python3 -m pip install -r requirements.txt \
    && apk del .build-deps

COPY app.py app.py
COPY api/ api/

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]
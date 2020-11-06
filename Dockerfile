# Dockerfile for https://github.com/sergey-werk/search_engine_crawler (forked from express42/search_engine_crawler)

FROM python:3.6-alpine as python-base

# Stage 1
FROM python-base as builder
LABEL app="search_engine_crawler"

RUN mkdir /install
WORKDIR /install

COPY requirements.txt /requirements.txt

RUN apk --no-cache --update add build-base && \
    pip install --prefix=/install -r /requirements.txt && \
    apk del build-base

# Stage 2
FROM python-base
LABEL version="2.1"
LABEL app="search_engine_crawler"

COPY --from=builder /install /usr/local
COPY . /app
WORKDIR /app

# EXCLUDE_URLS - адреса которые будут исключены из обхода записанные через запятую в формате простых регулярных выражений.
# MONGO - адрес mongodb-хоста
# MONGO_PORT - порт для подключения к mongodb-хосту
# RMQ_HOST - адрес rabbitmq-хоста
# RMQ_QUEUE - имя очереди rabbitmq
# RMQ_USERNAME - пользователь для подключения к rabbitmq-серверу
# RMQ_PASSWORD - пароль пользователя
# CHECK_INTERVAL - минимальное время между повторными проверками одного и того же url

ENV APP_HOME /app
ENV MONGO mongodb
ENV MONGO_PORT 27017
ENV CHEAT_ER xyzzy
ENV RMQ_HOST rabbitmq
ENV RMQ_QUEUE default
ENV RMQ_USERNAME guest
ENV RMQ_PASSWORD guest
ENV CHECK_INTERVAL 1800
ENV EXCLUDE_URLS '.*github.com'

ENTRYPOINT  python -u crawler/crawler.py https://vitkhab.github.io/search_engine_test_site/
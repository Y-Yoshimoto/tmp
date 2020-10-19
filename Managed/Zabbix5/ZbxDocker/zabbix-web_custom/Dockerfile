FROM alpine:latest AS build-env
MAINTAINER y.yoshimoto
# apk curlのインストール
RUN apk --no-cache add postfix curl unzip
# 日本語用 IPAexフォントの取得
RUN curl -O  https://moji.or.jp/wp-content/ipafont/IPAexfont/ipaexg00401.zip
RUN unzip ipaexg00401.zip

# Zabbix Imageへのコピー
FROM zabbix/zabbix-web-nginx-mysql:alpine-5.0-latest
COPY --from=build-env /ipaexg00401/ipaexg.ttf /usr/share/zabbix/assets/fonts/DejaVuSans.ttf

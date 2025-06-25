# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: fbily <fbily@student.42.fr>                +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/17 19:39:23 by fbily             #+#    #+#              #
#    Updated: 2025/06/25 17:32:08 by fbily            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y nginx
RUN apt-get install openssl -y
RUN mkdir -p /etc/nginx/ssl && chmod -R 755 /etc/nginx/ssl
RUN openssl req \
            -x509 \
            -nodes \
            -days 365 \
            -newkey rsa:2048 \
            -keyout /etc/nginx/ssl/inception.key \
            -out /etc/nginx/ssl/inception.crt \
            -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=fbily.42.fr/UID=fbily"

COPY ./conf/default    /etc/nginx/sites-available/default

ENTRYPOINT ["nginx", "-g", "daemon off;"]
# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: fbily <fbily@student.42.fr>                +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/17 19:39:35 by fbily             #+#    #+#              #
#    Updated: 2025/06/25 17:44:35 by fbily            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

# Install packages
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    unzip \
    php8.2 \
    php8.2-fpm \
    php8.2-cli \
    php8.2-mysql \
    php8.2-curl \
    php8.2-gd \
    php8.2-mbstring \
    php8.2-xml \
    php8.2-soap \
    php8.2-intl \
    php8.2-zip \
    php8.2-redis \
    redis \
    curl \
    wget \
    default-mysql-client && \
    mkdir -p /run/php && \
    apt-get clean

COPY ./conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

# Copy installation script
COPY ./tools/install.sh /usr/local/bin/install.sh
RUN chmod +x /usr/local/bin/install.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/install.sh"]

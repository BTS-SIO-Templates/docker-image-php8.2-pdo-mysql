FROM php:8.2-apache

ENV DEBIAN_FRONTEND=noninteractive

# Dépendances système utiles
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    mariadb-client \
    default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

# Extensions PHP nécessaires
RUN docker-php-ext-install \
    pdo \
    pdo_mysql

# Activation de mod_rewrite (souvent utile même sans framework)
RUN a2enmod rewrite

# Apache écoute sur 8080 (obligatoire en Codespaces)
RUN sed -i 's/80/8080/g' /etc/apache2/ports.conf \
 && sed -i 's/:80/:8080/g' /etc/apache2/sites-available/000-default.conf

# Dossier de travail = racine web
WORKDIR /var/www/html

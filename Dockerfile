# Utilise l'image officielle PHP 8.2 CLI comme base
FROM php:8.2-cli

# Empêche les invites interactives pendant apt-get (utile pour Codespaces)
ENV DEBIAN_FRONTEND=noninteractive

# 1. Dépendances système (essentielles uniquement)
RUN apt-get update \
    && apt-get install -y gnupg2 wget git unzip libzip-dev libpng-dev libonig-dev libxml2-dev libicu-dev libpq-dev libsqlite3-dev

# 2. Extensions PHP nécessaires
RUN docker-php-ext-install pdo pdo_mysql intl zip

# 3. Symfony CLI (Retour à la méthode 'curl' simplifiée)
# 1. Télécharge l'installateur sous un nom temporaire.
RUN wget -O symfony-installer https://get.symfony.com/cli/installer \
# 2. Rend l'installateur exécutable.
&& chmod +x symfony-installer \
# 3. Exécute l'installateur pour placer le vrai binaire 'symfony' dans le PATH de l'utilisateur root.
#    (Le binaire final est souvent placé dans /usr/local/bin/ après l'exécution)
&& ./symfony-installer \
# 4. Déplace le binaire final "symfony" vers un emplacement sûr et global.
&& mv /root/.symfony*/bin/symfony /usr/local/bin/symfony \
# 5. Nettoie le fichier d'installation temporaire.
&& rm symfony-installer

# 4. Composer (Utiliser la méthode standard recommandée)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# 5. Définir l'utilisateur (C'est ici qu'il y a un risque si l'utilisateur n'est pas correctement créé par l'image de base)
# L'image de base 'php:8.2-cli' ne crée pas l'utilisateur 'vscode'. 
# Si vous voulez l'utilisateur 'vscode', il est plus sûr d'utiliser une image devcontainer officielle (par exemple mcr.microsoft.com/devcontainers/php:8.2)
# OU retirez la ligne 'USER vscode' pour rester en ROOT si cela fonctionne.

# Solution immédiate : Commenter la ligne USER vscode pour éviter le problème de PATH.
# USER vscode 
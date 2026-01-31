# Dockerfile para FluxioGym - CakePHP 3.x
FROM php:7.1-apache

# Instalar extensiones de PHP necesarias
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install \
    intl \
    pdo \
    pdo_mysql \
    mysqli \
    gd \
    zip \
    opcache \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Habilitar mod_rewrite para CakePHP
RUN a2enmod rewrite headers

# Configurar Apache para el directorio webroot
ENV APACHE_DOCUMENT_ROOT /var/www/html/webroot
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Configurar AllowOverride All para .htaccess
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configurar PHP
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY docker/php.ini /usr/local/etc/php/conf.d/custom.ini

# Establecer directorio de trabajo
WORKDIR /var/www/html

# Copiar archivos del proyecto
COPY . /var/www/html

# Crear directorios necesarios y establecer permisos
RUN mkdir -p /var/www/html/tmp/cache/models \
    && mkdir -p /var/www/html/tmp/cache/persistent \
    && mkdir -p /var/www/html/tmp/cache/views \
    && mkdir -p /var/www/html/tmp/sessions \
    && mkdir -p /var/www/html/tmp/tests \
    && mkdir -p /var/www/html/logs \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 777 /var/www/html/tmp \
    && chmod -R 777 /var/www/html/logs

# Exponer puerto 80
EXPOSE 80

CMD ["apache2-foreground"]

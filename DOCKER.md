# FluxioGym - Despliegue con Docker

## Requisitos Previos

- [Docker](https://www.docker.com/get-started) instalado
- [Docker Compose](https://docs.docker.com/compose/install/) instalado

## Configuración Rápida

### 1. Configurar la Base de Datos

Antes de iniciar, modifica el archivo `config/app.php` y actualiza la sección `Datasources`:

```php
'Datasources' => [
    'default' => [
        'className' => 'Cake\Database\Connection',
        'driver' => 'Cake\Database\Driver\Mysql',
        'persistent' => false,
        'host' => 'db',                    // Nombre del servicio Docker
        'username' => 'gymuser',           // Usuario definido en docker-compose.yml
        'password' => 'gympassword',       // Contraseña definida en docker-compose.yml
        'database' => 'gym_master',        // Base de datos definida en docker-compose.yml
        'encoding' => 'utf8',
        'timezone' => 'UTC',
        'flags' => [],
        'cacheMetadata' => true,
        'log' => false,
        'quoteIdentifiers' => false,
        'url' => env('DATABASE_URL', null),
    ],
    // ... resto de configuraciones
],
```

### 2. Iniciar los Contenedores

```bash
# Construir e iniciar todos los servicios
docker-compose up -d --build

# Ver los logs
docker-compose logs -f

# Solo ver logs de la aplicación
docker-compose logs -f app
```

### 3. Acceder a la Aplicación

- **Aplicación Web**: http://localhost:8080
- **phpMyAdmin**: http://localhost:8081
  - Usuario: `root`
  - Contraseña: `root_password`

### 4. Importar la Base de Datos

La base de datos se importará automáticamente desde `db/gym_master_04_06 (1).sql` al iniciar por primera vez.

Si necesitas importarla manualmente:

```bash
# Acceder al contenedor de MySQL
docker-compose exec db bash

# Dentro del contenedor, importar la base de datos
mysql -u root -proot_password gym_master < /docker-entrypoint-initdb.d/gym_master_04_06\ \(1\).sql
```

O usando phpMyAdmin en http://localhost:8081

## Comandos Útiles

```bash
# Detener todos los contenedores
docker-compose down

# Detener y eliminar volúmenes (¡BORRA LA BASE DE DATOS!)
docker-compose down -v

# Reconstruir la imagen
docker-compose build --no-cache

# Acceder al contenedor de la aplicación
docker-compose exec app bash

# Ver estado de los contenedores
docker-compose ps

# Reiniciar un servicio específico
docker-compose restart app
```

## Estructura de Servicios

| Servicio | Puerto Local | Descripción |
|----------|-------------|-------------|
| app | 8080 | Aplicación PHP/CakePHP |
| db | 3307 | MySQL 5.7 |
| phpmyadmin | 8081 | Administrador de BD |

## Personalización

### Cambiar Credenciales de Base de Datos

Edita `docker-compose.yml`:

```yaml
db:
  environment:
    MYSQL_ROOT_PASSWORD: tu_password_root
    MYSQL_DATABASE: tu_base_datos
    MYSQL_USER: tu_usuario
    MYSQL_PASSWORD: tu_password
```

**Importante**: Actualiza también `config/app.php` con las mismas credenciales.

### Cambiar la Zona Horaria

Edita `docker/php.ini`:

```ini
date.timezone = America/Lima
```

## Solución de Problemas

### Error de conexión a la base de datos

1. Verifica que el contenedor de MySQL esté corriendo:
   ```bash
   docker-compose ps
   ```

2. Espera unos segundos después de iniciar (MySQL tarda en arrancar)

3. Verifica las credenciales en `config/app.php`

### Permisos de archivos

```bash
docker-compose exec app chown -R www-data:www-data /var/www/html
docker-compose exec app chmod -R 777 /var/www/html/tmp /var/www/html/logs
```

### Limpiar caché de CakePHP

```bash
docker-compose exec app bin/cake cache clear_all
```

## Despliegue en Producción

Para producción, considera:

1. Cambiar todas las contraseñas por defecto
2. Usar `debug => false` en `config/app.php`
3. Configurar HTTPS con un proxy reverso (nginx/traefik)
4. Usar volúmenes externos para persistencia de datos
5. Configurar backups automáticos de la base de datos

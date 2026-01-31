<?php
/**
 * Configuración de Base de Datos para Docker
 * 
 * Copia este archivo a config/app.php o modifica los valores de Datasources
 * en tu config/app.php existente para usar estas variables de entorno.
 */

// Configuración de conexión para Docker
// En tu config/app.php, reemplaza la sección 'Datasources' => 'default' con:

/*
'Datasources' => [
    'default' => [
        'className' => 'Cake\Database\Connection',
        'driver' => 'Cake\Database\Driver\Mysql',
        'persistent' => false,
        'host' => env('DB_HOST', 'db'),           // 'db' es el nombre del servicio en docker-compose
        'username' => env('DB_USER', 'gymuser'),
        'password' => env('DB_PASSWORD', 'gympassword'),
        'database' => env('DB_NAME', 'gym_master'),
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
*/

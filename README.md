# Role System

## Installation via Composer

```json
{
    "require": {
        "artox-lab/fisher": "1.0.0"
    }
}
```

Run ```composer update```

## Setup DB structure
You can install this DB structure using the following command:
```bash
php init.php
```
and enter data name database, username for database and password for username.

## Usage

```php
<?php

include 'vendor/autoload.php';

// Username for DB
$username = 'root';

// Password for DB
$password = '123';

// Initial class role system
 $roleSystem = \Fisher\RoleSystem::getInstance('mysql:host=localhost;charset=utf8;dbname=fisher_database', $username, $password);

// User id for db table `re_account_user`
$userId = 95;

// check rule for user
echo $roleSystem->checkAccess($userId, 'admin/catalog/products');

```
<?php

if (!file_exists(__DIR__ . '/../vendor/autoload.php'))
{
    throw new \Exception('Не найден файл автолоада классов, видимо Вы забыли установить композер или необходимые пакеты.');
}
require_once(__DIR__ . '/../vendor/autoload.php');

if (!file_exists(__DIR__ . '/../data/schema.sql'))
{
    throw new \Exception('Тестовая структура БД не найдена.');
}

$deleteTablesCommand = <<<EOF
mysql -u{$GLOBALS['DB_USERNAME']} -p{$GLOBALS['DB_PASSWORD']} -e "SET FOREIGN_KEY_CHECKS = 0;
USE {$GLOBALS['DB_NAME']};
SET GROUP_CONCAT_MAX_LEN=32768;
SET @tables = NULL;
SELECT GROUP_CONCAT(table_name) INTO @tables
  FROM information_schema.tables
  WHERE table_schema = (SELECT DATABASE());
SELECT IFNULL(@tables,'{$GLOBALS['DB_NAME']}') INTO @tables;
SET @tables = CONCAT('DROP TABLE IF EXISTS ', @tables);
PREPARE stmt FROM @tables;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
SET FOREIGN_KEY_CHECKS = 1;";
EOF;
$importDbSchemaCommand = "mysql -u{$GLOBALS['DB_USERNAME']} -p{$GLOBALS['DB_PASSWORD']}  {$GLOBALS['DB_NAME']} < " . __DIR__ . '/../data/schema.sql';
$importDbDataSchemaCommand = "mysql -u{$GLOBALS['DB_USERNAME']} -p{$GLOBALS['DB_PASSWORD']}  {$GLOBALS['DB_NAME']} < " . __DIR__ . '/data/data.sql';
echo 'Чистим БД для тестов...' . "\n";
echo exec($deleteTablesCommand);
echo 'Импортируем схему для тестов...' . "\n";
echo exec($importDbSchemaCommand);
echo 'Импортируем данные схемы для тестов...' . "\n";
echo exec($importDbDataSchemaCommand);
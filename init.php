<?php
/**
 * Команда для создания структуры БД
 */
echo 'Begin export database!' . PHP_EOL;
echo 'Database:' . PHP_EOL;
$database = trim(fgets(STDIN));
echo 'Database:' . $database . PHP_EOL;
echo 'Username database:' . PHP_EOL;
$username = trim(fgets(STDIN));
echo 'Username database:' . $username . PHP_EOL;
echo 'Password username:' . PHP_EOL;
$password = trim(fgets(STDIN));
echo 'Password username:' . $password . PHP_EOL;
exec("mysql -u{$database} -p{$password} -f {$database} < ". __DIR__ . "/data/schema.sql");
echo 'End export database!' . PHP_EOL;


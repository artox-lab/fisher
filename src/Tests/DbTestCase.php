<?php namespace Fisher\Tests;

class DbTestCase extends \PHPUnit_Framework_TestCase
{
    protected $config = [
        'adapter' => null,
        'host' => null,
        'port' => null,
        'database' => null,
        'username' => null,
        'password' => null,
        'charset' => null,
        'collation' => null,
        'prefix' => '',
        'unixSocket' => null
    ];
    public function __construct($name = null, array $data = [], $dataName = '')
    {
        parent::__construct($name, $data, $dataName);
        $this->bindConfig();
    }

    protected function bindConfig()
    {
        $this->config = [
            'adapter' => $GLOBALS['DB_ADAPTER'],
            'host' => $GLOBALS['DB_HOST'],
            'port' => $GLOBALS['DB_PORT'],
            'database' => $GLOBALS['DB_NAME'],
            'username' => $GLOBALS['DB_USERNAME'],
            'password' => $GLOBALS['DB_PASSWORD'],
            'charset' => $GLOBALS['DB_CHARSET'],
            'collation' => $GLOBALS['DB_COLLATION'],
            'prefix' => $GLOBALS['DB_TABLE_PREFIX'],
            'unixSocket' => $GLOBALS['DB_UNIX_SOCKET']
        ];
    }
}
<?php

use Fisher\Tests\DbTestCase;

class RoleSystemTest extends DbTestCase
{
    public function testTrueCheckAccess()
    {
        $instance = \Fisher\RoleSystem::getInstance('mysql:host=' . $this->config['host'] . ';charset=' .  $this->config['charset'] . ';dbname=' . $this->config['database'], $this->config['username'], $this->config['password']);
        $this->assertTrue($instance->checkAccess(95, 'admin/catalog/productFilters/inputvalues'));
    }

    public function testFalseCheckAccess()
    {
        $instance = \Fisher\RoleSystem::getInstance('mysql:host=' . $this->config['host'] . ';charset=' .  $this->config['charset'] . ';dbname=' . $this->config['database'], $this->config['username'], $this->config['password']);
        $this->assertFalse($instance->checkAccess(95, 'admin/catalog/places/sendpersonalchanges'));
    }

    public function testParentRuleDenyCheckAccess()
    {
        $instance = \Fisher\RoleSystem::getInstance('mysql:host=' . $this->config['host'] . ';charset=' .  $this->config['charset'] . ';dbname=' . $this->config['database'], $this->config['username'], $this->config['password']);
        $this->assertFalse($instance->checkAccess(95, 'admin/catalog/productFilters/merge'));
    }

    public function testCheckAccessToPlaces()
    {
        $instance = \Fisher\RoleSystem::getInstance('mysql:host=' . $this->config['host'] . ';charset=' .  $this->config['charset'] . ';dbname=' . $this->config['database'], $this->config['username'], $this->config['password']);
        $this->assertTrue($instance->checkAccessToPlaces(95, [1,2]));
        $this->assertFalse($instance->checkAccessToPlaces(95, [3]));
    }

    public function testCheckAccessToAllPlaces()
    {
        $instance = \Fisher\RoleSystem::getInstance('mysql:host=' . $this->config['host'] . ';charset=' .  $this->config['charset'] . ';dbname=' . $this->config['database'], $this->config['username'], $this->config['password']);
        $this->assertTrue($instance->checkAccessToAllPlaces(96));
    }
}

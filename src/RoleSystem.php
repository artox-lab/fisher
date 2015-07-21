<?php namespace Fisher;

class RoleSystem
{
    private static $instance;

    /** @const string типы рула */
    const TYPE_DENY = 'deny';
    const TYPE_ALLOW = 'allow';

    /** @const string название таблицы, хранящей роли */
    const ROLE_TABLE = 're_account_role';

    /** @const string название таблицы, хранящей правила авторизации */
    const RULE_TABLE = 're_account_rule';

    /** @const string название таблицы, хранящей привязку правил авторизации к ролям */
    const ROLES_RULES_TABLE = 're_account_roles_rules';

    /** @const string название таблицы, хранящей пользователей */
    const USER_TABLE = 're_account_user';

    /** @const string название таблицы, хранящей привязку пользователя к ролям */
    const USERS_ROLES_TABLE = 're_account_users_roles';

    /** @const string разделитель */
    const NAME_DELIMITER = '/';

    /**
     * Конструктор
     *
     * @param string $connectionString - строка PDO для коннекта
     * @param string $user - пользователь БД
     * @param string $password - пароль пользователя БД
     */
    protected function __construct($connectionString, $user, $password)
    {
        $this->pdo = new \PDO($connectionString, $user, $password);
    }

    /**
     * Функция инициализации объекта
     *
     * @param string $connectionString - строка PDO для коннекта
     * @param string $user - пользователь БД
     * @param string $password - пароль пользователя БД
     *
     * @return RoleSystem
     */
    public static function getInstance($connectionString, $user, $password)
    {
        if (is_null(self::$instance))
        {
            self::$instance = new self($connectionString, $user, $password);
        }

        return self::$instance;
    }

    /**
     * Проверка прав пользователя на доступность экшэна
     *
     * @param string $ruleName - название роли
     * @param number $userId - id пользователя
     * @param string $moduleName - название модуля
     * @param string $controllerName - название контроллера
     *
     * @return bool
     */
    public function checkAccess($ruleName, $userId, $moduleName, $controllerName)
    {
        $check = false;

        $fullItemName = trim(($ruleName[0] != '/') ? $this->createOperationName($ruleName, $moduleName, $controllerName) : substr($ruleName, 1), '/');
        $fullItemName = mb_strtolower($fullItemName);

        // Получаем список ролей
        $roles = $this->getUserRoles($userId);

        // Получаем id ролей
        $rolesIds =  array_column($roles, 'id');

        // Получаем параметры для запроса
        $paramsQuery = array_map(function($item)
        {
            return ':param_' . $item;
        }, $rolesIds);

        // Проверяем, есть ли связь у какой-либо из ролей с запрашиваемым итемом
        // Сортируем по type, чтобы легче было проверять
        $sql = '
            SELECT
                `type`
            FROM
                `' . $this->rolesRulesTable . '` as `rr`
            LEFT JOIN
                `' . $this->ruleTable . '` `r` as `r`.`id` = `rr`.`rule_id`
            WHERE
                LOWER(`r`.`key`) = :key
                AND `rr`.`role_id` in (' . implode(',', $paramsQuery) . ')
            ORDER BY (`rr`.`type` = :type) DESC
        ';

        $select = $this->pdo->prepare($sql);

        foreach ($paramsQuery as $key => $param)
        {
            $select->bindParam($param, intval($rolesIds[$key]), \PDO::PARAM_INT);
        }

        $select->bindParam(':type', self::TYPE_DENY, \PDO::PARAM_STR);
        $select->bindParam(':key', $fullItemName, \PDO::PARAM_STR);

        $assignment = $select->fetch(\PDO::FETCH_NUM);

        if (!empty($assignment) && $assignment['type'] == self::TYPE_ALLOW)
        {
            $check = true;
        }

        return $check;
    }

    #region Вспомогательные функции
    /**
     * Формирование полного названия операции
     *
     * @param string $itemName название проверяемого экшэна
     * @param string $moduleName название модуля
     * @param string $controllerName название контроллера
     *
     * @return string полное название проверяемого экшэна
     */
    public function createOperationName($itemName, $moduleName, $controllerName)
    {
        // Выводим название = название_модуля+разделитель+название_контроллера+разделитель+название_операции
        return sprintf('%1$s%4$s%2$s%4$s%3$s', $moduleName, $controllerName, $itemName, self::NAME_DELIMITER);
    }
    #endregion

    #region Функции, которые работают с информацией о ролях и доступе пользователя
    /**
     * Возвращает правила связанные с пользователем
     *
     * @param mixed $userId Id пользователя
     * @return array Массив ролей
     */
    public function getUserRoles($userId)
    {
        // Получаем роли, назначенные напрямую, а также родительскую
        // Не делаем рекурсию, так как роль может иметь только одного родителя
        $sql = '
            SELECT
                `r`.*
            FROM
              `' . $this->roleTable . '` as `r`
            LEFT JOIN
               `' . $this->usersRolesTable . '` as `ur` on `r`.`id` = `ur`.`role_id`
            WHERE
               `ur`.`user_id` = :userId
        ';

        $select = $this->pdo->prepare($sql);

        $select->bindParam(':userId', $userId, \PDO::PARAM_INT);

        $roles = $select->fetchAll(\PDO::FETCH_NUM);

        $rolesWithParentRole = array_filter($roles, function ($x)
        {
            return !empty($x['parent_role_id']);
        });

        $rolesWithParentRoleIds = array_column($rolesWithParentRole, 'parent_role_id');

        // Получаем параметры для запроса
        $paramsQuery = array_map(function($item)
        {
            return ':param_' . $item;
        }, $rolesWithParentRoleIds);

        $sql = '
            SELECT
                *
            FROM
              `' . $this->roleTable . '`
            WHERE
              `id` in (' . implode(',', $paramsQuery) . ')
        ';

        $select = $this->pdo->prepare($sql);

        foreach ($paramsQuery as $key => $param)
        {
            $select->bindParam($param, intval($rolesWithParentRoleIds[$key]), \PDO::PARAM_INT);
        }

        $parentRoles = $select->fetchAll(\PDO::FETCH_NUM);

        return array_merge($roles, $parentRoles);
    }
    #endregion
}
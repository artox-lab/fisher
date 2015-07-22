<?php namespace Fisher;

/**
 * Класс для работы с системой ролей
 *
 * Class RoleSystem
 * @package Fisher
 */
class RoleSystem
{
    private static $instance;

    /** @const string типы рула */
    const TYPE_DENY = 'deny';
    const TYPE_ALLOW = 'allow';

    /** @var string название таблицы, хранящей роли */
    public $roleTable = 're_account_role';

    /** @var string название таблицы, хранящей правила авторизации */
    public $ruleTable = 're_account_rule';

    /** @var string название таблицы, хранящей привязку правил авторизации к ролям */
    public $rolesRulesTable = 're_account_roles_rules';

    /** @var string название таблицы, хранящей пользователей */
    public $userTable = 're_account_user';

    /** @var string название таблицы, хранящей привязку пользователя к ролям */
    public $usersRolesTable = 're_account_users_roles';

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
        $this->pdo->setAttribute(\PDO::ATTR_ERRMODE, \PDO::ERRMODE_EXCEPTION);
    }

    /**
     * Функция инициализации объекта
     *
     * @param string $connectionString - строка PDO для коннекта к БД
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
     * @param number $userId - id пользователя
     * @param string $fullRoleName - полное название роли

     *
     * @return bool
     */
    public function checkAccess($userId, $fullRoleName)
    {
        $check = false;

        // Получаем список ролей
        $roles = $this->getUserRoles($userId);

        // Получаем id ролей
        $rolesIds =  array_column($roles, 'id');

        // Получаем параметры для запроса
        $paramsQuery = array_map(function($item)
        {
            return ':param_' . intval($item);
        }, $rolesIds);

        // Проверяем, есть ли связь у какой-либо из ролей с запрашиваемым итемом
        // Сортируем по type, чтобы легче было проверять
        $sql = '
            SELECT
                `type`
            FROM
                `' . $this->rolesRulesTable . '` as `rr`
            LEFT JOIN
                `' . $this->ruleTable . '` as `r` on `r`.`id` = `rr`.`rule_id`
            WHERE
                LOWER(`r`.`key`) = :key
                AND `rr`.`role_id` in (' . implode(',', $paramsQuery) . ')
            ORDER BY (`rr`.`type` = :type) DESC
        ';

        $select = $this->pdo->prepare($sql);

        foreach ($paramsQuery as $key => $param)
        {
            $select->bindParam($param, (intval($rolesIds[$key])), \PDO::PARAM_INT);
        }

        $deny = self::TYPE_DENY;
        $select->bindParam(':type', $deny, \PDO::PARAM_STR);
        $select->bindParam(':key', $fullRoleName, \PDO::PARAM_STR);
        $select->execute();

        $assignment = $select->fetch(\PDO::FETCH_ASSOC);

        if (!empty($assignment) && $assignment['type'] == self::TYPE_ALLOW)
        {
            $check = true;
        }

        return $check;
    }

    #region Функции, которые работают с информацией о ролях и доступе пользователя
    /**
     * Возвращает правила связанные с пользователем
     *
     * @param integer $userId Id пользователя
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

        $select->bindParam(':userId', (intval($userId)), \PDO::PARAM_INT);
        $select->execute();

        $roles = $select->fetchAll(\PDO::FETCH_ASSOC);

        $rolesWithParentRole = array_filter($roles, function ($x)
        {
            return !empty($x['parent_role_id']);
        });

        $rolesWithParentRoleIds = array_column($rolesWithParentRole, 'parent_role_id');

        // Получаем параметры для запроса
        $paramsQuery = array_map(function($item)
        {
            return ':param_' . intval($item);
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
            $select->bindParam($param, (intval($rolesWithParentRoleIds[$key])), \PDO::PARAM_INT);
        }
        $select->execute();
        $parentRoles = $select->fetchAll(\PDO::FETCH_ASSOC);

        return array_merge($roles, $parentRoles);
    }
    #endregion
}
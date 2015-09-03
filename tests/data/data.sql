SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for re_account_role
-- ----------------------------
DROP TABLE IF EXISTS `re_account_role`;
CREATE TABLE `re_account_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `type` enum('basic','user') NOT NULL,
  `parent_role_id` int(11) DEFAULT NULL,
  `personal_forms_notification` enum('0','1') NOT NULL DEFAULT '0',
  `common_forms_notification` enum('0','1') NOT NULL DEFAULT '0',
  `start_page` enum('panel','places') DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ParentRole` (`parent_role_id`),
  KEY `Type` (`type`),
  KEY `PersonalFormsNotification` (`personal_forms_notification`),
  CONSTRAINT `Role_ParentRole` FOREIGN KEY (`parent_role_id`) REFERENCES `re_account_role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


-- ----------------------------
-- Table structure for re_account_rule
-- ----------------------------
DROP TABLE IF EXISTS `re_account_rule`;
CREATE TABLE `re_account_rule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `key` varchar(1000) NOT NULL,
  `parent_rule_id` int(11) DEFAULT NULL,
  `sort_order` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ParentIndex` (`parent_rule_id`),
  KEY `SortOrderIndex` (`sort_order`),
  CONSTRAINT `ParentRule` FOREIGN KEY (`parent_rule_id`) REFERENCES `re_account_rule` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for re_account_user
-- ----------------------------
DROP TABLE IF EXISTS `re_account_user`;
CREATE TABLE `re_account_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` enum('personal','organization') NOT NULL DEFAULT 'personal',
  `status` enum('not_active','active','banned','deleted') NOT NULL DEFAULT 'not_active',
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `organization_name` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(64) NOT NULL,
  `password_salt` varchar(8) NOT NULL,
  `avatar` varchar(45) NOT NULL,
  `phone` varchar(16) NOT NULL,
  `verify_email` varchar(255) DEFAULT NULL,
  `verify_email_code` varchar(40) DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UniqueEmail` (`email`),
  UNIQUE KEY `UniqueVerifyEmailCode` (`verify_email_code`) USING BTREE,
  KEY `Status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


-- ----------------------------
-- Table structure for re_account_roles_rules
-- ----------------------------
DROP TABLE IF EXISTS `re_account_roles_rules`;
CREATE TABLE `re_account_roles_rules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL,
  `rule_id` int(11) NOT NULL,
  `type` enum('allow','deny') NOT NULL DEFAULT 'allow',
  PRIMARY KEY (`id`),
  UNIQUE KEY `UniqueRuleForRolwWithType` (`role_id`,`rule_id`,`type`),
  KEY `Role` (`role_id`),
  KEY `Rule` (`rule_id`),
  KEY `Type` (`type`),
  CONSTRAINT `RolesRules_Role` FOREIGN KEY (`role_id`) REFERENCES `re_account_role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `RolesRules_Rule` FOREIGN KEY (`rule_id`) REFERENCES `re_account_rule` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


-- ----------------------------
-- Table structure for re_account_users_roles
-- ----------------------------
DROP TABLE IF EXISTS `re_account_users_roles`;
CREATE TABLE `re_account_users_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UniqueRoleForUser` (`user_id`,`role_id`),
  KEY `User` (`user_id`),
  KEY `Role` (`role_id`),
  CONSTRAINT `UsersRoles_Role` FOREIGN KEY (`role_id`) REFERENCES `re_account_role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `UsersRoles_User` FOREIGN KEY (`user_id`) REFERENCES `re_account_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `re_place`;
CREATE TABLE `re_place` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `is_deleted` enum('0','1') NOT NULL DEFAULT '0',
  `status` enum('0','1') NOT NULL DEFAULT '0',
  `date_created` int(11) NOT NULL,
  `type` enum('default','without_ps','info_page') NOT NULL DEFAULT 'default',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `status` (`status`),
  KEY `type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `re_account_roles_places`;
CREATE TABLE `re_account_roles_places` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL,
  `place_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UniquePlaceForRole` (`role_id`,`place_id`),
  KEY `Role` (`role_id`),
  KEY `Place` (`place_id`),
  CONSTRAINT `RolesPlaces_Place` FOREIGN KEY (`place_id`) REFERENCES `re_place` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `RolesPlaces_Role` FOREIGN KEY (`role_id`) REFERENCES `re_account_role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

INSERT INTO `re_account_user` VALUES (95, 'personal', 'active', 'Join', 'Smitt', '', 'j.smitt@artox.com', '4a81edfb54dd8e97e8aad8cb12838ad33fac259f', '3dl0kz4i', '', '', NULL, NULL, NULL);
INSERT INTO `re_account_user` VALUES (96, 'personal', 'active', 'Join2', 'Smitt2', '', 'j.smitt2@artox.com', '4a81edfb54dd8e97e8aad8cb12838ad33fac259e', '3dl0kz4a', '', '', NULL, NULL, NULL);

INSERT INTO `re_account_role` VALUES (13, 'Developer', 'user', null, '0', '0', 'places');
INSERT INTO `re_account_role` VALUES (17943, 'Developer: Join Smitt', 'user', 13, '0', '0', 'places');
INSERT INTO `re_account_role` VALUES (17944, 'Developer: Join2 Smitt2', 'user', 13, '0', '0', 'places');

INSERT INTO `re_account_rule` VALUES (1, 'Каталог', 'admin/catalog', null, 8);
INSERT INTO `re_account_rule` VALUES (2, 'Фильтры', 'admin/catalog/productFilters', 1, 8);
INSERT INTO `re_account_rule` VALUES (3, 'Отзывы', 'admin/catalog/reviews', 1, 8);
INSERT INTO `re_account_rule` VALUES (4, 'Доступны все заведения', 'admin/cmscatalog/places/viewallplaces', 1, 12);
INSERT INTO `re_account_rule` VALUES (273, 'Изменение значений фильтра типа \'Инпут\'', 'admin/catalog/productFilters/inputvalues', 2, 8);
INSERT INTO `re_account_rule` VALUES (283, 'Изменение значений фильтра типа \'Инпут с измерением\'', 'admin/catalog/productFilters/rangevalues', 1, 9);
INSERT INTO `re_account_rule` VALUES (363, 'Объединение фильтров', 'admin/catalog/productFilters/merge', 2, 10);
INSERT INTO `re_account_rule` VALUES (373, 'Изменение типа фильтра', 'admin/catalog/productFilters/edittype', 2, 11);
INSERT INTO `re_account_rule` VALUES (393, 'Уведомлять о новых отзывах', 'admin/catalog/reviews/sendReview', 3, 1);
INSERT INTO `re_account_rule` VALUES (403, 'Уведомлять о новых отзывах на модерации', 'admin/catalog/reviews/sendReviewModeration', 3, 2);
INSERT INTO `re_account_rule` VALUES (413, 'Уведомлять об изменениях на ПС', 'admin/catalog/places/sendpersonalchanges', 3, 3);

INSERT INTO `re_account_roles_rules` VALUES (78233, 13, 363, 'deny');
INSERT INTO `re_account_roles_rules` VALUES (78243, 17943, 273, 'allow');
INSERT INTO `re_account_roles_rules` VALUES (78253, 17943, 283, 'allow');
INSERT INTO `re_account_roles_rules` VALUES (78263, 17943, 363, 'allow');
INSERT INTO `re_account_roles_rules` VALUES (78273, 17943, 373, 'allow');
INSERT INTO `re_account_roles_rules` VALUES (84583, 17943, 393, 'deny');
INSERT INTO `re_account_roles_rules` VALUES (84593, 17943, 403, 'deny');
INSERT INTO `re_account_roles_rules` VALUES (84603, 17943, 413, 'deny');
INSERT INTO `re_account_roles_rules` VALUES (84604, 17944, 4, 'allow');

INSERT INTO `re_account_users_roles` VALUES (17263, 95, 17943);
INSERT INTO `re_account_users_roles` VALUES (17264, 95, 13);
INSERT INTO `re_account_users_roles` VALUES (17265, 96, 17944);
INSERT INTO `re_account_users_roles` VALUES (17266, 96, 13);

INSERT INTO `re_place` VALUES (1, '0', '1', 1441270596, 'default');
INSERT INTO `re_place` VALUES (2, '0', '1', 1441270596, 'default');
INSERT INTO `re_place` VALUES (3, '0', '1', 1441270596, 'default');

INSERT INTO `re_account_roles_places` VALUES (1, 13, 1);
INSERT INTO `re_account_roles_places` VALUES (2, 13, 2);

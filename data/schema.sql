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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8

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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8
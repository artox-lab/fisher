INSERT INTO `re_account_user` VALUES (95, 'personal', 'active', 'Join', 'Smitt', '', 'j.smitt@artox.com', '4a81edfb54dd8e97e8aad8cb12838ad33fac259f', '3dl0kz4i', '', '', NULL, NULL, NULL);

INSERT INTO `re_account_role` VALUES (13, 'Developer', 'user', null, '0', '0', 'places');
INSERT INTO `re_account_role` VALUES (17943, 'Developer: Join Smitt', 'user', 13, '0', '0', 'places');

INSERT INTO `re_account_rule` VALUES (1, 'Каталог', 'admin/catalog', null, 8);
INSERT INTO `re_account_rule` VALUES (2, 'Фильтры', 'admin/catalog/productFilters', 1, 8);
INSERT INTO `re_account_rule` VALUES (3, 'Отзывы', 'admin/catalog/reviews', 1, 8);
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

INSERT INTO `re_account_users_roles` VALUES (17263, 95, 17943);
INSERT INTO `re_account_users_roles` VALUES (17264, 95, 13);

INSERT INTO `re_place` VALUES (1, '0', '1', 1441270596, 'default');
INSERT INTO `re_place` VALUES (2, '0', '1', 1441270596, 'default');
INSERT INTO `re_place` VALUES (3, '0', '1', 1441270596, 'default');

INSERT INTO `re_account_roles_places` VALUES (1, 13, 1);
INSERT INTO `re_account_roles_places` VALUES (2, 13, 2);

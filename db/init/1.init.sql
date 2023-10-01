DROP DATABASE IF EXISTS circle;
CREATE DATABASE circle;
USE circle;

CREATE TABLE `account_t` (
    `account_id` varchar(128) NOT NULL,
    `email` varchar(128) NOT NULL,
    `password` varchar(128) NOT NULL,
    `last_name` varchar(32) NOT NULL,
    `first_name` varchar(32) NOT NULL,
    `nick_name` varchar(32) NOT NULL,
    `age` int NOT NULL,
    `gender` varchar(32) NOT NULL,
    `image_url` varchar(512) DEFAULT NULL,
    `deleted_time` datetime DEFAULT NULL,
    `register_time` datetime DEFAULT CURRENT_TIMESTAMP,
    `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`account_id`),
    UNIQUE KEY `unique_email` (`email`),
    KEY `idx_email` (`email`)
);

CREATE TABLE like_t (
    `like_id` varchar(128) NOT NULL,
    `from_account_id` varchar(128) NOT NULL,
    `to_account_id` varchar(128) NOT NULL,
    `status` varchar(16) NOT NULL,
    `register_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`like_id`),
    FOREIGN KEY (`from_account_id`) REFERENCES `account_t`(`account_id`),
    FOREIGN KEY (`to_account_id`) REFERENCES `account_t`(`account_id`),
    KEY `idx_from_to_account_id` (`from_account_id`, `to_account_id`)
);

CREATE TABLE matching_t (
    `matching_id` varchar(128) NOT NULL,
    `account_id_1` varchar(128) NOT NULL,
    `account_id_2` varchar(128) NOT NULL,
    `register_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`matching_id`),
    FOREIGN KEY (`account_id_1`) REFERENCES `account_t`(`account_id`),
    FOREIGN KEY (`account_id_2`) REFERENCES `account_t`(`account_id`),
    KEY `idx_account_id_1_2` (`account_id_1`, `account_id_2`)
);

CREATE TABLE `message_t` (
    `message_id` varchar(128) NOT NULL,
    `matching_id` varchar(128) NOT NULL,
    `account_id` varchar(128) NOT NULL,
    `message` text NOT NULL,
    `register_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`message_id`),
    FOREIGN KEY (`matching_id`) REFERENCES `matching_t`(`matching_id`),
    FOREIGN KEY (`account_id`) REFERENCES `account_t`(`account_id`),
    KEY `idx_matching_id` (`matching_id`)
);

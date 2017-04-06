--
-- This SQL script will prepare a *clean* (fresh install) PHPIPAM database so
-- that it is ready to run the integration tests included in this project.
--
-- Specifically, it does the following:
--  * Changes the admin password to "foo12345"
--  * Enables the API and configures a "test" API integration with no
--    encryption code, no ecawncryption requirements, and read/write access to the
--    application (not admin)
--  * Adds custom fields to the IP address, subnets, and VLAN tables
--
-- This script, and the phpipam-sdk-go-testacc test suite, are designed to
-- prepare an instance for integration testing with the PHPIPAM Go SDK, which
-- can be found at https://github.com/paybyphone/phpipam-sdk-go.
--

-- Custom fields
ALTER TABLE `ipaddresses` ADD COLUMN `CustomTestAddresses` varchar(255) CHARACTER SET utf8 COMMENT 'Test field for addresses controller';
ALTER TABLE `subnets` ADD COLUMN `CustomTestSubnets` varchar(255) CHARACTER SET utf8 COMMENT 'Test field for subnets controller';
ALTER TABLE `vlans` ADD COLUMN `CustomTestVLANs` varchar(255) CHARACTER SET utf8 COMMENT 'Test field for vlans controller';

-- API
UPDATE `settings` SET `api`='1' WHERE `id`='1';
INSERT INTO `api` VALUES (1,'test',NULL,2,NULL,'none');

-- User password
UPDATE `users` SET `password`='$6$rounds=3000$Y4skrNG25L9sM3yf$PyZuB0kOy0tgg5Ju1pFve1cJ7QSEbAwxC.4u7YO.YIC6SmhmZXZrsIqFJOiF0rBcj1zu5N9egRK4Pvn2X6xE11', `passChange`='No' WHERE `id`='1';

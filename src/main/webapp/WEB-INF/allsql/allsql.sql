drop table if exists bi_static_cost;
drop table if exists bi_static_delay;
drop table if exists bi_shop;
drop table if exists bi_shop_category;
drop table if exists bi_user;
drop table if exists bi_user_info;

/*大数据相关，txt解析出的表*/
CREATE TABLE `bi_visitor` (
	`id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
	`ipv4` VARCHAR(50) NOT NULL COMMENT '用户标识' COLLATE 'utf8_bin',
	`acr` VARCHAR(255) NOT NULL COMMENT 'acr',
	`eci` VARCHAR(255) NOT NULL COMMENT 'eci',
	`gender` VARCHAR(50) NOT NULL COMMENT '性别' COLLATE 'utf8_bin',
	`age` VARCHAR(50) NOT NULL COMMENT '年龄',
	`localAddress` VARCHAR(255) NOT NULL COMMENT '归属地' COLLATE 'utf8_bin',
	`homeAddress` VARCHAR(255) NOT NULL COMMENT '居住地' COLLATE 'utf8_bin',
	`workAddress` VARCHAR(255) NOT NULL COMMENT '工作地' COLLATE 'utf8_bin',
	`expendAbility` VARCHAR(50) NOT NULL COMMENT '消费能力',
	`time` DATE NOT NULL COMMENT '时间日期',
	PRIMARY KEY (`id`)
)
COLLATE='utf8_general_ci';


/*用户信息表*/
CREATE TABLE `bi_user_info` (
	`id` VARCHAR(50) NOT NULL COMMENT '主键，对应location中的ip' COLLATE 'utf8_bin',
	`userName` VARCHAR(50) NOT NULL COMMENT '用户名，不可重复' COLLATE 'utf8_bin',
	`gender` INT(11) NULL DEFAULT NULL COMMENT '性别：0男 1女',
	`hobby` VARCHAR(255) NULL DEFAULT NULL COMMENT '爱好' COLLATE 'utf8_bin',
	`birthday` DATETIME NULL DEFAULT NULL COMMENT '生日，可以得出岁数',
	`headPhoto` VARCHAR(255) NULL DEFAULT NULL COMMENT '头像图片URL' COLLATE 'utf8_bin',
	`profession` VARCHAR(50) NULL DEFAULT NULL COMMENT '职业' COLLATE 'utf8_bin',
	`updateTime` DATETIME NULL DEFAULT NULL COMMENT '更新日期',
	`createTime` DATETIME NULL DEFAULT NULL COMMENT '创建日期',
	PRIMARY KEY (`id`),
	UNIQUE INDEX `Index 3` (`userName`)
)
COLLATE='utf8_bin';



/*商铺类别表*/
CREATE TABLE `bi_shop_category` (
	`id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
	`name` VARCHAR(50) NOT NULL COMMENT '分类名称' COLLATE 'utf8_bin',
	`updateTime` DATETIME NULL DEFAULT NULL,
	`createTime` DATETIME NULL DEFAULT NULL,
	`x` DECIMAL(10,2) NOT NULL DEFAULT '0.00',
	`y` DECIMAL(10,2) NOT NULL DEFAULT '0.00',
	`deepTime` INT(11) NOT NULL DEFAULT '0',
	`visitorNumber` INT(11) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`),
	UNIQUE INDEX `name` (`name`) USING BTREE
)
COLLATE='utf8_bin';

CREATE TABLE `bi_store` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL COLLATE 'utf8_bin',
    `updateTime` DATETIME NOT NULL,
    `createTime` DATETIME NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `name` (`name`)
)
COLLATE='utf8_unicode_ci';



CREATE TABLE `bi_maps` (
    `floor` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
    `xo` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
    `yo` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
    `scale` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
    `coordinate` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
    `angle` FLOAT NULL DEFAULT '0',
    `path` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
    `svg` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
    `navi` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
    `storeId` INT(11) NOT NULL,
    `mapId` VARCHAR(50) NOT NULL COLLATE 'utf8_unicode_ci',
    `imgWidth` INT(11) NOT NULL,
    `imgHeight` INT(11) NOT NULL,
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `updateTime` VARCHAR(50) NOT NULL COLLATE 'utf8_unicode_ci',
    `createTime` DATETIME NOT NULL,
    `mapType` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
    PRIMARY KEY (`id`),
    UNIQUE INDEX `mapId` (`mapId`),
    INDEX `Index 1` (`id`),
    INDEX `FK_bi_maps_bi_store` (`storeId`),
    INDEX `Index 3` (`mapId`),
    CONSTRAINT `FK_bi_maps_bi_store` FOREIGN KEY (`storeId`) REFERENCES `bi_store` (`id`) ON UPDATE CASCADE ON DELETE CASCADE
)
COMMENT='地图信息'
COLLATE='utf8_unicode_ci';


CREATE TABLE `bi_shop` (
	`id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
	`shopName` VARCHAR(255) NOT NULL COMMENT '商铺名字' COLLATE 'utf8_bin',
	`mapId` VARCHAR(50) NULL DEFAULT NULL COMMENT '楼层id' COLLATE 'utf8_unicode_ci',
	`xSpot` DECIMAL(10,2) NOT NULL COMMENT '对角点x',
	`ySpot` DECIMAL(10,2) NOT NULL COMMENT '对角点y',
	`description` VARCHAR(255) NULL DEFAULT NULL COMMENT '商铺描述' COLLATE 'utf8_bin',
	`status` INT(11) NOT NULL DEFAULT '0' COMMENT '0营业，1休息，2转让中，3已删除',
	`zoneId` VARCHAR(50) NULL DEFAULT NULL COMMENT '预留' COLLATE 'utf8_bin',
	`x1Spot` DECIMAL(10,2) NOT NULL COMMENT '对角点x1',
	`y1Spot` DECIMAL(10,2) NOT NULL COMMENT '对角点y1',
	`categoryId` INT(11) NULL DEFAULT NULL COMMENT '商铺类型，shopcategory表中Id外键',
	`isVip` VARCHAR(50) NULL DEFAULT NULL COMMENT '预留，是否为vip' COLLATE 'utf8_bin',
	`updateTime` DATETIME NULL DEFAULT NULL,
	`createTime` DATETIME NOT NULL,
	PRIMARY KEY (`id`),
	INDEX `fk_category` (`categoryId`),
	INDEX `fk_shop_map` (`mapId`),
	CONSTRAINT `fk_shop_category` FOREIGN KEY (`categoryId`) REFERENCES `bi_shop_category` (`id`) ON UPDATE CASCADE ON DELETE SET NULL,
	CONSTRAINT `fk_shop_map` FOREIGN KEY (`mapId`) REFERENCES `bi_maps` (`mapId`) ON UPDATE CASCADE ON DELETE SET NULL
)
COLLATE='utf8_bin';




/*驻留记录表*/
CREATE TABLE `bi_static_delay` (
	`shopId` INT(11) NOT NULL COMMENT 'shop表中id外键',
	`createTime` DATETIME NOT NULL,
	`duration` BIGINT(20) NOT NULL COMMENT '驻留时长，单位分',
	`userId` VARCHAR(50) NOT NULL COMMENT 'userinfo表中id外键' COLLATE 'utf8_bin',
	`id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
	PRIMARY KEY (`id`),
	INDEX `fk2_delay_userId` (`userId`),
	INDEX `fk1_delay_shopId` (`shopId`),
	CONSTRAINT `fk1_delay_shopId` FOREIGN KEY (`shopId`) REFERENCES `bi_shop` (`id`) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT `fk2_delay_userId` FOREIGN KEY (`userId`) REFERENCES `bi_user_info` (`id`) ON UPDATE CASCADE ON DELETE CASCADE
)
COLLATE='latin1_swedish_ci';





/*消费记录表*/
CREATE TABLE `bi_static_cost` (
	`shopId` INT(11) NOT NULL COMMENT 'shop表中id外键',
	`createTime` DATETIME NOT NULL,
	`spending` DECIMAL(10,2) NOT NULL COMMENT '消费额',
	`userId` VARCHAR(50) NOT NULL COMMENT 'userinfo表中id外键' COLLATE 'utf8_bin',
	`id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
	PRIMARY KEY (`id`),
	INDEX `fk2_cost_userId` (`userId`),
	INDEX `fk1_cost_shopId` (`shopId`),
	CONSTRAINT `fk1_cost_shopId` FOREIGN KEY (`shopId`) REFERENCES `bi_shop` (`id`) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT `fk2_cost_userId` FOREIGN KEY (`userId`) REFERENCES `bi_user_info` (`id`) ON UPDATE CASCADE ON DELETE CASCADE
)
COLLATE='latin1_swedish_ci';


CREATE TABLE `bi_static_store_delay` (
    `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
    `time` DATE NOT NULL COMMENT '时间',
    `delaytime` DECIMAL(10,2) NOT NULL COMMENT '平均驻留时长',
    `allcount` BIGINT(20) NOT NULL COMMENT '客流总人数',
    `storeId` INT(11) NOT NULL COMMENT '商场id',
    `type` INT(11) NOT NULL DEFAULT '0' COMMENT '0:按日，1按月',
    PRIMARY KEY (`storeId`, `time`, `type`),
    INDEX `Index 1` (`id`)
)
COLLATE='utf8_bin';


CREATE TABLE `bi_pre_peope_route` (
    `userId` VARCHAR(50) NOT NULL COLLATE 'utf8_unicode_ci',
    `shopId` INT(11) NOT NULL,
    `time` DATETIME NOT NULL
)
COLLATE='utf8_unicode_ci';


CREATE TABLE `bi_peripheral_service` (
	`id` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_bin',
	`category` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_bin',
	`shopAddress` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_bin',
	`maxPath` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_bin',
	`distance` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_bin',
	`peripheryCategory` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_bin',
	`path` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_bin',
	`storeId` VARCHAR(50) NULL DEFAULT '0' COLLATE 'utf8_bin',
	`shopName` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_bin',
	`phoneNumber` VARCHAR(50) NULL DEFAULT '0' COLLATE 'utf8_bin',
	`businessHours` VARCHAR(50) NULL DEFAULT '0' COLLATE 'utf8_bin',
	UNIQUE INDEX `Index 1` (`id`)
)
COLLATE='utf8_bin';

CREATE TABLE `bi_ticket` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `shopName` INT(11) NOT NULL DEFAULT '0',
    `floorName` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8_unicode_ci',
    `ticketName` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8_unicode_ci',
    `creatTime` DATETIME NULL DEFAULT NULL,
    `chanceName` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8_unicode_ci',
    `imageWidth` INT(11) NOT NULL DEFAULT '0',
    `imageHigth` INT(11) NOT NULL DEFAULT '0',
    INDEX `Index 1` (`id`),
    INDEX `FK_bi_ticket_bi_shop` (`shopName`),
    INDEX `FK_bi_ticket_bi_maps` (`floorName`),
    CONSTRAINT `FK_bi_ticket_bi_maps` FOREIGN KEY (`floorName`) REFERENCES `bi_maps` (`mapId`) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT `FK_bi_ticket_bi_shop` FOREIGN KEY (`shopName`) REFERENCES `bi_shop` (`id`) ON UPDATE CASCADE ON DELETE CASCADE
)
COLLATE='utf8_bin';

CREATE TABLE `bi_leavemessage` (
    `id` VARCHAR(50) NOT NULL COMMENT '游客id' COLLATE 'utf8_bin',
    `msg` TEXT NOT NULL COLLATE 'utf8_bin',
    `uploadTime` DATETIME NOT NULL,
    `mapId` VARCHAR(50) NOT NULL COLLATE 'utf8_bin'
)
COLLATE='utf8_bin';


CREATE TABLE `bi_location_20170718` (
    `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
    `userId` VARCHAR(50) NOT NULL COMMENT '用户id',
    `mapId` VARCHAR(50) NOT NULL COMMENT '地图id' COLLATE 'utf8_bin',
    `x` DECIMAL(10,0) NULL DEFAULT NULL COMMENT 'x坐标',
    `y` DECIMAL(10,0) NULL DEFAULT NULL COMMENT 'y坐标',
    `idType` VARCHAR(50) NULL DEFAULT NULL COMMENT '订阅类型',
    `dataType` VARCHAR(50) NULL DEFAULT NULL,
    `timestamp` BIGINT(20) NULL DEFAULT NULL COMMENT '本地时间戳',
    `time_sva` BIGINT(20) NULL DEFAULT NULL COMMENT 'sva时间戳',
    PRIMARY KEY (`id`)
)
COLLATE='latin1_swedish_ci';

CREATE TABLE `bi_locationphone` (
    `idType` VARCHAR(50) NULL DEFAULT NULL,
    `timestamp` BIGINT(20) NULL DEFAULT NULL,
    `time_sva` BIGINT(20) NULL DEFAULT NULL,
    `dataType` VARCHAR(50) NULL DEFAULT NULL,
    `x` DECIMAL(10,2) NULL DEFAULT NULL,
    `y` DECIMAL(10,2) NULL DEFAULT NULL,
    `mapId` DECIMAL(10,0) NULL DEFAULT NULL,
    `userID` VARCHAR(50) NOT NULL,
    PRIMARY KEY (`userID`)
)
COLLATE='latin1_swedish_ci';

CREATE TABLE `bi_footprints` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `msg` TEXT NOT NULL COLLATE 'utf8_bin',
    `mapId` VARCHAR(50) NOT NULL COLLATE 'utf8_bin',
    `path` VARCHAR(50) NOT NULL COLLATE 'utf8_bin',
    `shopId` VARCHAR(50) NOT NULL COLLATE 'utf8_bin',
    `x` DECIMAL(10,2) NULL DEFAULT NULL,
    `y` DECIMAL(10,2) NULL DEFAULT NULL,
    `uploadTime` DATETIME NOT NULL,
    INDEX `Index 1` (`id`)
)
COLLATE='latin1_swedish_ci';


/*系统cpu信息表*/
CREATE TABLE `bi_cmd` (
	`id` BIGINT(20) UNSIGNED ZEROFILL NOT NULL AUTO_INCREMENT,
	`cpuParameter` INT(10) UNSIGNED ZEROFILL NULL DEFAULT NULL,
	`lastTime` BIGINT(20) UNSIGNED ZEROFILL NULL DEFAULT NULL,
	INDEX `Index 1` (`id`)
)
COLLATE='latin1_swedish_ci';

CREATE TABLE `bi_newuser` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`time` DATE NOT NULL,
	`newUser` INT(11) NOT NULL,
	`todayUser` INT(11) NOT NULL,
	`yesdayUser` INT(11) NOT NULL,
	`shopId` INT(11) NULL DEFAULT '0',
	`storeId` INT(11) NULL DEFAULT '0',
	`mapId` INT(11) NULL DEFAULT '0',
	INDEX `Index 1` (`id`)
)
COLLATE='latin1_swedish_ci';

CREATE TABLE `bi_parkinginformation` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`storeId` INT(11) NOT NULL DEFAULT '0',
	`parkingNumber` VARCHAR(50) NOT NULL,
	`entryTime` BIGINT(20) NULL DEFAULT NULL,
	`outTime` BIGINT(20) NULL DEFAULT NULL,
	`plateNumber` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`mapId` VARCHAR(50) NOT NULL,
	`isTrue` INT(11) NOT NULL DEFAULT '0' COMMENT '0：空车位，1：非空车位',
	`userName` VARCHAR(50) NULL DEFAULT NULL,
	`x` DECIMAL(10,2) NULL DEFAULT NULL,
	`y` DECIMAL(10,2) NULL DEFAULT NULL,
	PRIMARY KEY (`mapId`, `parkingNumber`),
	INDEX `Index 1` (`id`)
)
COMMENT='0:空车位  1：非空车位'
COLLATE='latin1_swedish_ci';


CREATE TABLE `geofencing` (
	`IdType` VARCHAR(50) NOT NULL,
	`time_local` VARCHAR(50) NULL DEFAULT NULL,
	`userid` VARCHAR(50) NOT NULL,
	`mapid` BIGINT(20) NOT NULL,
	`zoneid` BIGINT(20) NOT NULL,
	`enter` VARCHAR(50) NOT NULL,
	`Timestamp` BIGINT(20) NOT NULL
)
COLLATE='latin1_swedish_ci';

CREATE TABLE `prrusignal` (
	`id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
	`gpp` VARCHAR(50) NULL DEFAULT NULL COMMENT '柜框槽号' COLLATE 'utf8_unicode_ci',
	`rsrp` DECIMAL(10,2) NULL DEFAULT NULL COMMENT '信号值',
	`userId` VARCHAR(50) NULL DEFAULT NULL COMMENT '用户id' COLLATE 'utf8_unicode_ci',
	`enbid` VARCHAR(50) NULL DEFAULT NULL COMMENT 'enodeBid' COLLATE 'utf8_unicode_ci',
	`timestamp` BIGINT(20) NULL DEFAULT NULL COMMENT '插入时间戳',
	PRIMARY KEY (`id`)
)
COMMENT='prru信号数据'
COLLATE='utf8_unicode_ci';

-- 导出  表 sva1.bi_parkinginformation 结构
CREATE TABLE IF NOT EXISTS `bi_parkinginformation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `storeId` int(11) NOT NULL DEFAULT '0',
  `parkingNumber` varchar(50) NOT NULL,
  `entryTime` bigint(20) DEFAULT NULL,
  `outTime` bigint(20) DEFAULT NULL,
  `plateNumber` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `mapId` varchar(50) NOT NULL,
  `isTrue` int(11) NOT NULL DEFAULT '0' COMMENT '0：空车位，1：非空车位',
  `userName` varchar(50) DEFAULT NULL,
  `x` decimal(10,2) DEFAULT NULL,
  `y` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`mapId`,`parkingNumber`),
  KEY `Index 1` (`id`)
) DEFAULT CHARSET=latin1 COMMENT='0:空车位  1：非空车位';

CREATE TABLE `bi_trend_map_day` (
	`id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
	`mapId` VARCHAR(50) NOT NULL COMMENT '统计的mapId' COLLATE 'utf8_unicode_ci',
	`fromMapId` VARCHAR(50) NULL DEFAULT NULL COMMENT '来源mapId' COLLATE 'utf8_unicode_ci',
	`visitorCount` BIGINT(20) NOT NULL COMMENT '客流量',
	`day` INT(11) NOT NULL COMMENT '日期，天，1到31',
	`time` DATE NOT NULL COMMENT '日期',
	PRIMARY KEY (`id`),
	INDEX `FK_bi_trend_map_day_bi_maps_1` (`mapId`),
	INDEX `FK_bi_trend_map_day_bi_maps_2` (`fromMapId`),
	CONSTRAINT `FK_bi_trend_map_day_bi_maps_1` FOREIGN KEY (`mapId`) REFERENCES `bi_maps` (`mapId`) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT `FK_bi_trend_map_day_bi_maps_2` FOREIGN KEY (`fromMapId`) REFERENCES `bi_maps` (`mapId`) ON UPDATE CASCADE ON DELETE CASCADE
)
COLLATE='latin1_swedish_ci';

CREATE TABLE `bi_trend_map_hour` (
	`id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
	`mapId` VARCHAR(50) NOT NULL COMMENT '统计的mapId' COLLATE 'utf8_unicode_ci',
	`fromMapId` VARCHAR(50) NULL DEFAULT NULL COMMENT '来源mapId' COLLATE 'utf8_unicode_ci',
	`visitorCount` BIGINT(20) NOT NULL COMMENT '客流量',
	`hour` INT(11) NOT NULL COMMENT '整点，1到24',
	`time` DATE NOT NULL COMMENT '日期',
	PRIMARY KEY (`id`),
	INDEX `FK_bi_trend_map_hour_bi_maps_1` (`mapId`),
	INDEX `FK_bi_trend_map_hour_bi_maps_2` (`fromMapId`),
	CONSTRAINT `FK_bi_trend_map_hour_bi_maps_1` FOREIGN KEY (`mapId`) REFERENCES `bi_maps` (`mapId`) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT `FK_bi_trend_map_hour_bi_maps_2` FOREIGN KEY (`fromMapId`) REFERENCES `bi_maps` (`mapId`) ON UPDATE CASCADE ON DELETE CASCADE
)
COLLATE='latin1_swedish_ci';


CREATE TABLE `bi_trend_shop_day` (
    `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
    `shopId` INT(11) NOT NULL COMMENT '统计的shopId',
    `fromShopId` VARCHAR(50) NULL DEFAULT NULL,
    `visitorCount` BIGINT(20) NOT NULL COMMENT '客流量',
    `day` INT(11) NOT NULL COMMENT '日期，天，1到31',
    `time` DATE NOT NULL COMMENT '日期',
    PRIMARY KEY (`id`),
    INDEX `FK_bi_trend_shop_day_bi_shop` (`shopId`),
    CONSTRAINT `FK_bi_trend_shop_day_bi_shop` FOREIGN KEY (`shopId`) REFERENCES `bi_shop` (`id`) ON UPDATE CASCADE ON DELETE CASCADE
)
COLLATE='latin1_swedish_ci';


CREATE TABLE `bi_trend_shop_hour` (
    `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
    `shopId` INT(11) NOT NULL COMMENT '统计的shopId',
    `fromShopId` VARCHAR(50) NULL DEFAULT NULL COMMENT '来源shopId，其他为-1',
    `visitorCount` BIGINT(20) NOT NULL COMMENT '客流量',
    `hour` INT(11) NOT NULL COMMENT '整点，1到24',
    `time` DATE NOT NULL COMMENT '日期',
    PRIMARY KEY (`id`),
    INDEX `FK_bi_trend_shop_hour_bi_shop` (`shopId`),
    CONSTRAINT `FK_bi_trend_shop_hour_bi_shop` FOREIGN KEY (`shopId`) REFERENCES `bi_shop` (`id`) ON UPDATE CASCADE ON DELETE CASCADE
)
COLLATE='latin1_swedish_ci';

CREATE TABLE `bi_user` (
	`id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
	`userName` VARCHAR(50) NULL DEFAULT NULL COMMENT '账户名' COLLATE 'utf8_bin',
	`password` VARCHAR(50) NULL DEFAULT NULL COMMENT '加密过后的密码' COLLATE 'utf8_unicode_ci',
	`openid` VARCHAR(50) NULL DEFAULT NULL COMMENT '三方授权openid' COLLATE 'utf8_unicode_ci',
	`nickName` VARCHAR(50) NULL DEFAULT NULL COMMENT '昵称' COLLATE 'utf8_bin',
	`phone` VARCHAR(50) NULL DEFAULT NULL COMMENT '手机号' COLLATE 'utf8_unicode_ci',
	`email` VARCHAR(50) NULL DEFAULT NULL COMMENT '邮箱' COLLATE 'utf8_unicode_ci',
	`gender` INT(2) NULL DEFAULT NULL COMMENT '1为男，2为女',
	`address` VARCHAR(255) NULL DEFAULT NULL COMMENT '所在地' COLLATE 'utf8_bin',
	`birthday` DATE NULL DEFAULT NULL COMMENT '生日',
	`lastLoginTime` DATETIME NULL DEFAULT NULL COMMENT '上次登录时间',
	`createTime` DATETIME NULL DEFAULT NULL COMMENT '注册时间',
	`updateTime` DATETIME NULL DEFAULT NULL COMMENT '更改时间',
	PRIMARY KEY (`id`),
	UNIQUE INDEX `phone` (`phone`),
	UNIQUE INDEX `email` (`email`),
	UNIQUE INDEX `userName` (`userName`)
)
COLLATE='utf8_bin';




-- 正在导出表  sva1.bi_parkinginformation 的数据：~4 rows (大约)
/*!40000 ALTER TABLE `bi_parkinginformation` DISABLE KEYS */;
INSERT INTO `bi_parkinginformation` (`id`, `storeId`, `parkingNumber`, `entryTime`, `outTime`, `plateNumber`, `mapId`, `isTrue`, `userName`, `x`, `y`) VALUES
	(5, 1, 'H2-001', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(6, 1, 'H2-002', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(7, 1, 'H2-003', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(8, 1, 'H2-004', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(9, 1, 'H2-005', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(10, 1, 'H2-006', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(11, 1, 'H2-007', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(12, 1, 'H2-008', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(13, 1, 'H2-009', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(14, 1, 'H2-010', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(15, 1, 'H2-011', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(16, 1, 'H2-012', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(17, 1, 'H2-013', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(18, 1, 'H2-014', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(19, 1, 'H2-015', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(20, 1, 'H2-016', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(21, 1, 'H2-017', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(22, 1, 'H2-018', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(23, 1, 'H2-019', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(24, 1, 'H2-020', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(25, 1, 'H2-021', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(26, 1, 'H2-022', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(27, 1, 'H2-023', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(28, 1, 'H2-024', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(29, 1, 'H2-025', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(30, 1, 'H2-026', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(31, 1, 'H2-027', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(32, 1, 'H2-028', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(33, 1, 'H2-029', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(34, 1, 'H2-030', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(35, 1, 'H2-031', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(36, 1, 'H2-032', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(37, 1, 'H2-034', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(1, 1, 'H2-035', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(2, 1, 'H2-036', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(3, 1, 'H2-038', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(4, 1, 'H2-039', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(38, 1, 'H2-040', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(39, 1, 'H2-041', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(40, 1, 'H2-042', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(41, 1, 'H2-043', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(42, 1, 'H2-044', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(43, 1, 'H2-045', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(44, 1, 'H2-046', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(45, 1, 'H2-047', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(46, 1, 'H2-048', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(47, 1, 'H2-049', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(48, 1, 'H2-050', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(49, 1, 'H2-051', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(50, 1, 'H2-052', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(51, 1, 'H2-053', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(52, 1, 'H2-054', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(53, 1, 'H2-055', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(54, 1, 'H2-056', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(56, 1, 'H2-057', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(57, 1, 'H2-058', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(58, 1, 'H2-059', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(59, 1, 'H2-060', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(60, 1, 'H2-061', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(61, 1, 'H2-062', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(62, 1, 'H2-063', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(63, 1, 'H2-064', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(64, 1, 'H2-065', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(65, 1, 'H2-066', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(66, 1, 'H2-067', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(67, 1, 'H2-068', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(68, 1, 'H2-069', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(69, 1, 'H2-070', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(70, 1, 'H2-071', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(71, 1, 'H2-072', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(72, 1, 'H2-073', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(73, 1, 'H2-074', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(74, 1, 'H2-075', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(75, 1, 'H2-076', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(76, 1, 'H2-077', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(77, 1, 'H2-079', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(78, 1, 'H2-080', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(79, 1, 'H2-081', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(80, 1, 'H2-082', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(81, 1, 'H2-083', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(82, 1, 'H2-084', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(83, 1, 'H2-085', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(84, 1, 'H2-086', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(85, 1, 'H2-087', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(86, 1, 'H2-088', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(87, 1, 'H2-089', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(88, 1, 'H2-090A', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(89, 1, 'H2-090B', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(90, 1, 'H2-090C', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(91, 1, 'H2-091', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(92, 1, 'H2-092', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(93, 1, 'H2-093', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(94, 1, 'H2-094', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(95, 1, 'H2-095', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(96, 1, 'H2-096', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(97, 1, 'H2-097', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(98, 1, 'H2-098', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(99, 1, 'H2-099', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(105, 1, 'H2-10', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(100, 1, 'H2-100', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(101, 1, 'H2-101', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(102, 1, 'H2-102', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(103, 1, 'H2-103', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(104, 1, 'H2-104', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(106, 1, 'H2-105', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(107, 1, 'H2-106', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(108, 1, 'H2-107', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(109, 1, 'H2-108', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(110, 1, 'H2-109', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(111, 1, 'H2-110', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(112, 1, 'H2-111', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(113, 1, 'H2-112', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(114, 1, 'H2-113', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(115, 1, 'H2-114', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(116, 1, 'H2-115', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(117, 1, 'H2-116', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(118, 1, 'H2-117', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(119, 1, 'H2-118', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(120, 1, 'H2-119', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL),
	(121, 1, 'H2-120', NULL, NULL, NULL, '1', 0, NULL, NULL, NULL);
	
CREATE TABLE IF NOT EXISTS `bi_login` (
  `userName` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `password` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `creatTime` datetime NOT NULL,
  `lastLoginTime` datetime DEFAULT NULL
)COLLATE='utf8_bin';

-- 正在导出表  biss.bi_login 的数据：~1 rows (大约)
/*!40000 ALTER TABLE `bi_login` DISABLE KEYS */;
INSERT INTO `bi_login` (`userName`, `password`, `creatTime`, `lastLoginTime`) VALUES
    ('admin', 'admin', '2017-08-10 17:31:06', '2018-06-14 10:02:56'),
    ('guest', 'guest', '2017-08-10 17:31:06', '2018-06-14 10:02:56');

DROP TABLE IF EXISTS `bi_ivas_sva`;
CREATE TABLE IF NOT EXISTS `bi_ivas_sva` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `getTokenUrl` text,
  `appName` varchar(50) NOT NULL,
  `appPassWord` varchar(50) NOT NULL,
  `subscriptionUrl` text,
  `myKey` text,
  `mySecret` text,
  KEY `Index 1` (`id`)
);
INSERT INTO `bi_ivas_sva` (`id`, `getTokenUrl`, `appName`, `appPassWord`, `subscriptionUrl`, `myKey`, `mySecret`) VALUES
    (1, '/49674548-eb03-4298-9487-12f2b6fcd458', 'app3', 'User@123456', '/b75932b0-2774-465c-985e-45521b75f5f3', 'OGJkMDZiNmEtZTgyYy00ZGFILWEwZTYtMDI2YmViNjJhZDMw', 'puhDDCPVhQ0zLfaBaZOpFgEdpv95ddGGIstjFRScFDY');
    
    
    
CREATE TABLE `bi_static_floor` (
	`id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
	`time` DATE NOT NULL COMMENT '时间',
	`delaytime` DECIMAL(10,2) NOT NULL COMMENT '平均驻留时长',
	`allcount` BIGINT(20) NOT NULL COMMENT '客流总人数',
	`mapId` INT(11) NOT NULL COMMENT '商场id',
	PRIMARY KEY (`mapId`, `time`),
	INDEX `Index 1` (`id`)
)
COLLATE='utf8_bin';    

CREATE TABLE `bi_mixing` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `mapId` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_bin',
    `storeId` INT(11) NULL DEFAULT NULL,
    `storeCode` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_bin',
    `floorCode` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_bin',
    `codeToMapId` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_bin',
    `creatTime` DATETIME NULL DEFAULT NULL,
    INDEX `Index 1` (`id`)
)
COLLATE='utf8_bin';

CREATE TABLE `bi_lac` (
	`id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
	`lac` VARCHAR(50) NOT NULL COMMENT 'lac' COLLATE 'utf8_bin',
	`city` VARCHAR(50) NOT NULL COMMENT '城市' COLLATE 'utf8_bin',
	PRIMARY KEY (`id`)
)
COLLATE='utf8_bin';

CREATE TABLE `bi_static_floor_visittime` (
    `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
    `time` DATETIME NOT NULL COMMENT '时间',
    `delaytime` DECIMAL(10,2) NOT NULL COMMENT '平均驻留时长',
    `allcount` BIGINT(20) NOT NULL COMMENT '客流总人数',
    `allcounts` BIGINT(20) NOT NULL,
    `mapId` VARCHAR(50) NOT NULL COMMENT '商场id' COLLATE 'utf8_bin',
    PRIMARY KEY (`mapId`, `time`),
    INDEX `Index 1` (`id`),
    INDEX `Index 3` (`mapId`)
)
COLLATE='utf8_bin';

CREATE TABLE `bi_static_shop_visittime` (
    `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
    `time` DATETIME NOT NULL COMMENT '时间',
    `delaytime` DECIMAL(10,2) NOT NULL COMMENT '平均驻留时长',
    `allcount` BIGINT(20) NOT NULL COMMENT '客流总人数',
    `allcounts` BIGINT(20) NOT NULL,
    `shopId` VARCHAR(50) NOT NULL COLLATE 'utf8_bin',
    PRIMARY KEY (`shopId`, `time`),
    INDEX `Index 1` (`id`),
    INDEX `Index 3` (`shopId`)
)
COLLATE='utf8_bin';

CREATE TABLE `bi_static_store_visittime` (
    `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
    `time` DATETIME NOT NULL COMMENT '时间',
    `delaytime` DECIMAL(10,2) NOT NULL COMMENT '平均驻留时长',
    `allcount` BIGINT(20) NOT NULL COMMENT '客流总人数',
    `allcounts` BIGINT(20) NOT NULL,
    `storeId` VARCHAR(50) NOT NULL COMMENT '商场id' COLLATE 'utf8_bin',
    PRIMARY KEY (`storeId`, `time`),
    INDEX `Index 1` (`id`),
    INDEX `Index 3` (`storeId`)
)
COLLATE='utf8_bin';

CREATE TABLE `bi_static_userid_visittime` (
    `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
    `time` DATE NOT NULL COMMENT '时间',
    `delaytime` DECIMAL(10,2) NOT NULL COMMENT '平均驻留时长',
    `shopId` INT(11) NOT NULL COMMENT '商场id',
    `userId` VARCHAR(200) NOT NULL COLLATE 'utf8_bin',
    PRIMARY KEY (`shopId`, `time`, `userId`),
    INDEX `Index 1` (`id`),
    INDEX `Index 3` (`shopId`)
)
COLLATE='utf8_bin';

CREATE TABLE `bi_static_shop_count` (
    `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
    `time` DATE NOT NULL COMMENT '时间',
    `shopName` VARCHAR(50) NOT NULL COMMENT '店铺名称' COLLATE 'utf8_bin',
    `allcount` BIGINT(20) NOT NULL COMMENT '客流总人数',
    `shopId` INT(11) NOT NULL COMMENT '商场id',
    PRIMARY KEY (`shopId`, `time`),
    INDEX `Index 1` (`id`),
    INDEX `Index 3` (`shopId`)
)
COLLATE='utf8_bin';
CREATE TABLE `bi_static_shop_enter` (
	`id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
	`time` DATE NOT NULL COMMENT '时间',
	`allcount` BIGINT(20) NOT NULL COMMENT '人数',
	`allcounts` BIGINT(20) NOT NULL COMMENT '总人数',
	`shopId` INT(11) NOT NULL COMMENT '商场id',
	INDEX `Index 1` (`id`),
	INDEX `Index 3` (`shopId`)
)
COLLATE='utf8_bin';
/*
 Navicat Premium Data Transfer

 Source Server         : jeecg-boot-正式
 Source Server Type    : MySQL
 Source Server Version : 80036
 Source Host           : rm-gw0h39o8vnd42ew6axo.mysql.cn-chengdu.rds.aliyuncs.com:13307
 Source Schema         : jeecg-boot

 Target Server Type    : MySQL
 Target Server Version : 80036
 File Encoding         : 65001

 Date: 12/09/2025 12:05:23
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for sys_dict
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict`;
CREATE TABLE `sys_dict` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `dict_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '字典名称',
  `dict_code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '字典编码',
  `description` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '描述',
  `del_flag` int DEFAULT NULL COMMENT '删除状态',
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `type` int(1) unsigned zerofill DEFAULT '0' COMMENT '字典类型0为string,1为number',
  `tenant_id` int DEFAULT '0' COMMENT '租户ID',
  `low_app_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '低代码应用ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_sd_dict_code` (`dict_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='字典配置主表';

-- ----------------------------
-- Table structure for sys_dict_item
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_item`;
CREATE TABLE `sys_dict_item` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `dict_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '字典id',
  `item_text` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '字典项文本',
  `item_value` varchar(3000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '字典项值',
  `item_color` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '字典项颜色',
  `description` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '描述',
  `sort_order` int DEFAULT NULL COMMENT '排序',
  `status` int DEFAULT NULL COMMENT '状态（1启用 0不启用）',
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_sditem_role_dict_id` (`dict_id`) USING BTREE,
  KEY `idx_sditem_role_sort_order` (`sort_order`) USING BTREE,
  KEY `idx_sditem_status` (`status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='字典配置项表';

SET FOREIGN_KEY_CHECKS = 1;

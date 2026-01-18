-- ============================================
-- 自动售货机管理系统数据库脚本
-- 数据库：vending_machine_db
-- 版本：1.0.0
-- ============================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS vending_machine_db 
    DEFAULT CHARACTER SET utf8mb4 
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE vending_machine_db;

-- ============================================
-- 1. 用户表 (users)
-- ============================================
CREATE TABLE IF NOT EXISTS users (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户ID',
    username VARCHAR(50) NOT NULL COMMENT '用户名',
    email VARCHAR(100) NOT NULL COMMENT '邮箱',
    password VARCHAR(255) NOT NULL COMMENT '密码（加密）',
    real_name VARCHAR(50) NOT NULL COMMENT '真实姓名',
    phone VARCHAR(20) NOT NULL COMMENT '手机号',
    role ENUM('SUPER_ADMIN', 'ADMIN', 'OPERATOR', 'TECHNICIAN', 'CUSTOMER') NOT NULL DEFAULT 'CUSTOMER' COMMENT '角色',
    status ENUM('ACTIVE', 'INACTIVE', 'BANNED') NOT NULL DEFAULT 'ACTIVE' COMMENT '状态',
    avatar VARCHAR(255) NULL COMMENT '头像路径',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    UNIQUE KEY uk_username (username),
    UNIQUE KEY uk_email (email),
    KEY idx_role (role),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- ============================================
-- 2. 设备表 (devices)
-- ============================================
CREATE TABLE IF NOT EXISTS devices (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '设备ID',
    device_code VARCHAR(50) NOT NULL COMMENT '设备编码',
    name VARCHAR(100) NOT NULL COMMENT '设备名称',
    location VARCHAR(200) NOT NULL COMMENT '设备位置',
    latitude DECIMAL(10, 8) NOT NULL COMMENT '纬度',
    longitude DECIMAL(11, 8) NOT NULL COMMENT '经度',
    region VARCHAR(50) NOT NULL COMMENT '区域',
    status ENUM('ONLINE', 'OFFLINE', 'MAINTENANCE', 'ERROR') NOT NULL DEFAULT 'OFFLINE' COMMENT '设备状态',
    last_heartbeat DATETIME NULL COMMENT '最后心跳时间',
    total_sales INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '总销量',
    total_revenue DECIMAL(10, 2) NOT NULL DEFAULT 0.00 COMMENT '总营业额',
    utilization_rate DECIMAL(5, 2) NOT NULL DEFAULT 0.00 COMMENT '利用率（百分比）',
    operator_id BIGINT UNSIGNED NULL COMMENT '运营人员ID',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    UNIQUE KEY uk_device_code (device_code),
    KEY idx_region (region),
    KEY idx_status (status),
    KEY idx_operator_id (operator_id),
    CONSTRAINT fk_device_operator FOREIGN KEY (operator_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='设备表';

-- ============================================
-- 3. 产品表 (products)
-- ============================================
CREATE TABLE IF NOT EXISTS products (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '产品ID',
    name VARCHAR(100) NOT NULL COMMENT '产品名称',
    brand VARCHAR(50) NOT NULL COMMENT '品牌',
    category VARCHAR(50) NOT NULL COMMENT '分类',
    description TEXT NULL COMMENT '描述',
    image VARCHAR(255) NULL COMMENT '图片路径',
    price DECIMAL(10, 2) NOT NULL COMMENT '售价',
    cost DECIMAL(10, 2) NOT NULL COMMENT '成本',
    unit VARCHAR(20) NOT NULL DEFAULT '件' COMMENT '单位',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    KEY idx_category (category),
    KEY idx_brand (brand)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='产品表';

-- ============================================
-- 4. 库存表 (inventory)
-- ============================================
CREATE TABLE IF NOT EXISTS inventory (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '库存ID',
    device_id BIGINT UNSIGNED NOT NULL COMMENT '设备ID',
    product_id BIGINT UNSIGNED NOT NULL COMMENT '产品ID',
    shelf_number INT UNSIGNED NOT NULL COMMENT '货架编号',
    quantity INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '当前库存',
    max_quantity INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '最大库存',
    status ENUM('NORMAL', 'LOW_STOCK', 'OUT_OF_STOCK', 'FAULT') NOT NULL DEFAULT 'NORMAL' COMMENT '状态',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    UNIQUE KEY uk_device_shelf (device_id, shelf_number),
    KEY idx_device_id (device_id),
    KEY idx_product_id (product_id),
    KEY idx_status (status),
    CONSTRAINT fk_inventory_device FOREIGN KEY (device_id) REFERENCES devices(id) ON DELETE CASCADE,
    CONSTRAINT fk_inventory_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='库存表';

-- ============================================
-- 5. 订单表 (orders)
-- ============================================
CREATE TABLE IF NOT EXISTS orders (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '订单ID',
    order_number VARCHAR(50) NOT NULL COMMENT '订单号',
    device_id BIGINT UNSIGNED NOT NULL COMMENT '设备ID',
    user_id BIGINT UNSIGNED NULL COMMENT '用户ID（可为空，支持匿名购买）',
    product_id BIGINT UNSIGNED NOT NULL COMMENT '产品ID',
    quantity INT UNSIGNED NOT NULL DEFAULT 1 COMMENT '数量',
    unit_price DECIMAL(10, 2) NOT NULL COMMENT '单价',
    total_amount DECIMAL(10, 2) NOT NULL COMMENT '总金额',
    payment_method ENUM('WECHAT', 'ALIPAY', 'CASH', 'CARD') NOT NULL COMMENT '支付方式',
    payment_proof VARCHAR(255) NULL COMMENT '支付凭证图片路径',
    status ENUM('PENDING', 'PAID', 'COMPLETED', 'CANCELLED', 'REFUNDED') NOT NULL DEFAULT 'PENDING' COMMENT '订单状态',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    UNIQUE KEY uk_order_number (order_number),
    KEY idx_device_id (device_id),
    KEY idx_user_id (user_id),
    KEY idx_product_id (product_id),
    KEY idx_status (status),
    KEY idx_created_at (created_at),
    CONSTRAINT fk_order_device FOREIGN KEY (device_id) REFERENCES devices(id) ON DELETE RESTRICT,
    CONSTRAINT fk_order_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_order_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单表';

-- ============================================
-- 6. 售后表 (after_sales)
-- ============================================
CREATE TABLE IF NOT EXISTS after_sales (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '售后ID',
    order_id BIGINT UNSIGNED NOT NULL COMMENT '订单ID',
    type ENUM('REFUND', 'EXCHANGE', 'COMPLAINT') NOT NULL COMMENT '售后类型',
    reason VARCHAR(200) NOT NULL COMMENT '原因',
    description TEXT NULL COMMENT '详细描述',
    images TEXT NULL COMMENT '图片（JSON数组）',
    status ENUM('PENDING', 'APPROVED', 'REJECTED', 'PROCESSING', 'COMPLETED', 'CANCELLED') NOT NULL DEFAULT 'PENDING' COMMENT '状态',
    handler_id BIGINT UNSIGNED NULL COMMENT '处理人ID',
    handle_note TEXT NULL COMMENT '处理备注',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    KEY idx_order_id (order_id),
    KEY idx_status (status),
    KEY idx_handler_id (handler_id),
    CONSTRAINT fk_after_sales_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    CONSTRAINT fk_after_sales_handler FOREIGN KEY (handler_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='售后表';

-- ============================================
-- 7. 广告表 (advertisements)
-- ============================================
CREATE TABLE IF NOT EXISTS advertisements (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '广告ID',
    device_id BIGINT UNSIGNED NOT NULL COMMENT '设备ID',
    title VARCHAR(100) NOT NULL COMMENT '标题',
    content TEXT NOT NULL COMMENT '内容',
    image VARCHAR(255) NULL COMMENT '图片路径',
    video VARCHAR(255) NULL COMMENT '视频路径',
    start_time DATETIME NOT NULL COMMENT '开始时间',
    end_time DATETIME NOT NULL COMMENT '结束时间',
    play_duration INT UNSIGNED NOT NULL DEFAULT 10 COMMENT '播放时长（秒）',
    play_order INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '播放顺序',
    status ENUM('ACTIVE', 'INACTIVE') NOT NULL DEFAULT 'ACTIVE' COMMENT '状态',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    KEY idx_device_id (device_id),
    KEY idx_status (status),
    KEY idx_time_range (start_time, end_time),
    CONSTRAINT fk_advertisement_device FOREIGN KEY (device_id) REFERENCES devices(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='广告表';


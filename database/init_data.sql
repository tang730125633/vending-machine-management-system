-- ============================================
-- 自动售货机管理系统初始数据
-- ============================================

USE vending_machine_db;

-- ============================================
-- 插入初始管理员用户
-- ============================================
-- 密码：admin123 (使用BCrypt加密后的值，实际使用时需要替换)
INSERT INTO users (username, email, password, real_name, phone, role, status) VALUES
('admin', 'admin@vending.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iwK8pJ5aO', '系统管理员', '13800138000', 'SUPER_ADMIN', 'ACTIVE'),
('operator1', 'operator1@vending.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iwK8pJ5aO', '运营人员1', '13800138001', 'OPERATOR', 'ACTIVE'),
('technician1', 'technician1@vending.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iwK8pJ5aO', '技术人员1', '13800138002', 'TECHNICIAN', 'ACTIVE');

-- ============================================
-- 插入示例设备（答辩演示用）
-- ============================================
INSERT INTO devices (device_code, name, location, latitude, longitude, region, status, operator_id, total_sales, total_revenue, utilization_rate) VALUES
('VM001', '教学楼1F售货机', '教学楼一楼大厅东侧', 39.904200, 116.407396, '校区A', 'ONLINE', 2, 0, 0.00, 0.00),
('VM002', '宿舍楼售货机', '学生宿舍6号楼一层', 31.230416, 121.473701, '校区B', 'ONLINE', 2, 0, 0.00, 0.00),
('VM003', '图书馆售货机', '图书馆二楼休息区', 23.129112, 113.264385, '校区A', 'ONLINE', 2, 0, 0.00, 0.00);

-- ============================================
-- 插入示例产品
-- ============================================
INSERT INTO products (name, brand, category, description, price, cost, unit) VALUES
('可口可乐', 'Coca-Cola', '饮料', '经典可乐，500ml', 3.50, 2.00, '瓶'),
('百事可乐', 'Pepsi', '饮料', '百事可乐，500ml', 3.50, 2.00, '瓶'),
('农夫山泉', '农夫山泉', '饮料', '天然矿泉水，550ml', 2.00, 1.00, '瓶'),
('康师傅方便面', '康师傅', '食品', '红烧牛肉面', 5.00, 2.50, '桶'),
('奥利奥饼干', 'Oreo', '零食', '原味夹心饼干，116g', 8.00, 4.00, '包'),
('德芙巧克力', 'Dove', '零食', '丝滑牛奶巧克力，80g', 12.00, 6.00, '条'),
('三只松鼠坚果', '三只松鼠', '零食', '混合坚果，200g', 25.00, 15.00, '包'),
('红牛', 'Red Bull', '功能饮料', '能量饮料，250ml', 6.00, 3.50, '罐');

-- ============================================
-- 插入示例库存
-- ============================================
-- 设备1的库存
INSERT INTO inventory (device_id, product_id, shelf_number, quantity, max_quantity, status) VALUES
(1, 1, 1, 20, 30, 'NORMAL'),
(1, 2, 2, 20, 30, 'NORMAL'),
(1, 3, 3, 15, 30, 'LOW_STOCK'),
(1, 4, 4, 10, 20, 'NORMAL'),
(1, 5, 5, 8, 15, 'NORMAL'),
(1, 6, 6, 5, 15, 'NORMAL'),
(1, 7, 7, 3, 10, 'LOW_STOCK'),
(1, 8, 8, 12, 20, 'NORMAL');

-- 设备2的库存
INSERT INTO inventory (device_id, product_id, shelf_number, quantity, max_quantity, status) VALUES
(2, 1, 1, 25, 30, 'NORMAL'),
(2, 2, 2, 25, 30, 'NORMAL'),
(2, 3, 3, 20, 30, 'NORMAL'),
(2, 4, 4, 15, 20, 'NORMAL'),
(2, 5, 5, 10, 15, 'NORMAL'),
(2, 6, 6, 8, 15, 'NORMAL'),
(2, 7, 7, 5, 10, 'NORMAL'),
(2, 8, 8, 18, 20, 'NORMAL');

-- ============================================
-- 插入示例广告
-- ============================================
INSERT INTO advertisements (device_id, title, content, image, start_time, end_time, play_duration, play_order, status) VALUES
(1, '新品上市', '欢迎购买新品三只松鼠坚果', NULL, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 15, 1, 'ACTIVE'),
(1, '促销活动', '所有饮料8折优惠', NULL, NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY), 10, 2, 'ACTIVE'),
(2, '欢迎光临', '感谢使用自动售货机', NULL, NOW(), DATE_ADD(NOW(), INTERVAL 365 DAY), 5, 1, 'ACTIVE');

-- ============================================
-- 插入演示订单数据（答辩专用）
-- 目标：今日订单6-10笔，Top3明显（可乐>水>泡面）
-- ============================================

-- 今天的订单（10笔）
INSERT INTO orders (order_number, device_id, user_id, product_id, quantity, unit_price, total_amount, payment_method, status, created_at) VALUES
('ORD20260116001', 1, NULL, 1, 2, 3.50, 7.00, 'WECHAT', 'COMPLETED', NOW()),
('ORD20260116002', 2, NULL, 1, 1, 3.50, 3.50, 'ALIPAY', 'COMPLETED', DATE_SUB(NOW(), INTERVAL 2 HOUR)),
('ORD20260116003', 1, NULL, 3, 3, 2.00, 6.00, 'WECHAT', 'COMPLETED', DATE_SUB(NOW(), INTERVAL 3 HOUR)),
('ORD20260116004', 3, NULL, 1, 1, 3.50, 3.50, 'WECHAT', 'COMPLETED', DATE_SUB(NOW(), INTERVAL 4 HOUR)),
('ORD20260116005', 2, NULL, 4, 2, 5.00, 10.00, 'ALIPAY', 'COMPLETED', DATE_SUB(NOW(), INTERVAL 5 HOUR)),
('ORD20260116006', 1, NULL, 1, 2, 3.50, 7.00, 'WECHAT', 'COMPLETED', DATE_SUB(NOW(), INTERVAL 6 HOUR)),
('ORD20260116007', 3, NULL, 3, 2, 2.00, 4.00, 'ALIPAY', 'COMPLETED', DATE_SUB(NOW(), INTERVAL 7 HOUR)),
('ORD20260116008', 2, NULL, 1, 1, 3.50, 3.50, 'WECHAT', 'COMPLETED', DATE_SUB(NOW(), INTERVAL 8 HOUR)),
('ORD20260116009', 1, NULL, 8, 1, 6.00, 6.00, 'WECHAT', 'COMPLETED', DATE_SUB(NOW(), INTERVAL 9 HOUR)),
('ORD20260116010', 3, NULL, 4, 1, 5.00, 5.00, 'ALIPAY', 'COMPLETED', DATE_SUB(NOW(), INTERVAL 10 HOUR));

-- 昨天的订单（5笔）
INSERT INTO orders (order_number, device_id, user_id, product_id, quantity, unit_price, total_amount, payment_method, status, created_at) VALUES
('ORD20260115001', 1, NULL, 1, 1, 3.50, 3.50, 'WECHAT', 'COMPLETED', DATE_SUB(NOW(), INTERVAL 1 DAY)),
('ORD20260115002', 2, NULL, 3, 2, 2.00, 4.00, 'ALIPAY', 'COMPLETED', DATE_SUB(NOW(), INTERVAL 1 DAY)),
('ORD20260115003', 1, NULL, 4, 1, 5.00, 5.00, 'WECHAT', 'COMPLETED', DATE_SUB(NOW(), INTERVAL 1 DAY)),
('ORD20260115004', 3, NULL, 1, 2, 3.50, 7.00, 'ALIPAY', 'COMPLETED', DATE_SUB(NOW(), INTERVAL 1 DAY)),
('ORD20260115005', 2, NULL, 5, 1, 8.00, 8.00, 'WECHAT', 'COMPLETED', DATE_SUB(NOW(), INTERVAL 1 DAY));

-- 前天的订单（3笔）
INSERT INTO orders (order_number, device_id, user_id, product_id, quantity, unit_price, total_amount, payment_method, status, created_at) VALUES
('ORD20260114001', 1, NULL, 3, 1, 2.00, 2.00, 'WECHAT', 'COMPLETED', DATE_SUB(NOW(), INTERVAL 2 DAY)),
('ORD20260114002', 2, NULL, 1, 1, 3.50, 3.50, 'ALIPAY', 'COMPLETED', DATE_SUB(NOW(), INTERVAL 2 DAY)),
('ORD20260114003', 3, NULL, 6, 1, 12.00, 12.00, 'WECHAT', 'COMPLETED', DATE_SUB(NOW(), INTERVAL 2 DAY));

-- 3-7天前的订单（2笔）
INSERT INTO orders (order_number, device_id, user_id, product_id, quantity, unit_price, total_amount, payment_method, status, created_at) VALUES
('ORD20260113001', 1, NULL, 1, 1, 3.50, 3.50, 'WECHAT', 'COMPLETED', DATE_SUB(NOW(), INTERVAL 3 DAY)),
('ORD20260112001', 2, NULL, 7, 1, 25.00, 25.00, 'ALIPAY', 'COMPLETED', DATE_SUB(NOW(), INTERVAL 4 DAY));


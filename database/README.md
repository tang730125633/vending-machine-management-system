# 数据库脚本说明

## 文件说明

### 1. schema.sql
数据库表结构创建脚本，包含：
- 数据库创建
- 7个核心表的创建
- 外键约束
- 索引优化

### 2. init_data.sql
初始数据脚本，包含：
- 默认管理员账户
- 示例设备数据
- 示例产品数据
- 示例库存数据
- 示例广告数据

## 使用说明

### 方式一：使用MySQL命令行

```bash
# 1. 登录MySQL
mysql -u root -p

# 2. 执行建表脚本
source database/schema.sql

# 3. 执行初始数据脚本（可选）
source database/init_data.sql
```

### 方式二：使用MySQL Workbench或其他工具

1. 打开 `schema.sql` 文件
2. 执行整个脚本
3. 如需初始数据，再执行 `init_data.sql`

### 方式三：使用Spring Boot自动创建

如果配置了 `spring.jpa.hibernate.ddl-auto=update`，Spring Boot会自动创建表结构，无需手动执行SQL。

## 默认账户信息

**超级管理员：**
- 用户名：`admin`
- 密码：`admin123`（需要在实际使用时通过BCrypt加密）

**注意：** `init_data.sql` 中的密码是示例值，实际部署时请修改为加密后的密码。

## 数据库表结构

### 核心表
1. **users** - 用户表
2. **devices** - 设备表
3. **products** - 产品表
4. **inventory** - 库存表
5. **orders** - 订单表
6. **after_sales** - 售后表
7. **advertisements** - 广告表

### 表关系
- devices.operator_id → users.id
- inventory.device_id → devices.id
- inventory.product_id → products.id
- orders.device_id → devices.id
- orders.user_id → users.id
- orders.product_id → products.id
- after_sales.order_id → orders.id
- after_sales.handler_id → users.id
- advertisements.device_id → devices.id

## 注意事项

1. 确保MySQL版本 >= 8.0
2. 字符集使用 `utf8mb4` 以支持emoji等特殊字符
3. 外键约束确保数据完整性
4. 索引优化查询性能
5. 时间字段使用 `DATETIME` 类型，支持时区

## 密码加密说明

系统使用BCrypt加密密码。如果要手动创建用户，可以使用以下Java代码生成加密密码：

```java
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
String encodedPassword = encoder.encode("your_password");
System.out.println(encodedPassword);
```

或者使用在线BCrypt工具生成。


# 自动售货机管理系统（Demo 版）

## 项目简介

这是一个**可运行、可演示的最小完整 Demo**，基于 Spring Boot 的自动售货机管理系统原型。

**当前状态**：前后端已打通，具备基础的认证和数据查询功能，可以展示完整的系统架构和开发思路。

**适用场景**：毕业设计演示、项目原型验证、技术架构展示。

**后续扩展**：系统采用模块化设计，预留了设备管理、订单管理、库存管理、售后管理、数据分析等接口，可在此基础上继续开发完整功能。

---

## 技术栈

### 后端
- **Java 17**
- **Spring Boot 3.2.0** - 应用框架
- **Spring Security** - 安全认证
- **Spring Data JPA** - 数据持久化
- **MySQL** - 关系型数据库
- **JWT** - Token 认证
- **Maven** - 项目管理

### 前端
- **原生 HTML + CSS + JavaScript** - 无框架依赖
- **单页管理后台** (`frontend/admin.html`)
- **Fetch API** - HTTP 请求

---

## 功能特性

### ✅ 当前可演示功能（已实现）

#### 后端基础能力
- Spring Boot 应用正常启动
- MySQL 数据库连接正常
- JWT Token 认证机制
- RESTful API 接口
- 跨域配置（CORS）

#### 前端演示页面
- **登录功能**：用户名/密码登录，获取 JWT Token
- **数据查询**：点击按钮调用后端 API
- **数据展示**：支持表格和 JSON 两种展示方式
- **状态反馈**：加载中、成功、失败等状态提示

#### 演示流程
1. 打开 `frontend/admin.html` 登录页面
2. 使用测试账号登录（admin / admin123）
3. 点击「获取销售数据」按钮
4. 查看返回的销售报表数据（JSON 格式）

---

### 🚧 后续规划（可扩展功能）

#### 1. 用户管理
- 用户注册功能（后端已实现，前端待接入）
- 用户信息管理
- 权限控制细化

#### 2. 设备管理（后端接口已完成）
- 设备列表展示
- 设备添加/编辑/删除
- 设备状态监控（在线/离线/维护/故障）
- 设备地理位置管理

#### 3. 订单管理（后端接口已完成）
- 订单列表查询
- 订单详情查看
- 订单状态跟踪
- 支付方式管理

#### 4. 库存管理（数据库设计已完成）
- 库存实时监控
- 库存预警提醒
- 货道管理

#### 5. 售后管理（数据库设计已完成）
- 售后申请流程
- 售后审批管理
- 售后跟踪记录

#### 6. 数据分析（基础接口已实现）
- 销售报表（日/周/月/年）
- 销售趋势分析
- 数据可视化图表

#### 7. 设备远程配置
- 价格远程调整
- 库存远程配置
- 广告投放管理

#### 8. 高级功能（规划中）
- WebSocket 实时监控
- AI 智能推荐
- 异常检测预警

---

## 项目结构

```
自动售货机管理系统_副本/
├── src/
│   ├── main/
│   │   ├── java/com/vending/
│   │   │   ├── VendingMachineApplication.java    # 启动类
│   │   │   ├── config/                           # 配置类（Security、JWT、WebSocket等）
│   │   │   ├── controller/                       # 控制器（API接口）
│   │   │   ├── service/                          # 服务层
│   │   │   ├── repository/                       # 数据访问层
│   │   │   ├── entity/                           # 实体类
│   │   │   ├── dto/                              # 数据传输对象
│   │   │   └── security/                         # 安全相关（JWT、过滤器）
│   │   └── resources/
│   │       └── application.yml                   # 配置文件
│   └── test/                                     # 测试代码
├── database/
│   ├── schema.sql                                # 数据库表结构
│   └── init_data.sql                             # 初始化数据（测试账号、设备、产品）
├── frontend/
│   ├── admin.html                                # 管理后台演示页面
│   ├── index.html                                # API测试页面
│   └── debug.html                                # 诊断工具
├── docker-compose.yml                            # Docker编排配置
├── Dockerfile                                    # 应用镜像构建
├── pom.xml                                       # Maven配置
└── README.md                                     # 项目说明
```

---

## 快速开始

### 环境要求
- Docker（推荐）或 JDK 17+ + Maven 3.6+ + MySQL 8.0+

### 三步启动演示

#### 方法一：使用 Docker（推荐）

**1. 启动后端服务**

```bash
cd ~/Desktop/自动售货机管理系统_副本
docker-compose -p vending up -d
```

等待 30-60 秒，直到 MySQL 和应用完全启动。

**2. 验证后端在线**

在浏览器打开：
```
http://localhost:8080/api/auth/health
```

应看到：`{"status":"ok","message":"自动售货机管理系统运行正常"}`

**3. 打开管理后台**

双击打开文件：
```
~/Desktop/自动售货机管理系统_副本/frontend/admin.html
```

或使用命令：
```bash
open ~/Desktop/自动售货机管理系统_副本/frontend/admin.html
```

**测试账号**：
- 用户名：`admin`
- 密码：`admin123`

登录后点击「获取销售数据」按钮即可看到数据展示。

---

#### 方法二：使用 Maven（需要手动配置 MySQL）

**1. 启动 MySQL 数据库**

**2. 导入数据库**
```bash
mysql -u root -p < database/schema.sql
mysql -u root -p < database/init_data.sql
```

**3. 启动应用**
```bash
mvn spring-boot:run
```

**4、5. 同上**

---

### ⚠️ 重要说明

**前后端是解耦的，前端依赖后端 API。**
- 如果后端服务未启动，前端会提示网络错误；
- 启动后端后，登录和业务功能即可正常使用。

---

## 管理后台说明（admin.html）

### 页面功能

`admin.html` 是当前系统的**演示用单页管理后台**，实现了最小可演示功能闭环：

#### 1. 登录功能
- 用户名/密码表单
- 调用 `POST /api/auth/login` 接口
- 获取并保存 JWT Token
- 登录成功后显示用户信息

#### 2. 数据查询按钮
- 「获取销售数据」按钮
- 调用 `GET /api/analytics/sales-report?period=daily` 接口
- 携带 JWT Token 进行认证
- 显示加载状态

#### 3. 数据展示区域
- **智能展示**：优先尝试渲染为表格，字段不固定则退化为 JSON
- **状态反馈**：加载中、成功、失败、空数据等状态
- **错误提示**：网络错误、权限错误等友好提示

#### 4. 退出登录
- 清除本地 Token
- 返回登录界面

### 测试账号

| 用户名 | 密码 | 角色 | 说明 |
|--------|------|------|------|
| admin | admin123 | 超级管理员 | 推荐使用此账号演示 |
| operator1 | admin123 | 运营人员 | 可测试权限控制 |
| technician1 | admin123 | 技术人员 | 可测试权限控制 |

---

## API 文档（演示用接口）

### 健康检查
```
GET /api/auth/health
```
无需认证，用于验证后端服务是否正常。

**响应示例**：
```json
{
  "status": "ok",
  "message": "自动售货机管理系统运行正常"
}
```

---

### 用户登录
```
POST /api/auth/login
Content-Type: application/json

{
  "username": "admin",
  "password": "admin123"
}
```

**响应示例**：
```json
{
  "message": "登录成功",
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "user": {
    "id": 1,
    "username": "admin",
    "email": "admin@vending.com",
    "realName": "系统管理员",
    "role": "SUPER_ADMIN",
    "avatar": ""
  }
}
```

---

### 销售报表查询
```
GET /api/analytics/sales-report?period=daily
Authorization: Bearer {token}
```

**请求参数**：
- `period`: 报表周期（daily/weekly/monthly/yearly）

**响应示例**：
```json
{
  "period": "daily",
  "startDate": "2026-01-15T05:34:35",
  "endDate": "2026-01-16T05:34:35",
  "totalSales": 0,
  "totalRevenue": 0
}
```

---

### 其他已实现接口（后续可扩展）

以下接口后端已实现，可在后续开发中接入前端：

**设备管理**：
- `GET /api/devices` - 获取设备列表
- `GET /api/devices/{id}` - 获取设备详情
- `POST /api/devices` - 创建设备
- `PUT /api/devices/{id}` - 更新设备
- `DELETE /api/devices/{id}` - 删除设备

**用户注册**：
- `POST /api/auth/register` - 用户注册

**数据分析**：
- `GET /api/analytics/sales-trend?period=weekly` - 销售趋势

---

## 数据库设计

系统已完成 7 张核心数据表的设计：

- `users` - 用户表（支持多角色权限）
- `devices` - 设备表（地理位置、状态监控）
- `products` - 产品表（分类、品牌、价格）
- `inventory` - 库存表（货道管理、库存预警）
- `orders` - 订单表（订单状态、支付方式）
- `after_sales` - 售后表（退款、换货、投诉）
- `advertisements` - 广告表（设备广告投放）

初始化数据包含：
- 3 个测试用户（admin、operator1、technician1）
- 3 台示例设备
- 8 个示例产品
- 完整的库存数据

---

## 开发进度

### ✅ Demo 阶段已完成（当前版本）

- [x] Spring Boot 项目基础架构
- [x] MySQL 数据库设计与初始化
- [x] JWT 认证机制
- [x] 用户登录接口
- [x] 数据分析接口（销售报表）
- [x] Docker 部署配置
- [x] 单页管理后台 (admin.html)
- [x] 前后端联调打通

---

### 🚧 后续开发计划

**Phase 1 - 核心功能完善**
- [ ] 完整的设备管理前端页面
- [ ] 订单管理前端页面
- [ ] 库存管理前端页面
- [ ] 数据可视化图表（Chart.js）

**Phase 2 - 功能增强**
- [ ] 售后管理功能
- [ ] 用户注册功能前端接入
- [ ] 文件上传功能（产品图片）
- [ ] 搜索和筛选功能

**Phase 3 - 高级功能**
- [ ] WebSocket 实时设备监控
- [ ] 数据导出功能（Excel/PDF）
- [ ] 系统配置管理
- [ ] 操作日志记录

**Phase 4 - 生产优化**
- [ ] 单元测试覆盖
- [ ] 性能优化
- [ ] 日志系统完善
- [ ] 部署文档

---

## 常见问题

### 1. 前端提示"网络错误"

**原因**：后端服务未启动或端口被占用。

**解决方法**：
```bash
# 检查容器状态
docker ps | grep vending

# 查看应用日志
docker logs vending-app

# 重启服务
docker-compose -p vending restart
```

### 2. 登录后显示 403 权限错误

**原因**：JWT Token 过期或角色权限不足。

**解决方法**：
- 重新登录获取新 Token
- 使用 admin 账号（拥有最高权限）

### 3. 数据库连接失败

**原因**：MySQL 容器未完全启动。

**解决方法**：
- 等待 30 秒后重启应用容器
- 检查 MySQL 日志：`docker logs vending-mysql`

---

## 许可证

MIT License

---

## 作者

毕业设计项目 - 自动售货机管理系统（Demo 版）

**最后更新**：2026-01-15

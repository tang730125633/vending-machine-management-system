# DEV.md - 答辩演示快速指南 v1.1

## 🎯 答辩目标

**项目定位**：自动售货机后台运营管理系统（MVP演示版）
**核心价值**：解决运营数据分散、对账麻烦、无法实时掌握销售情况的痛点
**演示闭环**：线上访问 → 登录认证 → 运营看板 → 4项核心指标展示

**本次答辩展示**：
- ✅ 今日订单数（非零）
- ✅ 今日销售额（非零）
- ✅ 热销Top3商品（可乐>水>泡面）
- ✅ 设备点位分布（3台设备：教学楼/宿舍楼/图书馆）

---

## 📺 3分钟答辩演示稿（可照读）

### 开场（10秒）
> 各位老师好，我演示的项目是"自动售货机后台运营管理系统"。这个系统解决了运营人员无法快速掌握销售情况的痛点，让管理者能实时查看今日订单、销售额、热销商品和设备状态。

### 演示步骤（2分钟）

**Step 1：打开线上页面（10秒）**
- 访问：`https://your-app.zeabur.app`（替换为实际域名）
- 展示：系统标题"自动售货机管理系统 - 管理后台"

**Step 2：登录系统（20秒）**
- 输入账号：`admin`
- 输入密码：`admin123`
- 点击"登录"按钮
- 展示：登录成功后，显示用户名"admin"和角色"SUPER_ADMIN"

**Step 3：加载运营看板（30秒）**
- 点击"刷新运营看板"按钮
- 等待1-2秒，数据加载完成
- **重点展示4个卡片**：
  - 今日订单数：10笔（非零 ✓）
  - 今日销售额：¥55.50（非零 ✓）
  - 热销Top1：可口可乐（有数据 ✓）
  - 设备总数：3台（有数据 ✓）

**Step 4：展示数据明细（40秒）**
- **热销商品Top3表格**：
  - 🥇 可口可乐 - 销量7
  - 🥈 农夫山泉 - 销量5
  - 🥉 康师傅方便面 - 销量3
- **设备点位表格**：
  - 教学楼1F售货机 - 教学楼一楼大厅东侧 - 在线
  - 宿舍楼售货机 - 学生宿舍6号楼一层 - 在线
  - 图书馆售货机 - 图书馆二楼休息区 - 在线

### 技术亮点（20秒）
> 本系统采用前后端分离架构，后端使用Spring Boot + MySQL，部署在Zeabur云平台，支持JWT认证。前端原生HTML+JS，无框架依赖。数据库使用7张表设计，支持订单、商品、设备、库存等完整业务流程。

### 未来扩展（10秒）
> 后续可接入WebSocket实时推送、数据可视化图表、库存预警、售后管理等功能。

---

## 🚀 本地快速运行

### 方式一：Docker（推荐，3步）

```bash
# 1. 启动后端+MySQL
cd ~/Desktop/自动售货机管理系统_副本
docker-compose -p vending up -d

# 2. 等待30-60秒，验证健康检查
curl http://localhost:8080/api/auth/health
# 期望输出：{"status":"ok","message":"自动售货机管理系统运行正常"}

# 3. 打开前端页面
open frontend/admin.html
# 登录：admin / admin123
# 点击"刷新运营看板"
```

### 方式二：Maven（需手动配置MySQL）

```bash
# 1. 启动MySQL，创建数据库vending_machine_db
# 2. 执行SQL初始化：
mysql -u root -p < database/schema.sql
mysql -u root -p < database/init_data.sql

# 3. 启动应用
mvn spring-boot:run

# 4. 打开前端（同上）
```

---

## ☁️ Zeabur 部署（5步完成）

### 前置准备

**重要**：确保项目根目录有以下文件
- `Dockerfile.build`（多阶段构建，自动mvn package）
- `database/schema.sql`（表结构）
- `database/init_data.sql`（演示数据，包含今日订单）

---

### 部署流程

#### 步骤 1：创建 Zeabur 项目并添加 MySQL

1. 登录 [Zeabur](https://zeabur.com) → 创建新项目
2. 点击 **Add Service** → **Marketplace** → 选择 **MySQL**
3. 等待MySQL启动，点击服务卡片查看详情
4. **记录以下信息**（后续配置使用）：
   - Root Password: `<自动生成>`
   - Connection String (Internal): `mysql.zeabur.internal:3306`
   - Database Name: `zeabur`

---

#### 步骤 2：初始化数据库

在MySQL服务详情页：
1. 点击 **Instructions** → **Connect** → **MySQL Client** 打开Web控制台
2. 依次执行SQL脚本（完整复制粘贴）：
   ```sql
   -- 复制 database/schema.sql 全部内容，粘贴执行
   -- 复制 database/init_data.sql 全部内容，粘贴执行
   ```
3. 验证：执行 `SHOW TABLES;` 应看到7张表
4. 验证：执行 `SELECT COUNT(*) FROM orders WHERE DATE(created_at) = CURDATE();` 应返回10

---

#### 步骤 3：部署后端应用

1. **推送代码到Git**（如果还没有）：
   ```bash
   git init
   git add .
   git commit -m "Init vending machine system"
   git remote add origin <你的仓库地址>
   git push -u origin main
   ```

2. 在Zeabur项目下，点击 **Add Service** → **Git**
3. 授权并选择你的Git仓库
4. Zeabur会自动检测到`Dockerfile.build`并开始构建（需3-5分钟）

**备选方案**：如果没有Git，选择 **Upload Files** 直接上传项目文件夹

---

#### 步骤 4：配置环境变量

在后端应用服务详情页，点击 **Variables** 标签，添加以下环境变量：

| 变量名 | 值（示例） | 说明 |
|--------|-----------|------|
| `SPRING_DATASOURCE_URL` | `jdbc:mysql://mysql.zeabur.internal:3306/zeabur?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true` | MySQL连接地址（使用步骤1的内部地址） |
| `SPRING_DATASOURCE_USERNAME` | `root` | 数据库用户名 |
| `SPRING_DATASOURCE_PASSWORD` | `<步骤1记录的密码>` | 数据库密码（必须填实际密码） |
| `JWT_SECRET` | `your_super_secret_jwt_key_for_production_12345678` | JWT密钥（必须改为32位+随机字符串） |
| `SPRING_MAIN_ALLOWCIRCULARREFERENCES` | `true` | 允许循环依赖 |
| `ZBPACK_DOCKERFILE_NAME` | `build` | 使用Dockerfile.build构建 |

**生成随机JWT_SECRET**（可选）：
```bash
openssl rand -base64 32
```

配置完成后，点击 **Save** → 应用会自动重启（约30秒）

---

#### 步骤 5：验证部署成功

1. **获取应用域名**：在应用详情页 → **Domains** 标签 → 复制自动生成的域名
   - 格式：`https://your-app-xxx.zeabur.app`

2. **验证后端健康检查**：
   ```bash
   curl https://your-app-xxx.zeabur.app/api/auth/health
   ```
   **期望输出**：
   ```json
   {"status":"ok","message":"自动售货机管理系统运行正常"}
   ```

3. **验证登录接口**：
   ```bash
   curl -X POST https://your-app-xxx.zeabur.app/api/auth/login \
     -H "Content-Type: application/json" \
     -d '{"username":"admin","password":"admin123"}'
   ```
   **期望输出**：包含 `"token":"eyJ..."`

4. **验证运营看板接口**（使用上一步的token）：
   ```bash
   curl -X GET "https://your-app-xxx.zeabur.app/api/analytics/dashboard" \
     -H "Authorization: Bearer <你的token>"
   ```
   **期望输出**：
   ```json
   {
     "todayOrders": 10,
     "todayRevenue": 55.50,
     "top3": [{"name":"可口可乐","qty":7}, ...],
     "devices": [{"name":"教学楼1F售货机",...}, ...]
   }
   ```

---

## 🌐 前端上线

**修改API地址**（必须）：

编辑 `frontend/admin.html` 第 277 行：
```javascript
const API_BASE = 'https://your-app-xxx.zeabur.app/api';  // 改为Zeabur后端域名
```

**部署方式二选一**：

### 方式A：Zeabur静态托管（推荐，有公网地址）
1. 在Zeabur项目下，点击 **Add Service** → **Static**
2. 选择 **Upload Files**，上传 `frontend/` 目录所有文件
3. Zeabur自动生成静态站点域名（如 `https://your-frontend.zeabur.app`）
4. 访问域名，使用 `admin/admin123` 登录

### 方式B：本地打开（最简单）
1. 修改 `admin.html` 的 `API_BASE` 后
2. 双击文件在浏览器打开
3. 登录并点击"刷新运营看板"

---

## ✅ 验收清单

### 本地验收
- [ ] `curl http://localhost:8080/api/auth/health` 返回 `{"status":"ok"}`
- [ ] 打开 `admin.html`，输入 `admin/admin123` 登录成功
- [ ] 点击"刷新运营看板"，看到4个卡片数据（今日订单10、销售额55.50等）
- [ ] Top3表格显示：可口可乐(7) > 农夫山泉(5) > 康师傅方便面(3)
- [ ] 设备表格显示3台设备，状态均为"在线"

### Zeabur线上验收
- [ ] `curl https://your-app.zeabur.app/api/auth/health` 返回 `{"status":"ok"}`
- [ ] 用curl测试登录接口，返回token
- [ ] 用token调用dashboard接口，返回数据（todayOrders=10, todayRevenue=55.50）
- [ ] 浏览器访问前端页面，登录后看板数据正常展示
- [ ] 答辩演示流程跑通（3分钟演示稿可照读）

---

## ❓ 常见问题

### 1. Docker启动后提示"网络错误"
**原因**：MySQL未完全启动
**解决**：等待60秒，执行 `docker logs vending-app` 检查日志
**验证**：`curl http://localhost:8080/api/auth/health` 返回200

---

### 2. Zeabur健康检查404
**原因**：应用未启动成功或路径错误
**排查**：
```bash
# 1. 查看应用Logs，确认是否有 "Started VendingMachineApplication"
# 2. 确认路径是 /api/auth/health（注意/api前缀）
# 3. 检查环境变量 SPRING_DATASOURCE_URL 是否填写正确
```

---

### 3. 登录返回401或"数据库表不存在"
**原因**：SQL脚本未执行
**解决**：
```bash
# 1. 连接Zeabur MySQL，执行：
SHOW TABLES;  # 应看到7张表：users, devices, products, orders等

# 2. 如果没有表，重新执行schema.sql和init_data.sql
# 3. 验证用户数据：
SELECT username FROM users;  # 应看到admin, operator1, technician1
```

---

### 4. 运营看板显示"今日订单数0"
**原因**：init_data.sql中的订单日期不是今天
**原因2**：订单状态不是COMPLETED
**验证**：
```sql
-- 在MySQL控制台执行：
SELECT COUNT(*) FROM orders
WHERE DATE(created_at) = CURDATE() AND status = 'COMPLETED';
# 应返回10
```
**解决**：重新执行 `init_data.sql`（使用NOW()函数动态生成今天的日期）

---

### 5. Zeabur构建失败"Cannot find Dockerfile"
**原因**：未设置 `ZBPACK_DOCKERFILE_NAME` 环境变量
**解决**：
```bash
# 在应用Variables中添加：
ZBPACK_DOCKERFILE_NAME=build  # 让Zeabur使用Dockerfile.build
```

**备选方案**：重命名文件
```bash
mv Dockerfile Dockerfile.old
mv Dockerfile.build Dockerfile
git commit -am "Use multi-stage build" && git push
```

---

## 📝 技术亮点总结（答辩口径）

1. **前后端分离架构**：HTML/JS前端 + Spring Boot后端，解耦合易维护
2. **JWT无状态认证**：Token机制，支持分布式部署
3. **Docker容器化**：一键启动，跨平台兼容
4. **云原生部署**：Zeabur自动构建+MySQL托管，免运维
5. **RESTful API设计**：统一接口规范，易扩展
6. **多角色权限**：SUPER_ADMIN/OPERATOR/TECHNICIAN，支持精细化权限控制
7. **完整业务流程**：订单、库存、设备、售后全链路数据模型

---

## 🔮 未来扩展方向（答辩加分项）

- [ ] WebSocket实时监控：设备状态变化推送
- [ ] 数据可视化：Echarts图表展示销售趋势
- [ ] 库存预警：低库存自动提醒
- [ ] 移动端适配：响应式设计
- [ ] AI推荐：基于销量预测热销商品
- [ ] 导出报表：Excel/PDF数据导出
- [ ] 硬件对接：IoT设备状态采集（需硬件支持）

---

**文档版本**：v1.1（答辩版）
**最后更新**：2026-01-16
**维护者**：Tang
**答辩时长**：3分钟（含演示2分钟）
**演示效果**：✅ 今日订单非0 ✅ 销售额非0 ✅ Top3有数据 ✅ 设备列表完整

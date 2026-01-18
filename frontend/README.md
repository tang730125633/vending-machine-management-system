# 自动售货机管理系统 - 前端测试页面

## 功能特点

✅ 用户注册和登录
✅ JWT Token 认证
✅ API 测试控制台
✅ 响应式设计
✅ 实时 API 响应显示

## 使用方法

### 1. 启动后端服务

```bash
cd "/Users/tang/Desktop/自动售货机管理系统"
docker-compose -p vending up -d
```

### 2. 打开前端页面

**方法一：直接打开**
- 双击 `frontend/index.html` 文件
- 或在浏览器中打开该文件

**方法二：使用命令**
```bash
open "/Users/tang/Desktop/自动售货机管理系统/frontend/index.html"
```

### 3. 使用流程

#### 注册新用户
1. 点击右侧"注册"表单
2. 填写信息：
   - 用户名：admin
   - 密码：admin123
   - 邮箱：admin@example.com
   - 手机号：13800138000
   - 真实姓名：管理员
3. 点击"注册"按钮
4. 注册成功后切换到登录表单

#### 登录系统
1. 在左侧"登录"表单中输入用户名和密码
2. 点击"登录"按钮
3. 登录成功后会显示用户信息和 Token

#### 测试 API
登录后可以测试以下 API：

1. **获取设备列表** - 查看所有自动售货机
2. **获取订单列表** - 查看所有订单
3. **获取库存列表** - 查看库存状态
4. **销售报表** - 查看销售数据
5. **销售趋势** - 查看趋势分析
6. **获取用户列表** - 查看所有用户

点击按钮即可发送 API 请求，响应结果会实时显示在下方的响应框中。

## 技术栈

- **HTML5** - 页面结构
- **CSS3** - 样式设计（渐变色背景、响应式布局）
- **原生 JavaScript** - 交互逻辑（无框架依赖）
- **Fetch API** - HTTP 请求

## 注意事项

### CORS 跨域问题

如果遇到跨域错误，需要在后端添加 CORS 配置：

1. 编辑文件：`src/main/java/com/vending/config/SecurityConfig.java`
2. 添加 CORS 配置

或者临时解决方案：使用浏览器插件允许跨域

### API 服务未启动

如果前端无法连接到 API：

1. 检查 Docker 容器状态：
   ```bash
   docker ps | grep vending
   ```

2. 查看应用日志：
   ```bash
   docker logs vending-app
   ```

3. 重启服务：
   ```bash
   docker-compose -p vending restart
   ```

## 快捷命令

```bash
# 启动所有服务
docker-compose -p vending up -d

# 停止所有服务
docker-compose -p vending down

# 重启应用
docker-compose -p vending restart app

# 查看日志
docker logs -f vending-app

# 查看容器状态
docker ps
```

## 后续开发建议

这是一个临时的测试页面，完整的 React 前端开发计划：

1. 使用 React + TypeScript
2. 使用 Ant Design 组件库
3. 实现完整的 CRUD 功能
4. 添加数据可视化图表
5. 实时数据更新（WebSocket）

## 浏览器兼容性

- ✅ Chrome
- ✅ Firefox
- ✅ Safari
- ✅ Edge

推荐使用 Chrome 浏览器以获得最佳体验。

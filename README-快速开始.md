# 自动售货机管理系统 - 快速开始 🚀

> **无需安装 Java、Maven、MySQL！Docker 容器一键启动！**

---

## 📦 第一步：安装 Docker Desktop

### 下载地址

**判断你的 Mac 芯片**：左上角  → 关于本机 → 查看"芯片"

- **Apple M1/M2/M3**：https://desktop.docker.com/mac/main/arm64/Docker.dmg
- **Intel 芯片**：https://desktop.docker.com/mac/main/amd64/Docker.dmg

### 安装步骤

1. 打开下载的 `.dmg` 文件
2. 拖动 Docker 到 Applications
3. 打开 Docker，等待菜单栏出现🐳图标
4. 看到 "Docker Desktop is running" 即可

---

## 🎯 第二步：一键启动项目

### 如果你有 VPN（推荐）

```bash
cd 自动售货机管理系统_副本2
chmod +x quick-start.sh
./quick-start.sh
```

**等待 2-5 分钟，浏览器会自动打开管理后台！**

---

### 如果你没有 VPN

```bash
# 1. 先配置国内镜像源
cd 自动售货机管理系统_副本2
chmod +x setup-docker-mirror.sh
./setup-docker-mirror.sh
# 按提示输入 y 重启 Docker

# 2. 等待 30 秒后启动项目
chmod +x quick-start.sh
./quick-start.sh
```

**等待 2-5 分钟，浏览器会自动打开管理后台！**

---

## 👤 第三步：登录系统

浏览器打开后，输入测试账号：

- **用户名**：`admin`
- **密码**：`admin123`

登录后即可使用系统！

---

## 🛑 如何停止服务

```bash
docker-compose -p vending down
```

---

## ❓ 遇到问题？

### 问题1：Docker 下载镜像很慢

**解决**：运行 `./setup-docker-mirror.sh` 配置国内镜像源

### 问题2：端口被占用

**解决**：先停止旧服务 `docker-compose -p vending down`

### 问题3：启动失败

**查看日志**：
```bash
docker logs vending-app
docker logs vending-mysql
```

---

## 📚 详细文档

- **完整部署指南**：查看 `部署指南.md`
- **项目说明**：查看 `README.md`
- **开发文档**：查看 `DEV.md`

---

## 📞 快速命令参考

```bash
# 启动服务
./quick-start.sh

# 停止服务
docker-compose -p vending down

# 查看日志
docker logs vending-app -f

# 重启服务
docker-compose -p vending restart

# 查看容器状态
docker ps | grep vending
```

---

## ✅ 成功标志

启动成功后，你会看到：

1. ✅ 浏览器自动打开管理后台
2. ✅ 显示登录界面
3. ✅ 终端显示 "🎉 启动成功！"

---

**就这么简单！无需任何编程环境配置！** 🎉

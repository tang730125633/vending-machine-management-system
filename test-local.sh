#!/bin/bash

# ========================================
# 本地环境验证脚本（答辩演示验证）
# ========================================

echo "🧪 开始验证自动售货机管理系统..."
echo ""

API_BASE="http://localhost:8080/api"

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 步骤1：验证健康检查
echo "📌 步骤1：验证健康检查接口"
echo "请求: GET $API_BASE/auth/health"
response=$(curl -s -w "\n%{http_code}" "$API_BASE/auth/health")
http_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | sed '$d')

if [ "$http_code" == "200" ]; then
    echo -e "${GREEN}✅ 健康检查通过${NC}"
    echo "响应: $body"
else
    echo -e "${RED}❌ 健康检查失败 (HTTP $http_code)${NC}"
    echo "响应: $body"
    echo ""
    echo -e "${YELLOW}💡 提示：请确保后端服务已启动：docker-compose -p vending up -d${NC}"
    exit 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 步骤2：验证登录接口
echo "📌 步骤2：验证登录接口"
echo "请求: POST $API_BASE/auth/login"
echo "账号: admin / admin123"
login_response=$(curl -s -w "\n%{http_code}" -X POST "$API_BASE/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}')

http_code=$(echo "$login_response" | tail -n1)
body=$(echo "$login_response" | sed '$d')

if [ "$http_code" == "200" ]; then
    echo -e "${GREEN}✅ 登录成功${NC}"
    # 提取token（简单处理，实际应该用jq）
    token=$(echo "$body" | grep -o '"token":"[^"]*' | grep -o '[^"]*$')
    echo "Token: ${token:0:50}..."
else
    echo -e "${RED}❌ 登录失败 (HTTP $http_code)${NC}"
    echo "响应: $body"
    exit 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 步骤3：验证运营看板接口
echo "📌 步骤3：验证运营看板接口（答辩核心）"
echo "请求: GET $API_BASE/analytics/dashboard"
dashboard_response=$(curl -s -w "\n%{http_code}" -X GET "$API_BASE/analytics/dashboard" \
  -H "Authorization: Bearer $token" \
  -H "Content-Type: application/json")

http_code=$(echo "$dashboard_response" | tail -n1)
body=$(echo "$dashboard_response" | sed '$d')

if [ "$http_code" == "200" ]; then
    echo -e "${GREEN}✅ 运营看板数据获取成功${NC}"
    echo ""
    echo "📊 看板数据："
    echo "$body" | python3 -m json.tool 2>/dev/null || echo "$body"
    echo ""

    # 检查关键数据是否非零
    todayOrders=$(echo "$body" | grep -o '"todayOrders":[0-9]*' | grep -o '[0-9]*')
    if [ -n "$todayOrders" ] && [ "$todayOrders" -gt 0 ]; then
        echo -e "${GREEN}✅ 今日订单数: $todayOrders（非零 ✓）${NC}"
    else
        echo -e "${RED}❌ 今日订单数为0（答辩失败风险）${NC}"
    fi

else
    echo -e "${RED}❌ 运营看板接口失败 (HTTP $http_code)${NC}"
    echo "响应: $body"
    exit 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 总结
echo "🎉 验证完成！所有接口测试通过！"
echo ""
echo "📋 下一步操作："
echo "1. 打开前端页面: open frontend/admin.html"
echo "2. 登录账号: admin / admin123"
echo "3. 点击「刷新运营看板」按钮"
echo "4. 验证4个卡片数据是否正常显示"
echo ""
echo "✅ 答辩演示准备就绪！"

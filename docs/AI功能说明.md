# AI功能说明文档

## 概述

自动售货机管理系统集成了AI功能，提供智能推荐、异常检测和销售预测等功能。AI功能采用本地部署方式，确保数据安全和响应速度。

## 功能特性

### 1. 智能推荐系统

**功能描述：**
- 基于用户购买历史推荐个性化产品
- 基于热门产品推荐
- 结合用户偏好和流行趋势

**API接口：**
```
GET /api/ai/recommend
参数：
- userId (可选): 用户ID
- deviceId (可选): 设备ID
- limit (默认10): 推荐数量
```

**使用示例：**
```bash
# 获取用户推荐
curl -X GET "http://localhost:8080/api/ai/recommend?userId=1&limit=5"

# 获取设备推荐
curl -X GET "http://localhost:8080/api/ai/recommend?deviceId=1&limit=5"
```

### 2. 异常销售检测

**功能描述：**
- 自动检测销售突增/突减
- 识别异常产品销量
- 实时监控设备销售状态
- 自动生成异常警报

**检测规则：**
- 销售额变化超过50%触发警报
- 产品销量超过平均值3倍标记为异常
- 支持按设备或区域检测

**API接口：**
```
GET /api/ai/anomalies
参数：
- deviceId (可选): 设备ID
- region (可选): 区域
```

**使用示例：**
```bash
curl -X GET "http://localhost:8080/api/ai/anomalies?deviceId=1" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### 3. 销售预测

**功能描述：**
- 基于历史数据预测未来销售
- 预测销售额和订单数量
- 支持按设备预测
- 使用最近30天数据进行分析

**API接口：**
```
GET /api/ai/forecast
参数：
- deviceId (可选): 设备ID
- days (默认7): 预测天数
```

**使用示例：**
```bash
curl -X GET "http://localhost:8080/api/ai/forecast?deviceId=1&days=7" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

## 技术实现

### 算法说明

1. **推荐算法：**
   - 协同过滤：基于用户历史购买
   - 热门推荐：基于全局销售数据
   - 混合推荐：结合多种策略

2. **异常检测算法：**
   - 统计方法：计算平均值和标准差
   - 阈值检测：设置变化率阈值
   - 趋势分析：识别异常模式

3. **预测算法：**
   - 时间序列分析
   - 线性回归
   - 移动平均

### 本地模型部署

**模型路径配置：**
```yaml
ai:
  enabled: true
  model-path: ./ai_models
```

**模型文件格式：**
- 支持 ONNX 格式
- 支持 TensorFlow SavedModel
- 支持 PyTorch 模型

**扩展说明：**
当前版本使用基于规则的算法，可以扩展为：
- 集成 TensorFlow Java
- 集成 ONNX Runtime
- 集成自定义机器学习模型

## 配置说明

### 启用/禁用AI功能

在 `application.yml` 中配置：
```yaml
ai:
  enabled: true  # true启用，false禁用
  model-path: ./ai_models  # 模型文件路径
```

### 性能优化

1. **缓存机制：** 推荐结果缓存5分钟
2. **异步处理：** 异常检测异步执行
3. **批量处理：** 支持批量预测

## 使用场景

### 场景1：用户购买推荐
用户在设备前，系统根据历史购买记录推荐相关产品。

### 场景2：异常销售预警
系统自动检测到某设备销售额突然下降，发送预警通知。

### 场景3：销售计划制定
运营人员使用销售预测功能，制定补货和营销计划。

## API响应示例

### 推荐接口响应
```json
{
  "success": true,
  "data": [
    {
      "product": {
        "id": 1,
        "name": "可口可乐",
        "price": 3.50
      },
      "score": 5,
      "reason": "基于您的购买历史"
    }
  ],
  "count": 5
}
```

### 异常检测响应
```json
{
  "success": true,
  "data": [
    {
      "type": "销售异常",
      "message": "设备 1 销售额突减 65.23%，日均120.50元，昨日42.00元",
      "level": "WARNING"
    }
  ],
  "count": 1
}
```

### 销售预测响应
```json
{
  "success": true,
  "data": {
    "predictedRevenue": 850.50,
    "predictedOrders": 120,
    "description": "基于最近30天数据预测"
  }
}
```

## 未来扩展

1. **深度学习模型：**
   - 使用神经网络进行更精准的推荐
   - 时间序列预测模型

2. **实时学习：**
   - 在线学习机制
   - 模型自动更新

3. **多模态AI：**
   - 图像识别（商品识别）
   - 自然语言处理（用户反馈分析）

## 注意事项

1. AI功能需要足够的历史数据才能准确工作
2. 异常检测的阈值可以根据实际情况调整
3. 模型文件需要定期更新以保持准确性
4. 建议在生产环境中使用GPU加速（如需要）

## 技术支持

如有问题，请参考：
- 项目README.md
- API文档
- 代码注释


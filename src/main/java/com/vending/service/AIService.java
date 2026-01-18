package com.vending.service;

import com.vending.entity.Order;
import com.vending.entity.Product;
import com.vending.repository.OrderRepository;
import com.vending.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

/**
 * AI服务类
 * 提供智能推荐、异常检测、销售预测等功能
 */
@Service
public class AIService {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private ProductRepository productRepository;

    @Value("${ai.enabled:true}")
    private boolean aiEnabled;

    @Value("${ai.model-path:./ai_models}")
    private String modelPath;

    /**
     * 智能推荐产品
     * 基于用户购买历史和热门产品推荐
     */
    public List<ProductRecommendation> recommendProducts(Long userId, Long deviceId, int limit) {
        if (!aiEnabled) {
            return getDefaultRecommendations(deviceId, limit);
        }

        List<ProductRecommendation> recommendations = new ArrayList<>();

        // 1. 基于用户历史购买推荐
        if (userId != null) {
            List<Order> userOrders = orderRepository.findByUserId(userId);
            Map<Long, Long> productFrequency = userOrders.stream()
                    .collect(Collectors.groupingBy(
                            Order::getProductId,
                            Collectors.counting()
                    ));

            for (Map.Entry<Long, Long> entry : productFrequency.entrySet()) {
                Long productId = entry.getKey();
                if (productId != null) {
                    Product product = productRepository.findById(productId).orElse(null);
                    if (product != null) {
                        recommendations.add(new ProductRecommendation(
                                product,
                                entry.getValue().intValue(),
                                "基于您的购买历史"
                        ));
                    }
                }
            }
        }

        // 2. 基于热门产品推荐
        LocalDateTime lastWeek = LocalDateTime.now().minusDays(7);
        List<Order> recentOrders = orderRepository.findByDateRange(lastWeek, LocalDateTime.now());

        Map<Long, Long> popularProducts = recentOrders.stream()
                .collect(Collectors.groupingBy(
                        Order::getProductId,
                        Collectors.counting()
                ));

        for (Map.Entry<Long, Long> entry : popularProducts.entrySet()) {
            Long productId = entry.getKey();
            if (productId != null && recommendations.stream().noneMatch(r -> r.getProduct().getId().equals(productId))) {
                Product product = productRepository.findById(productId).orElse(null);
                if (product != null) {
                    recommendations.add(new ProductRecommendation(
                            product,
                            entry.getValue().intValue(),
                            "热门推荐"
                    ));
                }
            }
        }

        // 3. 按推荐分数排序
        recommendations.sort((a, b) -> Integer.compare(b.getScore(), a.getScore()));

        return recommendations.stream()
                .limit(limit)
                .collect(Collectors.toList());
    }

    /**
     * 异常销售检测
     * 检测销售突增、突减或异常产品
     */
    public List<AnomalyAlert> detectSalesAnomalies(Long deviceId, String region) {
        if (!aiEnabled) {
            return Collections.emptyList();
        }

        List<AnomalyAlert> alerts = new ArrayList<>();

        // 获取最近7天的订单
        LocalDateTime endDate = LocalDateTime.now();
        LocalDateTime startDate = endDate.minusDays(7);
        List<Order> recentOrders = orderRepository.findByDateRange(startDate, endDate);

        // 按设备过滤
        if (deviceId != null) {
            recentOrders = recentOrders.stream()
                    .filter(o -> o.getDeviceId().equals(deviceId))
                    .collect(Collectors.toList());
        }

        // 计算日均销售额
        Map<Long, List<Order>> ordersByDevice = recentOrders.stream()
                .collect(Collectors.groupingBy(Order::getDeviceId));

        for (Map.Entry<Long, List<Order>> entry : ordersByDevice.entrySet()) {
            Long device = entry.getKey();
            List<Order> deviceOrders = entry.getValue();

            // 计算平均日销售额
            double avgDailyRevenue = deviceOrders.stream()
                    .mapToDouble(o -> o.getTotalAmount().doubleValue())
                    .sum() / 7.0;

            // 计算最近一天的销售额
            LocalDateTime yesterday = endDate.minusDays(1);
            double yesterdayRevenue = deviceOrders.stream()
                    .filter(o -> o.getCreatedAt().isAfter(yesterday))
                    .mapToDouble(o -> o.getTotalAmount().doubleValue())
                    .sum();

            // 检测异常：销售额变化超过50%
            if (avgDailyRevenue > 0) {
                double changeRate = Math.abs(yesterdayRevenue - avgDailyRevenue) / avgDailyRevenue;
                if (changeRate > 0.5) {
                    String type = yesterdayRevenue > avgDailyRevenue ? "突增" : "突减";
                    alerts.add(new AnomalyAlert(
                            "销售异常",
                            String.format("设备 %d 销售额%s %.2f%%，日均%.2f元，昨日%.2f元",
                                    device, type, changeRate * 100, avgDailyRevenue, yesterdayRevenue),
                            "WARNING"
                    ));
                }
            }
        }

        // 检测异常产品（销量异常高或低）
        Map<Long, Long> productSales = recentOrders.stream()
                .collect(Collectors.groupingBy(
                        Order::getProductId,
                        Collectors.counting()
                ));

        long avgProductSales = productSales.values().stream()
                .mapToLong(Long::longValue)
                .sum() / Math.max(productSales.size(), 1);

        for (Map.Entry<Long, Long> entry : productSales.entrySet()) {
            Long productId = entry.getKey();
            if (productId != null && entry.getValue() > avgProductSales * 3) {
                Product product = productRepository.findById(productId).orElse(null);
                if (product != null) {
                    alerts.add(new AnomalyAlert(
                            "产品异常",
                            String.format("产品 %s 销量异常高：%d次（平均：%d次）",
                                    product.getName(), entry.getValue(), avgProductSales),
                            "INFO"
                    ));
                }
            }
        }

        return alerts;
    }

    /**
     * 销售预测
     * 基于历史数据预测未来销售趋势
     */
    public SalesForecast predictSales(Long deviceId, int days) {
        if (!aiEnabled) {
            return new SalesForecast(0.0, 0, "AI功能未启用");
        }

        // 获取最近30天的数据
        LocalDateTime endDate = LocalDateTime.now();
        LocalDateTime startDate = endDate.minusDays(30);
        List<Order> historicalOrders = orderRepository.findByDateRange(startDate, endDate);

        if (deviceId != null) {
            historicalOrders = historicalOrders.stream()
                    .filter(o -> o.getDeviceId().equals(deviceId))
                    .collect(Collectors.toList());
        }

        if (historicalOrders.isEmpty()) {
            return new SalesForecast(0.0, 0, "数据不足，无法预测");
        }

        // 计算日均销售额和订单数
        double totalRevenue = historicalOrders.stream()
                .mapToDouble(o -> o.getTotalAmount().doubleValue())
                .sum();
        int totalOrders = historicalOrders.size();

        double avgDailyRevenue = totalRevenue / 30.0;
        double avgDailyOrders = totalOrders / 30.0;

        // 简单线性预测（实际可以使用更复杂的模型）
        double predictedRevenue = avgDailyRevenue * days;
        int predictedOrders = (int) (avgDailyOrders * days);

        return new SalesForecast(predictedRevenue, predictedOrders, "基于最近30天数据预测");
    }

    /**
     * 获取默认推荐（当AI未启用时）
     */
    private List<ProductRecommendation> getDefaultRecommendations(Long deviceId, int limit) {
        return productRepository.findAll().stream()
                .limit(limit)
                .map(p -> new ProductRecommendation(p, 0, "默认推荐"))
                .collect(Collectors.toList());
    }

    /**
     * 产品推荐结果
     */
    public static class ProductRecommendation {
        private Product product;
        private int score;
        private String reason;

        public ProductRecommendation(Product product, int score, String reason) {
            this.product = product;
            this.score = score;
            this.reason = reason;
        }

        public Product getProduct() { return product; }
        public int getScore() { return score; }
        public String getReason() { return reason; }
    }

    /**
     * 异常警报
     */
    public static class AnomalyAlert {
        private String type;
        private String message;
        private String level;

        public AnomalyAlert(String type, String message, String level) {
            this.type = type;
            this.message = message;
            this.level = level;
        }

        public String getType() { return type; }
        public String getMessage() { return message; }
        public String getLevel() { return level; }
    }

    /**
     * 销售预测结果
     */
    public static class SalesForecast {
        private double predictedRevenue;
        private int predictedOrders;
        private String description;

        public SalesForecast(double predictedRevenue, int predictedOrders, String description) {
            this.predictedRevenue = predictedRevenue;
            this.predictedOrders = predictedOrders;
            this.description = description;
        }

        public double getPredictedRevenue() { return predictedRevenue; }
        public int getPredictedOrders() { return predictedOrders; }
        public String getDescription() { return description; }
    }
}


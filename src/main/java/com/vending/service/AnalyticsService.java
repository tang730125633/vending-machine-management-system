package com.vending.service;

import com.vending.entity.Device;
import com.vending.entity.Order;
import com.vending.entity.Product;
import com.vending.repository.DeviceRepository;
import com.vending.repository.OrderRepository;
import com.vending.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class AnalyticsService {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private DeviceRepository deviceRepository;

    @Autowired
    private ProductRepository productRepository;

    public Map<String, Object> getSalesReport(String period, String region, Long deviceId, String category, String brand) {
        LocalDateTime startDate = getStartDate(period);
        LocalDateTime endDate = LocalDateTime.now();

        List<Order> orders = orderRepository.findByDateRange(startDate, endDate);

        // 过滤条件
        if (region != null) {
            // 需要关联设备查询
        }
        if (deviceId != null) {
            orders = orders.stream().filter(o -> o.getDeviceId().equals(deviceId)).toList();
        }

        Map<String, Object> report = new HashMap<>();
        report.put("totalSales", orders.size());
        report.put("totalRevenue", orders.stream()
                .map(Order::getTotalAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add));
        report.put("period", period);
        report.put("startDate", startDate);
        report.put("endDate", endDate);

        return report;
    }

    public Map<String, Object> getSalesTrend(String period) {
        LocalDateTime startDate = getStartDate(period);
        LocalDateTime endDate = LocalDateTime.now();
        List<Order> orders = orderRepository.findByDateRange(startDate, endDate);

        Map<String, Object> trend = new HashMap<>();
        // 按日期分组统计
        // 这里简化处理，实际应该按天/周/月分组
        trend.put("data", orders);
        return trend;
    }

    private LocalDateTime getStartDate(String period) {
        LocalDateTime now = LocalDateTime.now();
        return switch (period.toLowerCase()) {
            case "daily" -> now.minus(1, ChronoUnit.DAYS);
            case "weekly" -> now.minus(7, ChronoUnit.DAYS);
            case "monthly" -> now.minus(30, ChronoUnit.DAYS);
            case "yearly" -> now.minus(365, ChronoUnit.DAYS);
            default -> now.minus(7, ChronoUnit.DAYS);
        };
    }

    /**
     * 获取运营看板数据（答辩演示用）
     * 返回：今日订单数、今日销售额、Top3商品、设备列表
     */
    public Map<String, Object> getDashboard() {
        // 1. 查询今日已完成订单
        List<Order> todayOrders = orderRepository.findTodayCompletedOrders();

        // 2. 计算今日订单数和销售额
        int todayOrderCount = todayOrders.size();
        BigDecimal todayRevenue = todayOrders.stream()
                .map(Order::getTotalAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        // 3. 统计Top3商品（按销量）
        Map<Long, Integer> productSales = new HashMap<>();
        for (Order order : todayOrders) {
            Long productId = order.getProductId();
            int quantity = order.getQuantity();
            productSales.put(productId, productSales.getOrDefault(productId, 0) + quantity);
        }

        // 按销量排序取Top3
        List<Map<String, Object>> top3 = productSales.entrySet().stream()
                .sorted(Map.Entry.<Long, Integer>comparingByValue().reversed())
                .limit(3)
                .map(entry -> {
                    Product product = productRepository.findById(entry.getKey()).orElse(null);
                    Map<String, Object> item = new HashMap<>();
                    item.put("name", product != null ? product.getName() : "未知商品");
                    item.put("qty", entry.getValue());
                    return item;
                })
                .collect(Collectors.toList());

        // 4. 查询所有设备
        List<Device> devices = deviceRepository.findAll();
        List<Map<String, Object>> deviceList = devices.stream()
                .map(device -> {
                    Map<String, Object> item = new HashMap<>();
                    item.put("name", device.getName());
                    item.put("location", device.getLocation());
                    item.put("status", device.getStatus().name());
                    return item;
                })
                .collect(Collectors.toList());

        // 5. 组装返回数据
        Map<String, Object> dashboard = new HashMap<>();
        dashboard.put("todayOrders", todayOrderCount);
        dashboard.put("todayRevenue", todayRevenue);
        dashboard.put("top3", top3);
        dashboard.put("devices", deviceList);

        return dashboard;
    }
}


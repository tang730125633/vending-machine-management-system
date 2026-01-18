package com.vending.controller;

import com.vending.service.AIService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * AI功能控制器
 * 提供智能推荐、异常检测、销售预测等AI功能接口
 */
@RestController
@RequestMapping("/ai")
@CrossOrigin(origins = "*")
public class AIController {

    @Autowired
    private AIService aiService;

    /**
     * 获取产品推荐
     */
    @GetMapping("/recommend")
    public ResponseEntity<?> recommendProducts(
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) Long deviceId,
            @RequestParam(defaultValue = "10") int limit) {
        try {
            List<AIService.ProductRecommendation> recommendations = 
                    aiService.recommendProducts(userId, deviceId, limit);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", recommendations);
            response.put("count", recommendations.size());

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500)
                    .body(Map.of("success", false, "message", "推荐失败: " + e.getMessage()));
        }
    }

    /**
     * 检测销售异常
     */
    @GetMapping("/anomalies")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN', 'ADMIN', 'OPERATOR')")
    public ResponseEntity<?> detectAnomalies(
            @RequestParam(required = false) Long deviceId,
            @RequestParam(required = false) String region) {
        try {
            List<AIService.AnomalyAlert> alerts = aiService.detectSalesAnomalies(deviceId, region);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", alerts);
            response.put("count", alerts.size());

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500)
                    .body(Map.of("success", false, "message", "异常检测失败: " + e.getMessage()));
        }
    }

    /**
     * 销售预测
     */
    @GetMapping("/forecast")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN', 'ADMIN', 'OPERATOR')")
    public ResponseEntity<?> predictSales(
            @RequestParam(required = false) Long deviceId,
            @RequestParam(defaultValue = "7") int days) {
        try {
            AIService.SalesForecast forecast = aiService.predictSales(deviceId, days);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", forecast);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500)
                    .body(Map.of("success", false, "message", "预测失败: " + e.getMessage()));
        }
    }

    /**
     * 获取AI服务状态
     */
    @GetMapping("/status")
    public ResponseEntity<?> getAIStatus() {
        Map<String, Object> status = new HashMap<>();
        status.put("enabled", true);
        status.put("modelPath", "./ai_models");
        status.put("features", List.of(
                "智能推荐",
                "异常检测",
                "销售预测"
        ));
        return ResponseEntity.ok(status);
    }
}


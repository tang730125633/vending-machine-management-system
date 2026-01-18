package com.vending.controller;

import com.vending.service.AnalyticsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/analytics")
@CrossOrigin(origins = "*")
public class AnalyticsController {

    @Autowired
    private AnalyticsService analyticsService;

    @GetMapping("/sales-report")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN', 'ADMIN', 'OPERATOR')")
    public ResponseEntity<Map<String, Object>> getSalesReport(
            @RequestParam(required = false) String period,
            @RequestParam(required = false) String region,
            @RequestParam(required = false) Long deviceId,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String brand) {
        return ResponseEntity.ok(analyticsService.getSalesReport(period, region, deviceId, category, brand));
    }

    @GetMapping("/sales-trend")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN', 'ADMIN', 'OPERATOR')")
    public ResponseEntity<Map<String, Object>> getSalesTrend(@RequestParam(required = false) String period) {
        return ResponseEntity.ok(analyticsService.getSalesTrend(period != null ? period : "weekly"));
    }

    @GetMapping("/dashboard")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN', 'ADMIN', 'OPERATOR')")
    public ResponseEntity<Map<String, Object>> getDashboard() {
        return ResponseEntity.ok(analyticsService.getDashboard());
    }
}


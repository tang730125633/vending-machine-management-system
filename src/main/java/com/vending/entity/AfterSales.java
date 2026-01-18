package com.vending.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "after_sales")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class AfterSales {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "order_id", nullable = false)
    private Long orderId;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private AfterSalesType type;

    @Column(nullable = false, length = 200)
    private String reason;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(columnDefinition = "TEXT")
    private String images; // JSON数组，存储多张图片路径

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private AfterSalesStatus status = AfterSalesStatus.PENDING;

    @Column(name = "handler_id")
    private Long handlerId;

    @Column(name = "handle_note", columnDefinition = "TEXT")
    private String handleNote;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "order_id", insertable = false, updatable = false)
    private Order order;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "handler_id", insertable = false, updatable = false)
    private User handler;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    public enum AfterSalesType {
        REFUND,     // 退款
        EXCHANGE,   // 换货
        COMPLAINT   // 投诉
    }

    public enum AfterSalesStatus {
        PENDING,    // 待处理
        APPROVED,   // 已批准
        REJECTED,   // 已拒绝
        PROCESSING, // 处理中
        COMPLETED,  // 已完成
        CANCELLED   // 已取消
    }
}


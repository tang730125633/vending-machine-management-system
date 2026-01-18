package com.vending.repository;

import com.vending.entity.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {
    Optional<Order> findByOrderNumber(String orderNumber);
    List<Order> findByDeviceId(Long deviceId);
    List<Order> findByUserId(Long userId);
    List<Order> findByStatus(Order.OrderStatus status);
    
    @Query("SELECT o FROM Order o WHERE o.createdAt BETWEEN ?1 AND ?2")
    List<Order> findByDateRange(LocalDateTime start, LocalDateTime end);

    @Query("SELECT o FROM Order o WHERE DATE(o.createdAt) = CURRENT_DATE AND o.status = 'COMPLETED'")
    List<Order> findTodayCompletedOrders();
}


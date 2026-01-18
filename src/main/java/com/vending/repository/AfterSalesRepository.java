package com.vending.repository;

import com.vending.entity.AfterSales;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AfterSalesRepository extends JpaRepository<AfterSales, Long> {
    List<AfterSales> findByOrderId(Long orderId);
    List<AfterSales> findByStatus(AfterSales.AfterSalesStatus status);
    List<AfterSales> findByHandlerId(Long handlerId);
}


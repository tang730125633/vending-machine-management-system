package com.vending.repository;

import com.vending.entity.Inventory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface InventoryRepository extends JpaRepository<Inventory, Long> {
    List<Inventory> findByDeviceId(Long deviceId);
    Optional<Inventory> findByDeviceIdAndShelfNumber(Long deviceId, Integer shelfNumber);
    List<Inventory> findByStatus(Inventory.InventoryStatus status);
}


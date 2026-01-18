package com.vending.controller;

import com.vending.entity.Device;
import com.vending.service.DeviceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.lang.NonNull;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/devices")
@CrossOrigin(origins = "*")
public class DeviceController {

    @Autowired
    private DeviceService deviceService;

    @GetMapping
    @PreAuthorize("hasAnyRole('SUPER_ADMIN', 'ADMIN', 'OPERATOR')")
    public ResponseEntity<List<Device>> getAllDevices() {
        return ResponseEntity.ok(deviceService.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Device> getDeviceById(@PathVariable @NonNull Long id) {
        return deviceService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('SUPER_ADMIN', 'ADMIN')")
    public ResponseEntity<Device> createDevice(@RequestBody @NonNull Device device) {
        return ResponseEntity.ok(deviceService.save(device));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN', 'ADMIN')")
    public ResponseEntity<Device> updateDevice(@PathVariable @NonNull Long id, @RequestBody @NonNull Device device) {
        return deviceService.findById(id)
                .map(existingDevice -> {
                    device.setId(id);
                    return ResponseEntity.ok(deviceService.save(device));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN', 'ADMIN')")
    public ResponseEntity<?> deleteDevice(@PathVariable @NonNull Long id) {
        deviceService.deleteById(id);
        return ResponseEntity.ok(Map.of("message", "设备删除成功"));
    }

    @PostMapping("/{deviceCode}/heartbeat")
    public ResponseEntity<?> heartbeat(@PathVariable String deviceCode) {
        deviceService.updateHeartbeat(deviceCode);
        return ResponseEntity.ok(Map.of("message", "心跳更新成功"));
    }
}


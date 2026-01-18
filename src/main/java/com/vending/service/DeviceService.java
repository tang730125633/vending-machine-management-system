package com.vending.service;

import com.vending.entity.Device;
import com.vending.repository.DeviceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class DeviceService {

    @Autowired
    private DeviceRepository deviceRepository;

    public List<Device> findAll() {
        return deviceRepository.findAll();
    }

    public Optional<Device> findById(@NonNull Long id) {
        return deviceRepository.findById(id);
    }

    public Optional<Device> findByDeviceCode(String deviceCode) {
        return deviceRepository.findByDeviceCode(deviceCode);
    }

    public List<Device> findByRegion(String region) {
        return deviceRepository.findByRegion(region);
    }

    public List<Device> findByStatus(Device.DeviceStatus status) {
        return deviceRepository.findByStatus(status);
    }

    public Device save(@NonNull Device device) {
        return deviceRepository.save(device);
    }

    public void updateHeartbeat(String deviceCode) {
        deviceRepository.findByDeviceCode(deviceCode).ifPresent(device -> {
            device.setLastHeartbeat(LocalDateTime.now());
            device.setStatus(Device.DeviceStatus.ONLINE);
            deviceRepository.save(device);
        });
    }

    public void deleteById(@NonNull Long id) {
        deviceRepository.deleteById(id);
    }
}


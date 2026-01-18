package com.vending;

import com.vending.config.AIConfig;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class VendingMachineApplication implements CommandLineRunner {

    @Autowired
    private AIConfig aiConfig;

    public static void main(String[] args) {
        SpringApplication.run(VendingMachineApplication.class, args);
    }

    @Override
    public void run(String... args) throws Exception {
        // 初始化AI模型目录
        aiConfig.initModelDirectory();
        System.out.println("自动售货机管理系统启动完成！");
        if (aiConfig.isAiEnabled()) {
            System.out.println("AI功能已启用，模型路径: " + aiConfig.getModelPath());
        }
    }
}


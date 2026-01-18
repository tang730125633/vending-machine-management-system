package com.vending.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;

import java.io.File;

/**
 * AI配置类
 * 管理AI模型路径和初始化
 */
@Configuration
@EnableScheduling
public class AIConfig {

    @Value("${ai.enabled:true}")
    private boolean aiEnabled;

    @Value("${ai.model-path:./ai_models}")
    private String modelPath;

    /**
     * 初始化AI模型目录
     */
    public void initModelDirectory() {
        if (aiEnabled) {
            File modelDir = new File(modelPath);
            if (!modelDir.exists()) {
                modelDir.mkdirs();
                System.out.println("AI模型目录已创建: " + modelPath);
            }
        }
    }

    /**
     * 定期检查AI模型状态
     * 每小时执行一次
     */
    @Scheduled(fixedRate = 3600000) // 1小时
    public void checkModelStatus() {
        if (aiEnabled) {
            File modelDir = new File(modelPath);
            if (modelDir.exists()) {
                File[] modelFiles = modelDir.listFiles();
                if (modelFiles != null && modelFiles.length > 0) {
                    System.out.println("检测到 " + modelFiles.length + " 个AI模型文件");
                } else {
                    System.out.println("AI模型目录为空，使用默认算法");
                }
            }
        }
    }

    public boolean isAiEnabled() {
        return aiEnabled;
    }

    public String getModelPath() {
        return modelPath;
    }
}


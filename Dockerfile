# 使用已编译好的 jar 文件
FROM eclipse-temurin:17-jre

WORKDIR /app

# 复制配置文件（会覆盖 jar 包内的配置）
COPY src/main/resources/application.yml /tmp/application.yml

# 复制编译好的 jar 文件
COPY target/vending-machine-management-1.0.0.jar app.jar

# 暴露端口
EXPOSE 8080

# 启动应用，使用外部配置文件覆盖 jar 包内的配置
ENTRYPOINT ["java", "-jar", "app.jar", "--spring.config.location=/tmp/application.yml"]

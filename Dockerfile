# Sử dụng Ubuntu làm base image
FROM ubuntu:20.04

# Cập nhật và cài đặt các gói cần thiết mà không thay đổi DNS
RUN apt-get update && apt-get install -y \
    lsof \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Dọn dẹp tiến trình đang sử dụng cổng 8080 nếu có
RUN lsof -t -i :8080 | xargs -r kill -9

# Cài đặt code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Mở cổng 8080
EXPOSE 8080

# Chạy code-server với cấu hình không cần auth và lắng nghe ở địa chỉ 0.0.0.0:8080
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "none"]

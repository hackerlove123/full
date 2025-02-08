# Sử dụng Ubuntu bản nhẹ nhất làm base image
FROM ubuntu:20.04

# Cập nhật hệ thống và cài đặt các gói cần thiết
RUN apt-get update -y && \
    apt-get install -y \
    curl \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Cài đặt code-server từ script
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Mở cổng 8080 cho code-server
EXPOSE 8080

# Chạy code-server
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "none"]

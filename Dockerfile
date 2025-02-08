# Sử dụng Ubuntu 20.04 Slim làm base image
FROM ubuntu:20.04

# Cập nhật hệ thống và cài đặt các gói cần thiết
RUN apt-get update -y && \
    apt-get install -y \
    lsof \
    curl \
    git \
    tmux \
    htop \
    python3-pip \
    bash \
    bash-completion \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Cài đặt code-server từ script
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Cài đặt NVM nếu chưa có
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# Tải lại cấu hình shell cho NVM và cài đặt Node.js
RUN echo 'source ~/.bashrc' >> ~/.bashrc && \
    bash -c "source ~/.bashrc && nvm install 22.9.0 && nvm use 22.9.0"

# Cập nhật npm lên phiên bản mới nhất
RUN bash -c "source ~/.bashrc && npm install -g npm"

# Sao chép toàn bộ nội dung của thư mục hiện tại vào trong container
WORKDIR /app
COPY . .

# Cài đặt các thư viện npm: hpack, https, commander, colors, socks
RUN bash -c "source ~/.bashrc && npm install -g hpack https commander colors socks"

# Mở cổng 8080 cho code-server
EXPOSE 8080

# Chạy code-server
CMD ["bash", "-c", "source ~/.bashrc && code-server --bind-addr 0.0.0.0:8080 --auth none"]

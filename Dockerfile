# Sử dụng Alpine để giảm nhẹ Docker image
FROM alpine:latest

# Cài đặt các gói cần thiết
RUN apk update && \
    apk add --no-cache \
    lsof \
    curl \
    git \
    tmux \
    htop \
    python3 \
    bash \
    nodejs \
    npm \
    && rm -rf /var/cache/apk/*

# Cài đặt code-server từ script
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Cài đặt các thư viện npm: hpack, https, commander, colors, socks
RUN npm install -g hpack https commander colors socks

# Cài đặt NVM nếu chưa có
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# Tải lại cấu hình shell
RUN echo 'source ~/.bashrc' >> ~/.bashrc

# Cài đặt Node.js 22.9.0 và sử dụng nó
RUN bash -c "source ~/.bashrc && nvm install 22.9.0 && nvm use 22.9.0"

# Cập nhật npm lên phiên bản mới nhất
RUN bash -c "source ~/.bashrc && npm install -g npm"

# Mở cổng 8080 cho code-server
EXPOSE 8080

# Chạy code-server
CMD ["bash", "-c", "source ~/.bashrc && code-server --bind-addr 0.0.0.0:8080 --auth none"]

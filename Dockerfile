# Sử dụng Alpine làm base image
FROM alpine:latest

# Cài đặt các gói cần thiết
RUN apk update && \
    apk add --no-cache \
    bash \
    curl \
    git \
    tmux \
    htop \
    python3 \
    bash-completion \
    ca-certificates \
    && rm -rf /var/cache/apk/*

# Cài đặt code-server từ script
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Cài đặt NVM
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# Cài đặt Node.js 22.9.0 và npm thông qua NVM
RUN bash -c "source $HOME/.bashrc && nvm install 22.9.0 && nvm use 22.9.0"

# Cập nhật npm lên phiên bản mới nhất
RUN bash -c "source $HOME/.bashrc && npm install -g npm"

# Cài đặt các thư viện npm: hpack, https, commander, colors, socks
RUN bash -c "source $HOME/.bashrc && npm install -g hpack https commander colors socks"

# Sao chép toàn bộ nội dung của thư mục hiện tại vào trong container
WORKDIR /app
COPY . .

# Mở cổng 8080 cho code-server
EXPOSE 8080

# Chạy code-server
CMD ["bash", "-c", "source $HOME/.bashrc && code-server --bind-addr 0.0.0.0:8080 --auth none"]

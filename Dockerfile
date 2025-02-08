# Sử dụng Debian Slim làm base image (nhẹ hơn Ubuntu)
FROM debian:bullseye-slim

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
    ca-certificates \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Cài đặt code-server từ script
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Cài đặt NVM
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# Cài đặt Node.js 22.9.0 và npm thông qua NVM
# Đảm bảo source lại bashrc trong cùng một shell để NVM có hiệu lực
RUN bash -c "source $HOME/.bashrc && nvm install 22.9.0 && nvm use 22.9.0"

# Cập nhật npm lên phiên bản mới nhất
RUN bash -c "source $HOME/.bashrc && npm install -g npm"

# Sao chép toàn bộ nội dung của thư mục hiện tại vào trong container
WORKDIR /app
COPY . .

# Cài đặt các thư viện npm: hpack, https, commander, colors, socks
RUN bash -c "source $HOME/.bashrc && npm install -g hpack https commander colors socks"

# Mở cổng 8080 cho code-server
EXPOSE 8080

# Chạy code-server
CMD ["bash", "-c", "source $HOME/.bashrc && code-server --bind-addr 0.0.0.0:8080 --auth none"]

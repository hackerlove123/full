# Sử dụng Ubuntu bản nhẹ nhất làm base image
FROM ubuntu:20.04

# Thiết lập môi trường không tương tác để tránh yêu cầu input khi cài đặt gói
ENV DEBIAN_FRONTEND=noninteractive

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
RUN bash -c "source $HOME/.bashrc && nvm install 22.9.0 && nvm use 22.9.0"

# Cập nhật npm lên phiên bản mới nhất
RUN bash -c "source $HOME/.bashrc && npm install -g npm"

# Sao chép toàn bộ nội dung của thư mục hiện tại vào trong container
WORKDIR /app
COPY . .

# Cài đặt các thư viện npm cục bộ (local) thay vì toàn cục (global)
RUN bash -c "source $HOME/.bashrc && npm install hpack https commander colors socks"

# Mở cổng 8080 cho code-server
EXPOSE 8080

# Chạy code-server
CMD ["bash", "-c", "source $HOME/.bashrc && code-server --bind-addr 0.0.0.0:8080 --auth none"]

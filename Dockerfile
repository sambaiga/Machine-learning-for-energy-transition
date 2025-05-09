# Use a lightweight Python base image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.cargo/bin:$PATH"

# Install Quarto
RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.5.56/quarto-1.5.56-linux-amd64.deb \
    && dpkg -i quarto-1.5.56-linux-amd64.deb \
    && rm quarto-1.5.56-linux-amd64.deb

# Install TinyTeX
RUN wget -qO- "https://yihui.org/tinytex/install-bin-unix.sh" | sh \
    && mv /root/.TinyTeX /opt/TinyTeX \
    && /opt/TinyTeX/bin/*/tlmgr path add \
    && tlmgr install latexmk xetex \
    && tlmgr path add
ENV PATH="/opt/TinyTeX/bin/x86_64-linux:$PATH"

# Verify installations
RUN uv --version
RUN quarto --version
RUN tlmgr --version

# Copy project files (if any)
COPY . .

# Set default command
CMD ["bash"]
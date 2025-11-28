# Dockerfile (for FastAPI + Selenium/Playwright + Whisper)
FROM python:3.10-slim

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /app

# system deps needed for Chrome / ffmpeg / rendering
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget ca-certificates \
    build-essential curl gnupg libnss3 libatk-bridge2.0-0 libgtk-3-0 \
    libx11-xcb1 libgbm1 libxss1 libasound2 ffmpeg chromium chromium-driver \
 && rm -rf /var/lib/apt/lists/*

# copy requirements and install
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# copy app
COPY . .

# ensure uvicorn available (it is in requirements if uvicorn[...] was present)
ENV PORT=7860
EXPOSE 7860

# Run your FastAPI app with uvicorn (adjust module:path if different)
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port ${PORT} --workers 1"]

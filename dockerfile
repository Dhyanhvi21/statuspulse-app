# -------- BUILDER --------
FROM python:3.11-slim as builder
WORKDIR /app
COPY app/requirements.txt .
RUN pip install --user -r requirements.txt

# -------- RUNTIME --------
FROM python:3.11-slim
WORKDIR /app

# Create non-root user
RUN useradd -m appuser
COPY --from=builder /root/.local /home/appuser/.local
COPY app/ .
ENV PATH=/home/appuser/.local/bin:$PATH
USER appuser
EXPOSE 8000
CMD ["gunicorn", "-k", "uvicorn.workers.UvicornWorker", "main:app", "-b", "0.0.0.0:8000"]
HEALTHCHECK CMD curl --fail http://localhost:8000/health || exit 1
FROM python:3.11-slim AS builder

WORKDIR /app

COPY requirements.txt .
COPY . /app

RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

RUN pip wheel --no-cache-dir --no-deps --wheel-dir /wheels -r requirements.txt

FROM python:3.11-slim

WORKDIR /app

COPY --from=builder /wheels /wheels
COPY --from=builder /app /app

RUN pip install --no-cache /wheels/*

ENV CSV_FILE=data.csv

CMD ["python", "main.py"]

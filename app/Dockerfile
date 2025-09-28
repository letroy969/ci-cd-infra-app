FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

# Use a simple production server
CMD ["gunicorn", "--bind", "0.0.0.0:80", "app:app"]

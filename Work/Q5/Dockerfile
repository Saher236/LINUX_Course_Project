FROM python:3.9

WORKDIR /app

COPY plant_plots.py /app/plant_plots.py
COPY requirements.txt /app/requirements.txt

RUN pip install --no-cache-dir -r requirements.txt

RUN mkdir -p /app/output

ENTRYPOINT ["python3", "plant_plots.py"]
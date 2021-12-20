FROM python:3.9-slim

LABEL org.opencontainers.image.source=https://github.com/mlgal24/docker-geobase

ENV PYTHONUNBUFFERED 1

RUN apt-get update \
    && apt-get install -y \
    binutils gdal-bin libgdal-dev \
    libproj-dev git libfreexl1 libxml2 libpng-dev ffmpeg libsm6 libxext6 gcc g++ \
    && rm -rf /var/lib/apt/lists/*

RUN export CPLUS_INCLUDE_PATH=/usr/include/gdal \
    && export C_INCLUDE_PATH=/usr/include/gdal \
    && python -m pip install numpy \
    && python -m pip install GDAL==$(gdal-config --version) --global-option=build_ext --global-option="-I/usr/include/gdal" \
    && python -m pip install fiona rasterio shapely opencv-python scipy scikit-image scikit-learn pandas matplotlib geopandas seaborn earthpy

COPY requirements.txt .
RUN python -m pip install --no-cache-dir -r requirements.txt

RUN ldconfig
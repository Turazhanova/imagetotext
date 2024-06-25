# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory
WORKDIR /ImagetoText

# Copy the current directory contents into the container at /app
COPY . /ImagetoText

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Install OpenCV dependencies
RUN apt-get update && apt-get install -y \
    libsm6 libxext6 libxrender-dev wget \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Tesseract and base language data files
RUN apt-get update && apt-get install -y tesseract-ocr wget \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Download and install Russian, Uzbek and Kazakh language data files
RUN wget -P /usr/share/tesseract-ocr/4.00/tessdata/ https://github.com/tesseract-ocr/tessdata/raw/main/rus.traineddata \
    && wget -P /usr/share/tesseract-ocr/4.00/tessdata/ https://github.com/tesseract-ocr/tessdata/raw/main/uzb.traineddata \
    && wget -P /usr/share/tesseract-ocr/4.00/tessdata/ https://github.com/tesseract-ocr/tessdata/raw/main/kaz.traineddata

# Set TESSDATA_PREFIX environment variable
ENV TESSDATA_PREFIX=/usr/share/tesseract-ocr/4.00/tessdata/

# Make port 5008 available to the world outside this container
EXPOSE 5008

# Define environment variable
ENV FLASK_APP=image.py

# Run app.py when the container launches
CMD ["flask", "run", "--host=0.0.0.0", "--port=5008"]

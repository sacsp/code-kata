# Use an official Ubuntu runtime as a parent image
FROM ubuntu:20.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Set the working directory in the container
WORKDIR /app

# Install Python, JDK 11, and other necessary packages
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    openjdk-11-jdk \
    software-properties-common \
    python3-virtualenv \
    && rm -rf /var/lib/apt/lists/*

# Set JAVA_HOME environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"

# Copy the requirements file
COPY requirements.txt .

# Create a virtual environment
RUN python3 -m venv venv

# Activate the virtual environment and install dependencies
RUN /bin/bash -c "source venv/bin/activate && pip install --no-cache-dir -r requirements.txt"

# Copy the entire CODE-KATA directory contents into the container at /app
COPY . .

# Ensure the Output_files/p1 directory exists
RUN mkdir -p /app/Output_files/p1

RUN echo "Current working directory:" && pwd
RUN echo "Files in current directory:" && ls -l
RUN echo "Files in /app/Output_files/p1:" && ls -l /app/Output_files/p1

# Add a volume for mapping host directory to container directory
VOLUME ["/app/Output_files/p1/"]

# Set environment variables if needed (optional)
# ENV CONFIG_FILE=config.ini

# Make the run.sh scripts executable
RUN chmod +x p1-run.sh
RUN chmod +x p2-run.sh

# Make port 80 available to the world outside this container (optional)
EXPOSE 80

# Run the run.sh script when the container launches
# ENTRYPOINT ["./run.sh"]

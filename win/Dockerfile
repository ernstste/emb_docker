# Use the Windows Server Core LTSC 2019 base image
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Set ARGS and ENV variables
ARG DOCKER_STARTUP_SCRIPT=C:\\docker_startup.bat
ARG SCOOP_URL=https://get.scoop.sh
ARG OSGEO_URL=https://download.osgeo.org/osgeo4w/v2/osgeo4w-setup.exe
ARG PACKAGES='qgis-ltr-full python3-core python3-gdal python3-pip python3-packaging python3-wheel python3-pyqt5 python3-matplotlib python3-plotly python3-scipy python3-pyqgis-ltr-common openssl'
ARG TEMP_DIR=C:\\TEMP

ENV \
  OSGEO4W_ROOT=C:\\OSGeo4W \
  EMB_DIR=C:\\enmapbox \
  DOCKER_STARTUP_SCRIPT=${DOCKER_STARTUP_SCRIPT}

# Enable PowerShell for use during the Docker build
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Install QGIS through OSGeo4W
RUN mkdir $env:TEMP_DIR; \
  Invoke-WebRequest -Uri $env:OSGEO_URL -OutFile "$env:TEMP_DIR\\osgeo4w_v2-setup.exe"; \
  Start-Process -wait -FilePath "$env:TEMP_DIR\\osgeo4w_v2-setup.exe" -ArgumentList \
   '--arch', 'x86_64', \
   '--autoaccept', \
   '--quiet-mode', \
   '--delete-orphans', \
   '--no-shortcuts', \
   '--packages', "$env:PACKAGES", \
   '--root', "$env:OSGEO4W_ROOT", \
   '--site', 'http://www.norbit.de/osgeo4w/v2', \
   '--site', 'http://download.osgeo.org/osgeo4w/v2', \
   '--site', 'http://ftp.osuosl.org/pub/osgeo/download/osgeo4w/v2', \
   '--upgrade-also';

# Install Scoop, use Scoop to install git and 7zip easily
RUN Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser; \
    Invoke-WebRequest -Uri $env:SCOOP_URL -OutFile "$env:TEMP_DIR\scoop_install.ps1"; \
    & "$env:TEMP_DIR\scoop_install.ps1" -RunAsAdmin; \
    scoop install git 7zip

# Get opengl32.dll for the imagecube tests
RUN Invoke-WebRequest -Uri 'https://downloads.fdossena.com/geth.php?r=mesa64-latest' -OutFile "$env:TEMP_DIR\\mesa64-latest.7z"; \
    & 7z e "$env:TEMP_DIR\\mesa64-latest.7z" -oC:\\temp opengl32.dll; \
    Copy-Item -Path "$env:TEMP_DIR\\opengl32.dll" -Destination "C:\\Windows\\System32\\opengl32.dll" -Force; \
    Remove-Item -Path $env:TEMP_DIR -Recurse -Force -Confirm:$false

# Clone the EnMAP-Box repo and install requirements via pip
# RUN git clone --recurse-submodules https://github.com/EnMAP-Box/enmap-box.git "$env:EMB_DIR"

COPY docker_startup.bat ${DOCKER_STARTUP_SCRIPT}
# COPY setup_enmapbox.bat "C:\\setup_enmapbox.bat"
# RUN C:\\setup_enmapbox.bat

# Set working directory to OSGeo dir and activate the OSGeo env at startup
WORKDIR $OSGEO4W_ROOT
CMD ["cmd", "/c", "%DOCKER_STARTUP_SCRIPT%"]

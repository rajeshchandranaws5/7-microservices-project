#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Ensure the script is NOT run directly as root or with sudo
if [ "$EUID" -eq 0 ]; then
  echo "Please run this script as your regular user (WITHOUT sudo)."
  echo "The script will prompt for your password automatically when running system tasks."
  exit 1
fi

echo "========================================"
echo "1. Installing Core Tools, Languages & Nginx"
echo "========================================"
sudo apt update
sudo apt install -y \
  tree \
  nginx \
  postgresql postgresql-contrib \
  openjdk-21-jdk maven \
  golang-go \
  python3 python3-venv python3-pip \
  ruby-full build-essential libpq-dev \
  php-cli php-pgsql php-curl \
  curl git

echo "========================================"
echo "2. Configuring and Installing .NET SDK 8.0"
echo "========================================"
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:dotnet/backports -y

# Find the newly added PPA repository file
PPA_FILE=$(grep -rl "ppa.launchpadcontent.net/dotnet/backports" /etc/apt/sources.list.d/ | head -1)

# Modify the repository architecture constraints if applicable
sudo sed -i '/^Architectures:/d' "$PPA_FILE"
sudo sed -i '/^Components:/a Architectures: amd64' "$PPA_FILE"

# Clean up matching list files, update cache, and install
sudo rm -f /var/lib/apt/lists/ppa.launchpadcontent.net_dotnet_backports_ubuntu_dists_resolute_*
sudo apt update
apt-cache policy dotnet-sdk-8.0
sudo apt install dotnet-sdk-8.0 -y

echo "========================================"
echo "3. Installing NVM & Node.js 24"
echo "========================================"
# Download and run the NVM installer script
curl -o- https://githubusercontent.com | bash

echo "Loading NVM into the current shell session..."
# Load nvm configuration dynamically into this running script session
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

echo "Downloading and installing Node.js 24..."
nvm install 24

# Set Node 24 as the default version for new terminal instances
nvm alias default 24

echo "========================================"
echo "4. Enabling Background Services (Persist on Restart)"
echo "========================================"
# Languages and runtimes (Node, Python, Go, Java, .NET) are executed on-demand
# Web servers (Nginx) and databases (PostgreSQL) require background system services

echo "Enabling and starting Nginx Web Server..."
sudo systemctl enable nginx
sudo systemctl start nginx

echo "Enabling and starting PostgreSQL Database..."
sudo systemctl enable postgresql
sudo systemctl start postgresql

echo "Checking service statuses..."
sudo systemctl is-active nginx postgresql || true

echo "========================================"
echo "5. Verifying Installed Versions"
echo "========================================"

java -version
echo "----------------------------------------"
mvn -version
echo "----------------------------------------"
go version
echo "----------------------------------------"
python3 --version
echo "----------------------------------------"
node --version
echo "----------------------------------------"
npm --version
echo "----------------------------------------"
dotnet --version
echo "----------------------------------------"
ruby --version
echo "----------------------------------------"
php --version
echo "----------------------------------------"
psql --version
echo "----------------------------------------"
nginx -v

echo "========================================"
echo "All installations and configurations complete!"
echo "Please restart your terminal or run: source ~/.bashrc to update your active shell environment."
echo "========================================"

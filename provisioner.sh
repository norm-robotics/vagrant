#!/bin/bash

# somewhat inspired by Queens VEX's Vagrant setup

export DEBIAN_FRONTEND=noninteractive
set -Eeuo pipefail

echo 'installing clang...'
sudo bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"

echo 'installing apt packages...'
sudo apt-get update -yq
sudo apt-get install -yq \
  build-essential \
  python3-pip \
  apt-transport-https \
  gcc-arm-none-eabi \
  wget \
  gpg

echo 'installing pros-cli...'
python3 -m pip install pros-cli

echo 'installing vscode...'
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt-get update -yq
sudo apt-get install -yq code

echo 'installing vscode extensions...'
code \
  --install-extension 'sigbots.pros' \
  --install-extension 'ms-vscode.cpptools' \
  --install-extension 'josetr.cmake-language-support-vscode' \
  --install-extension 'ms-vscode.cmake-tools' \
  --install-extension 'usernamehw.errorlens' \
  --install-extension 'ms-vsliveshare.vsliveshare' \
  --install-extension 'ms-vscode.makefile-tools' \
  --install-extension 'jeff-hykin.better-cpp-syntax' \
  --install-extension 'aaron-bond.better-comments' \
  --install-extension 'eamodio.gitlens' \
  --install-extension 'llvm-vs-code-extensions.vscode-clangd' \
  --install-extension 'xaver.clang-format'

echo "enabling dark mode for vscode because i'm not a sadist..."
mkdir -p /home/vagrant/.config/Code/User
cat <<EOF > /home/vagrant/.config/Code/User/settings.json
{
  "workbench.colorTheme": "Visual Studio Dark"
}
EOF

echo 'creating service file for vscode server'
mkdir -p /home/vagrant/.vscode/cli
cat <<EOF > /home/vagrant/.vscode/cli/code-server.service
[Unit]
Description=Visual Studio Code Server
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
Restart=always
RestartSec=10
ExecStart=/usr/share/code/bin/code-tunnel "--verbose" "--cli-data-dir" "/home/vagrant/.vscode/cli" "serve-web" "--host" "0.0.0.0" "--port" "8080" "--without-connection-token" "--accept-server-license-terms" "--extensions-dir" "/home/vagrant/.vscode/extensions" "--user-data-dir" "/home/vagrant/.config/Code/User"

[Install]
WantedBy=default.target
EOF
mkdir -p /home/vagrant/.config/systemd/user
ln -s /home/vagrant/.vscode/cli/code-server.service /home/vagrant/.config/systemd/user
systemctl --user enable --now code-server.service 
sudo loginctl enable-linger vagrant

echo "!!!!"
echo "!!!!"
echo "Your development machine has been fully setup. Visit http://localhost:8080 to get started." 

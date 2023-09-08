#!/bin/bash

# somewhat inspired by Queens VEX's Vagrant setup

# taken from https://gist.github.com/junkdog/70231d6953592cd6f27def59fe19e50d?permalink_comment_id=4336074#gistcomment-4336074
update_alternatives() {
    local version=${1}
    local priority=${2}
    local master=${3}
    local slaves=${4}
    local path=${5}
    local cmdln

    cmdln="--verbose --install ${path}${master} ${master} ${path}${master}-${version} ${priority}"
    for slave in ${slaves}; do
        cmdln="${cmdln} --slave ${path}${slave} ${slave} ${path}${slave}-${version}"
    done
    sudo update-alternatives ${cmdln}
}

export DEBIAN_FRONTEND=noninteractive
set -Eeuo pipefail

export LLVM_VERSION="17"
echo "installing llvm ${LLVM_VERSION}..."
wget https://apt.llvm.org/llvm.sh
chmod +x llvm.sh
sudo ./llvm.sh ${LLVM_VERSION}

echo 'installing apt packages...'
sudo apt-get update -yq
sudo apt-get install -yq \
  build-essential \
  python3-pip \
  apt-transport-https \
  gcc-arm-none-eabi \
  wget \
  gpg \
  clangd-17 \
  clang-tools-17 \
  clang-format-17 \
  clang-tidy-17 

master="llvm-config"
slaves="llvm-addr2line llvm-ar llvm-as llvm-bcanalyzer llvm-bitcode-strip llvm-cat llvm-cfi-verify llvm-cov llvm-c-test llvm-cvtres llvm-cxxdump llvm-cxxfilt llvm-cxxmap llvm-debuginfo-analyzer llvm-debuginfod llvm-debuginfod-find llvm-diff llvm-dis llvm-dlltool llvm-d
warfdump llvm-dwarfutil llvm-dwp llvm-exegesis llvm-extract llvm-gsymutil llvm-ifs llvm-install-name-tool llvm-jitlink llvm-jitlink-executor llvm-lib llvm-libtool-darwin llvm-link llvm-lipo llvm-lto llvm-lto2 llvm-mc llvm-mca llvm-ml llvm-modextract llvm-mt llvm-nm llv
m-objcopy llvm-objdump llvm-opt-report llvm-otool llvm-pdbutil llvm-PerfectShuffle llvm-profdata llvm-profgen llvm-ranlib llvm-rc llvm-readelf llvm-readobj llvm-reduce llvm-remark-size-diff llvm-remarkutil llvm-rtdyld llvm-sim llvm-size llvm-split llvm-stress llvm-stri
ngs llvm-strip llvm-symbolizer llvm-tapi-diff llvm-tblgen llvm-tli-checker llvm-undname llvm-windres llvm-xray"

update_alternatives "${LLVM_VERSION}" "1" "${master}" "${slaves}" "/usr/bin/"

master="clang"
slaves="asan_symbolize bugpoint clang++ clang-cpp clang-format clang-tidy clangd count dsymutil FileCheck ld64.lld ld.lld llc lld lldb lldb-argdumper lldb-instr lldb-server lldb-vscode lld-link lli lli-child-target not obj2yaml opt sanstats split-file UnicodeNameMappingGenerator verify-uselis
torder wasm-ld yaml2obj yaml-bench"

update_alternatives "${LLVM_VERSION}" "1" "${master}" "${slaves}" "/usr/bin/"

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
  --install-extension 'ms-vscode.cmake-tools' \
  --install-extension 'usernamehw.errorlens' \
  --install-extension 'ms-vsliveshare.vsliveshare' \
  --install-extension 'ms-vscode.makefile-tools' \
  --install-extension 'jeff-hykin.better-cpp-syntax' \
  --install-extension 'aaron-bond.better-comments' \
  --install-extension 'eamodio.gitlens' \
  --install-extension 'llvm-vs-code-extensions.vscode-clangd'

echo "enabling dark mode for vscode because i'm not a sadist..."
mkdir -p /home/vagrant/.vscode-server/data/Machine
cat <<EOF > /home/vagrant/.vscode-server/data/Machine/settings.json
{
    "workbench.colorTheme": "Visual Studio Dark",
    "C_Cpp.intelliSenseEngine": "disabled",
    "pros.showWelcomeOnStartup": false,
    "pros.showInstallOnStartup": false,
    "gitlens.showWhatsNewAfterUpgrades": false,
    "gitlens.showWelcomeOnInstall": false,
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
ExecStart=/usr/share/code/bin/code-tunnel "--verbose" "--cli-data-dir" "/home/vagrant/.vscode/cli" "serve-web" "--host" "0.0.0.0" "--port" "8080" "--without-connection-token" "--accept-server-license-terms" "--extensions-dir" "/home/vagrant/.vscode/extensions"

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

sudo apt update
sudo apt install -y \
  gcc \
  g++ \
  make
sudo apt install -y \
  python3 \
  python3-pip \
  python3-venv \
  lua5.1 \
  luarocks \
  shellcheck \
  shfmt

sudo apt install -y \
  git \
  curl \
  wget \
  unzip \
  ripgrep \
  fd-find \
  fzf \
  xclip \
  build-essential \
  cmake \
  pkg-config

npm install -g \
  neovim \
  typescript \
  typescript-language-server \
  vscode-langservers-extracted \
  prettier

pip install --user \
  pynvim \
  black \
  isort \
  ruff

sudo apt install fonts-noto-color-emoji
sudo apt install -y \
  lazygit \
  clangd


mkdir -p $HOME/Libs
cd $HOME/Libs
# Download and install nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
# in lieu of restarting the shell
\. "$HOME/.nvm/nvm.sh"
# Download and install Node.js:
nvm install 24
# Verify the Node.js version:
node -v # Should print "v24.13.0".
# Verify npm version:
npm -v # Should print "11.6.2".

sudo apt install python3 pip -y


# Verilator
# Prerequisites:
sudo apt-get install git help2man perl python3 make autoconf g++ flex bison ccache
sudo apt-get install libgoogle-perftools-dev numactl perl-doc
sudo apt-get install libfl2  # Ubuntu only (ignore if gives error)
sudo apt-get install libfl-dev  # Ubuntu only (ignore if gives error)
sudo apt-get install zlibc zlib1g zlib1g-dev  # Ubuntu only (ignore if gives error)

git clone https://github.com/verilator/verilator $HOME/Libs/verilator   # Only first time

# Every time you need to build:
cd $HOME/Libs/verilator
git pull         # Make sure git repository is up-to-date
git checkout stable      # Use most recent stable release

autoconf         # Create ./configure script
./configure      # Configure and create Makefile
make -j `nproc`  # Build Verilator itself (if error, try just 'make')
sudo make install



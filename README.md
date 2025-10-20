# ReductrAI Package Distribution

Official package distributions for ReductrAI across multiple platforms.

## Supported Package Managers

- **APT** (Debian/Ubuntu)
- **YUM/DNF** (RHEL/CentOS/Fedora)
- **Homebrew** (macOS/Linux)
- **Snap** (Universal Linux)

## Installation

### Debian/Ubuntu (APT)

```bash
# Add ReductrAI repository
curl -fsSL https://pkg.reductrai.com/gpg.key | sudo apt-key add -
echo "deb https://pkg.reductrai.com/apt stable main" | sudo tee /etc/apt/sources.list.d/reductrai.list

# Install ReductrAI
sudo apt update
sudo apt install reductrai
```

### RHEL/CentOS/Fedora (YUM/DNF)

```bash
# Add ReductrAI repository
sudo rpm --import https://pkg.reductrai.com/gpg.key
sudo curl -o /etc/yum.repos.d/reductrai.repo https://pkg.reductrai.com/yum/reductrai.repo

# Install ReductrAI
sudo yum install reductrai
# or for Fedora
sudo dnf install reductrai
```

### macOS/Linux (Homebrew)

```bash
# Add ReductrAI tap
brew tap reductrai/tap

# Install ReductrAI
brew install reductrai
```

### Universal Linux (Snap)

```bash
# Install from Snap Store
sudo snap install reductrai

# Connect required interfaces
sudo snap connect reductrai:network
sudo snap connect reductrai:network-bind
```

## Configuration

After installation, configure ReductrAI:

```bash
# Set license key
sudo reductrai config set license.key YOUR_LICENSE_KEY

# Configure backend
sudo reductrai config set datadog.api_key YOUR_DATADOG_KEY

# Start service
sudo systemctl start reductrai
sudo systemctl enable reductrai
```

## Service Management

### SystemD (Linux)

```bash
# Start/stop/restart
sudo systemctl start reductrai
sudo systemctl stop reductrai
sudo systemctl restart reductrai

# Check status
sudo systemctl status reductrai

# View logs
sudo journalctl -u reductrai -f
```

### Homebrew Services (macOS)

```bash
# Start/stop/restart
brew services start reductrai
brew services stop reductrai
brew services restart reductrai

# Check status
brew services list
```

## Uninstallation

### Debian/Ubuntu
```bash
sudo apt remove reductrai
sudo apt purge reductrai  # Also remove config files
```

### RHEL/CentOS/Fedora
```bash
sudo yum remove reductrai
```

### macOS
```bash
brew uninstall reductrai
brew untap reductrai/tap
```

### Snap
```bash
sudo snap remove reductrai
```

## Package Contents

Each package includes:
- `reductrai` - Main proxy binary
- `reductrai-dashboard` - Web UI (optional)
- `reductrai-cli` - Command-line interface
- Configuration files in `/etc/reductrai/`
- SystemD service files
- Documentation in `/usr/share/doc/reductrai/`

## Support

- Documentation: https://docs.reductrai.com
- Support: support@reductrai.com
- Issues: https://github.com/reductrai/reductrai-packages/issues
class Reductrai < Formula
  desc "AI SRE Proxy - Full observability at 10% of the cost"
  homepage "https://reductrai.com"
  version "1.0.0"

  if OS.mac? && Hardware::CPU.arm?
    url "https://releases.reductrai.com/v1.0.0/reductrai-darwin-arm64.tar.gz"
    sha256 "PLACEHOLDER_SHA256_DARWIN_ARM64"
  elsif OS.mac?
    url "https://releases.reductrai.com/v1.0.0/reductrai-darwin-amd64.tar.gz"
    sha256 "PLACEHOLDER_SHA256_DARWIN_AMD64"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://releases.reductrai.com/v1.0.0/reductrai-linux-arm64.tar.gz"
    sha256 "PLACEHOLDER_SHA256_LINUX_ARM64"
  else
    url "https://releases.reductrai.com/v1.0.0/reductrai-linux-amd64.tar.gz"
    sha256 "PLACEHOLDER_SHA256_LINUX_AMD64"
  end

  depends_on :arch => [:x86_64, :arm64]

  def install
    bin.install "reductrai"
    bin.install "reductrai-cli"

    # Install configuration
    (etc/"reductrai").mkpath
    etc.install "config/reductrai.yaml" => "reductrai/config.yaml"

    # Install documentation
    doc.install "README.md"
    doc.install "LICENSE"
  end

  def post_install
    (var/"log/reductrai").mkpath
    (var/"lib/reductrai").mkpath
  end

  service do
    run [opt_bin/"reductrai", "start", "--config", etc/"reductrai/config.yaml"]
    log_path var/"log/reductrai/reductrai.log"
    error_log_path var/"log/reductrai/reductrai-error.log"
    keep_alive true
    working_dir var/"lib/reductrai"
    environment_variables REDUCTRAI_HOME: var/"lib/reductrai"
  end

  def caveats
    <<~EOS
      To configure ReductrAI, edit:
        #{etc}/reductrai/config.yaml

      Set your license key:
        reductrai-cli config set license.key YOUR_LICENSE_KEY

      To start ReductrAI:
        brew services start reductrai

      Dashboard will be available at:
        http://localhost:5173
    EOS
  end

  test do
    system "#{bin}/reductrai", "--version"
    system "#{bin}/reductrai-cli", "--version"
  end
end
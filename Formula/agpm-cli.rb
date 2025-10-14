class AgpmCli < Formula
  desc "AGent Package Manager - A Git-based package manager for coding agents"
  homepage "https://github.com/aig787/agpm"
  version "0.4.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aig787/agpm/releases/download/v0.4.5/agpm-cli-aarch64-apple-darwin.tar.xz"
      sha256 "fa1b7b2a6f09ee83985c74633b289dab4da4e2b289558d4b27f51bb66b5f7514"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aig787/agpm/releases/download/v0.4.5/agpm-cli-x86_64-apple-darwin.tar.xz"
      sha256 "e893053a155f448d8b773df75f69fcc7b57bb0dde5fa6365faf728d7c11da6f9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aig787/agpm/releases/download/v0.4.5/agpm-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8078d27b3d4662da8f273468fddd52977ee073585d62f33915ad9737cec3ce53"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aig787/agpm/releases/download/v0.4.5/agpm-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "edf44e47b49502d225954efb1401bb084413040b57441d2b070a4a735032dfb1"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-pc-windows-gnu":    {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "agpm" if OS.mac? && Hardware::CPU.arm?
    bin.install "agpm" if OS.mac? && Hardware::CPU.intel?
    bin.install "agpm" if OS.linux? && Hardware::CPU.arm?
    bin.install "agpm" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

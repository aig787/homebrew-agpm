class AgpmCli < Formula
  desc "AGent Package Manager - A Git-based package manager for coding agents"
  homepage "https://github.com/aig787/agpm"
  version "0.4.14"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aig787/agpm/releases/download/v0.4.14/agpm-cli-aarch64-apple-darwin.tar.xz"
      sha256 "1c18cf6822d23a8166bf4b904518660d353033a886e3fd28afacf37db07d5b5c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aig787/agpm/releases/download/v0.4.14/agpm-cli-x86_64-apple-darwin.tar.xz"
      sha256 "a452ae6b3f2fc0e703977b50f7483d2a6a11d60e35b78de0734654dace93168e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aig787/agpm/releases/download/v0.4.14/agpm-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "11caf243a64b761b44c3eb22e7f0ea41e1f66b432a0ef3ab39a3101fb7fc171e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aig787/agpm/releases/download/v0.4.14/agpm-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7c580bff7a63c944fd1e7ca8f816fd97d20a2d1d05adf531597b4f36a15f0783"
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

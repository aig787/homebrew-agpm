class AgpmCli < Formula
  desc "AGent Package Manager - A Git-based package manager for coding agents"
  homepage "https://github.com/aig787/agpm"
  version "0.4.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aig787/agpm/releases/download/v0.4.7/agpm-cli-aarch64-apple-darwin.tar.xz"
      sha256 "7469dad92154e9b5dfbb6a0b83ad7dfe0ef9b1c43bbd9e63147e9be675a0ec6e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aig787/agpm/releases/download/v0.4.7/agpm-cli-x86_64-apple-darwin.tar.xz"
      sha256 "1d43b582124b1dfd750c6159c9e3b775b8f7162e92b0e88efffc69ed8a7234f0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aig787/agpm/releases/download/v0.4.7/agpm-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b3ef07bd39a35c7f38b25f63bbe19ef7594e4857c46bf1d0930e464bea5e1925"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aig787/agpm/releases/download/v0.4.7/agpm-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "62a508fce1298cb59e6c7f576942f4ffa11e76d1bf82bbf992629ad6a347cb01"
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

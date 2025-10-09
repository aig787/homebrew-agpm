class AgpmCli < Formula
  desc "AGent Package Manager - A Git-based package manager for Claude agents"
  homepage "https://github.com/aig787/agpm"
  version "0.4.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aig787/agpm/releases/download/v0.4.4/agpm-cli-aarch64-apple-darwin.tar.xz"
      sha256 "fb480dd7713794df2c4add2871e6da1d4b74ce09233abb21ad5d30453db7adb6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aig787/agpm/releases/download/v0.4.4/agpm-cli-x86_64-apple-darwin.tar.xz"
      sha256 "4d68523662bd9d9c02496ab5a64daa68195376c02e447a1b7c8b987e9b324f2b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aig787/agpm/releases/download/v0.4.4/agpm-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "162f5fb5e7b75fb84790f6f824cbb8a85650e16c057bd81a383b4ee20ead4069"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aig787/agpm/releases/download/v0.4.4/agpm-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a359b29c00986793fd8142f97aa9c3733447ee25755361949fdb433098cf2e11"
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

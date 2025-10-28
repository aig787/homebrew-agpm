class AgpmCli < Formula
  desc "AGent Package Manager - A Git-based package manager for coding agents"
  homepage "https://github.com/aig787/agpm"
  version "0.4.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aig787/agpm/releases/download/v0.4.9/agpm-cli-aarch64-apple-darwin.tar.xz"
      sha256 "a916ae9e5aff000d6f8b77a48db93ed4fd6a9673555f381c44702cbbd70a3322"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aig787/agpm/releases/download/v0.4.9/agpm-cli-x86_64-apple-darwin.tar.xz"
      sha256 "0014615b1e1c0a7c9f9245dbe3cb9cdafbe5654244ed0dbeba6d70805e78d01f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aig787/agpm/releases/download/v0.4.9/agpm-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d491218579fd644ecb70e4058ccabf4a859778114158c56d8213cca0f467a9a6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aig787/agpm/releases/download/v0.4.9/agpm-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bd38121be41705822f125031f7de7dc346fc50ea20697cf0643fee65cadd0c36"
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

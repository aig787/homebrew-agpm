class AgpmCli < Formula
  desc "AGent Package Manager - A Git-based package manager for coding agents"
  homepage "https://github.com/aig787/agpm"
  version "0.4.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aig787/agpm/releases/download/v0.4.10/agpm-cli-aarch64-apple-darwin.tar.xz"
      sha256 "09f81fb3159fdbe421bfd764013d4766c67eef69cb56240f858b3f3986f838de"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aig787/agpm/releases/download/v0.4.10/agpm-cli-x86_64-apple-darwin.tar.xz"
      sha256 "a0e999b7bf42f5cb8e06dd3f2be43b4bad0a4b42ea53bf341027c238c962432c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aig787/agpm/releases/download/v0.4.10/agpm-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "86680c465cd3375643aa43bde70c6e8d75aba3bcccfa9f0bc86735a4ce48cc4a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aig787/agpm/releases/download/v0.4.10/agpm-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7afebb1b0852095bd4b5c13711b01db6faf8148865db45a6ee7fcef72f8dac23"
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

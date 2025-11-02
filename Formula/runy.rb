class Runy < Formula
  desc "The runy application"
  homepage "https://github.com/s-panferov/runy"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/s-panferov/runy/releases/download/runy-0.4.0/runy-aarch64-apple-darwin.tar.xz"
      sha256 "6b1a856cbec3d0874956a4c6b20d5ec010a4ad4f5a4beb8aec9556ecfe14f460"
    end
    if Hardware::CPU.intel?
      url "https://github.com/s-panferov/runy/releases/download/runy-0.4.0/runy-x86_64-apple-darwin.tar.xz"
      sha256 "32d0d26ff75dfda64ee0ea0ca12dde896edde40d6bf7e7e897c3a2571195c99f"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/s-panferov/runy/releases/download/runy-0.4.0/runy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e85b8fb6f74f978e0bd105c1a60a0cdc1d75a85b317f7ee6ba1cf6634d5a062f"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin": {},
    "x86_64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static": {}
  }

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "runy"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "runy"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "runy"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

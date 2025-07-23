class Runy < Formula
  desc "The runy application"
  homepage "https://github.com/s-panferov/runy"
  version "0.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/s-panferov/runy/releases/download/v0.0.2/runy-aarch64-apple-darwin.tar.xz"
      sha256 "e86c67fb6408ff6f967a9011206ff8f8da880b2a6aa025ada9b3981939d62dd7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/s-panferov/runy/releases/download/v0.0.2/runy-x86_64-apple-darwin.tar.xz"
      sha256 "8248f9a8f97d18ba60cd33d824a5e86c81fb2ea6c4b091c5cd2886e0baf9b887"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/s-panferov/runy/releases/download/v0.0.2/runy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4e1885eb4614401572278807a8e23f04532d117c88b79adf5b6b6abfabe6d2ff"
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

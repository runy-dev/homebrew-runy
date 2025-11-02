class Runy < Formula
  desc "The runy application"
  homepage "https://github.com/s-panferov/runy"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/s-panferov/runy/releases/download/runy-0.5.0/runy-aarch64-apple-darwin.tar.xz"
      sha256 "bbb76c2db18f43bbdc54d41b05a3fc1f943cac3eb619aa956cb14a274e4012d0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/s-panferov/runy/releases/download/runy-0.5.0/runy-x86_64-apple-darwin.tar.xz"
      sha256 "0a1461cd3d60f4609fc299e10aa4bd1933804dfd83cc3438116051e5c611650c"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/s-panferov/runy/releases/download/runy-0.5.0/runy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "945eb581b117dbbc40a942a35605284843c3cb014925f818d62d03f73a8b627b"
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

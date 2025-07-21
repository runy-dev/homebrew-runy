class Runy < Formula
  desc "The runy application"
  homepage "https://github.com/s-panferov/runy"
  version "0.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/s-panferov/runy/releases/download/runy-0.0.1/runy-aarch64-apple-darwin.tar.xz"
      sha256 "0d6631089cf10efd9bf6adc1ac2c7cdf10a71ff39d97f74722c0397cbff95fa5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/s-panferov/runy/releases/download/runy-0.0.1/runy-x86_64-apple-darwin.tar.xz"
      sha256 "a6640f00163da417b4246bcfb4f2a5855ed6a416237a6fad5e657112c4deaea6"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/s-panferov/runy/releases/download/runy-0.0.1/runy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "acc639296fcabf6fe359d2d1b790e75a407b6e4ff989fbfdfd883816641010cd"
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

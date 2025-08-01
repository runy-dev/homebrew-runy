class Runy < Formula
  desc "The runy application"
  homepage "https://github.com/s-panferov/runy"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/s-panferov/runy/releases/download/runy-0.2.0/runy-aarch64-apple-darwin.tar.xz"
      sha256 "2ed642a1e0b4a49ba0e152ff3da8d52857b567ff959acd67ce4e57f113725423"
    end
    if Hardware::CPU.intel?
      url "https://github.com/s-panferov/runy/releases/download/runy-0.2.0/runy-x86_64-apple-darwin.tar.xz"
      sha256 "e662e830622c41eccffdd6dc832ec97d8dc67c707899796e418f618757b911a3"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/s-panferov/runy/releases/download/runy-0.2.0/runy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6805530fce72e1e351cb6ff4af1c72f2170b7a1436671cd7ea2b2a8721156912"
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

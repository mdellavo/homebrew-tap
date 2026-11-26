class MarkdownViewer < Formula
  desc "Render a Markdown file with GitHub styling and live-reload it in your browser"
  homepage "https://github.com/mdellavo/markdown-viewer"
  license "MIT"

  head do
    url "https://github.com/mdellavo/markdown-viewer.git", branch: "main"
    depends_on "rust" => :build
  end

  on_macos do
    on_arm do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.8.0/markdown-viewer-aarch64-apple-darwin.tar.gz"
      sha256 "b7240671b916974ecfd5e2e879599a331a60aec36e8a51511dbe632ab13a0a77"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.8.0/markdown-viewer-x86_64-apple-darwin.tar.gz"
      sha256 "8606658f22d265177ee7069b7ca4908e419650c697aa838d7f9a0fe93a585cc5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.8.0/markdown-viewer-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1785931a634df4ef52e276a98aecdae0583855ecf25e08557689b3ecbd2d440c"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.8.0/markdown-viewer-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "48f69d767c5664e1095df9c99b78214f3264ab75e883d21c4d9ae4a1a9de7b46"
    end
  end

  def install
    if build.head?
      system "cargo", "install", *std_cargo_args
    else
      bin.install "markdown-viewer"
    end
    bash_completion.install "completions/markdown-viewer.bash" => "markdown-viewer"
    zsh_completion.install "completions/_markdown-viewer"
    fish_completion.install "completions/markdown-viewer.fish"
    man1.install "man/markdown-viewer.1"
  end

  def caveats
    <<~EOS
      On macOS, to open Markdown files from Finder (Open With, double-click,
      and a right-click Quick Action), run:
        markdown-viewer --install-finder
      Before uninstalling, remove it with:
        markdown-viewer --uninstall-finder
    EOS
  end

  test do
    (testpath/"test.md").write "# Hello"
    assert_match "<h1", shell_output("#{bin}/markdown-viewer #{testpath}/test.md -o -")
  end
end

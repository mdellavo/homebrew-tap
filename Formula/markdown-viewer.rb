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
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.16.0/markdown-viewer-aarch64-apple-darwin.tar.gz"
      sha256 "f8a03229473aad0df2999fb0d8e7cffa2ab7fe561e2013669aa8e413ef07b4bd"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.16.0/markdown-viewer-x86_64-apple-darwin.tar.gz"
      sha256 "675b26fff75a0d642577ece08c8b25358beec305a71dd74729e5bd8463ca76b3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.16.0/markdown-viewer-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "54d0533a137d4dd58ffad6bb39b93a67d17f5a000e1d4a2f1b76baafc33ce28e"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.16.0/markdown-viewer-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "325d09ca225ddcbd2b5de6683b435eec41bf6b7dd4f61a4fcaad8cc494d72889"
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

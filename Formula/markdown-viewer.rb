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
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.11.0/markdown-viewer-aarch64-apple-darwin.tar.gz"
      sha256 "ec6d824580f561d498e4c72b569423c65bc2f3bcb32a11c3aa020b79051cc63f"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.11.0/markdown-viewer-x86_64-apple-darwin.tar.gz"
      sha256 "695dc785a268bf81414f9db813f2bbb9742edd6304d693e8f07104815467b4a9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.11.0/markdown-viewer-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b13587cace1eeb705c961ba0ac7a4d8e5d9c059566394f1110cba257fa0f30d7"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.11.0/markdown-viewer-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2278235818afd865104a07b091fbb3a7354b586d6fa5f95b3b614c009d400643"
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

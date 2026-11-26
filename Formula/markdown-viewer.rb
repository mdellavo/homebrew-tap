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
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.10.0/markdown-viewer-aarch64-apple-darwin.tar.gz"
      sha256 "aea22fc4ab50d77b6864300a24b06510e4f03174c90370615ce81db9fb812f67"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.10.0/markdown-viewer-x86_64-apple-darwin.tar.gz"
      sha256 "68ffb7a4041df472be8b91e405d8e2607a84794f5c1435ee63a31fcf9aae8e02"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.10.0/markdown-viewer-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5a0100ab3e99a152336ab38360b91a30c230d853f8bae02deaafc056cb407c5c"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.10.0/markdown-viewer-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a186e36b45cbead2f8744021a76d7136c89ac79e8a22c7d65f81562450ced3f4"
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

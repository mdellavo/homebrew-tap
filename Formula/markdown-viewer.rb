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
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.6.0/markdown-viewer-aarch64-apple-darwin.tar.gz"
      sha256 "32bde2d01c1ccc57f3c545edf92198b87e49a466e2aad59e1092e191ee13c35c"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.6.0/markdown-viewer-x86_64-apple-darwin.tar.gz"
      sha256 "76f91f402662af8f4ff3c98aaf73cdb272024ab28504d092b4149ee3c64f0b0f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.6.0/markdown-viewer-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b4b44f72e958956a0c04d5c573f2fa95937f5915ba3b11e98c83757b97b8dc73"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.6.0/markdown-viewer-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "81c116334f95b750f686cc1e2d522703487850e7729944eed961e5cc25f2630f"
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

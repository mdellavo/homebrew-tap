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
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.9.0/markdown-viewer-aarch64-apple-darwin.tar.gz"
      sha256 "747b11d6c3a3d365b10c109355730cb07701b78970d08404970aaba825b96863"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.9.0/markdown-viewer-x86_64-apple-darwin.tar.gz"
      sha256 "fef00855f2c83eb90b9be7eb6db72c46d8d9157ebda3263492abbeef36fc8d79"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.9.0/markdown-viewer-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "32eb87d4cdb61107a8fc360b36a133fbf9bc5245156e4c1fae46f58391cd07ee"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.9.0/markdown-viewer-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e3143aba7ed4f2f973db2e9520a5b03a2f2afaecaaeeedb2752d30dd50fa5a4f"
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

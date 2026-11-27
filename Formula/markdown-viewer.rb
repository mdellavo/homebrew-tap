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
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.14.0/markdown-viewer-aarch64-apple-darwin.tar.gz"
      sha256 "24bea515a623c0379e145ad4dbfbdb76373d673ea01d62be120c0674f544ce24"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.14.0/markdown-viewer-x86_64-apple-darwin.tar.gz"
      sha256 "448c69b1c7fc33a5f8fbdade7596bfaf9f1aa9b011a6d671080801b3434714a3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.14.0/markdown-viewer-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "558b0ea1c6efc75d3478714d14e8102e1a8f8b5ef65c5df84abbb66df444400d"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.14.0/markdown-viewer-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b6ec975c39f3e3fc4791bd226fdf221ba747ec72b5b560415a6645271da616c4"
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

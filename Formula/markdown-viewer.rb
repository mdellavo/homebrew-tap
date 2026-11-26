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
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.7.0/markdown-viewer-aarch64-apple-darwin.tar.gz"
      sha256 "b5702c99eaeb4440146f36ede99e1937510285200fc56f16506dbbe249d049e4"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.7.0/markdown-viewer-x86_64-apple-darwin.tar.gz"
      sha256 "7f4377c8a9be87756771e80a397976c8e4bc596993fc59032bdf569b04d37a25"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.7.0/markdown-viewer-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "71f53c7b1e2934fef66f3157c1c9af75cec5c4c69f8b4283d2dbb68109f43f3d"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.7.0/markdown-viewer-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b40fae27f589a30f1dac7cbf23c0557a437d04560f3bcd0973cfdd693447c8ea"
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

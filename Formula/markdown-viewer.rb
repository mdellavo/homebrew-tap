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
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.2.0/markdown-viewer-aarch64-apple-darwin.tar.gz"
      sha256 "111ae153d877867122f48403191b05707d552e94e94953daafe6b582cc4964eb"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.2.0/markdown-viewer-x86_64-apple-darwin.tar.gz"
      sha256 "ebf173df2301c3b0e001122a2ebd758db6802c4179e52412fb64d791b47495b4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.2.0/markdown-viewer-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9f88ecd2ba1708afb555ae611f6132d23c2df145983c8f6a61f891a338ad6be4"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.2.0/markdown-viewer-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8e0959662c53cc6b962e2c2140b4250a64dd10022f150cc8c95d61505d797e2c"
    end
  end

  def install
    if build.head?
      system "cargo", "install", *std_cargo_args
    else
      bin.install "markdown-viewer"
    end
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

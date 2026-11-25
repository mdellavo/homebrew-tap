class MarkdownViewer < Formula
  desc "Render a Markdown file with GitHub styling and live-reload it in your browser"
  homepage "https://github.com/mdellavo/markdown-viewer"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.1.0/markdown-viewer-aarch64-apple-darwin.tar.gz"
      sha256 "bab87588ff632f6700dd9262356065f398868d1f5ddfc816a96aa3a47247bad2"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.1.0/markdown-viewer-x86_64-apple-darwin.tar.gz"
      sha256 "915650e01591ea0e3907fd77efd0e14ef74790979c3893c6b6c5de0ee1a0f651"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.1.0/markdown-viewer-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "871e17fa068b588a0ebe2e16dcad8253e6b2457fad9d139f33d4dfbf5612a479"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.1.0/markdown-viewer-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c191d3bface6e41b893e930744ceb9d51f765305ef5fa3e6a9026f3e0504c899"
    end
  end

  head do
    url "https://github.com/mdellavo/markdown-viewer.git", branch: "main"
    depends_on "rust" => :build
  end

  def install
    if build.head?
      system "cargo", "install", *std_cargo_args
    else
      bin.install "markdown-viewer"
    end
  end

  test do
    (testpath/"test.md").write "# Hello"
    assert_match "<h1", shell_output("#{bin}/markdown-viewer #{testpath}/test.md -o -")
  end
end

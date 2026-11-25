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
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.3.0/markdown-viewer-aarch64-apple-darwin.tar.gz"
      sha256 "aaa9e55b58be92fdabfe689b1e39030e6789d15d97ac174990f06bdb35d6e76f"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.3.0/markdown-viewer-x86_64-apple-darwin.tar.gz"
      sha256 "c3b1a4ff5f413fdb1d2de27783b74c8d965804d9a1fd18e0480752721519324a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.3.0/markdown-viewer-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c104fd4eca9c972f040c15998d8eb3cadf1a4da82a6e3e98e5d22d5bba5a4ad5"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.3.0/markdown-viewer-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b14d5caadac98379008367cd6c89c80dfcea5c84804d8e9076b528c60dd486c7"
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

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
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.13.0/markdown-viewer-aarch64-apple-darwin.tar.gz"
      sha256 "0547e3b13ca12a9b47a110b0945718637b9e423df5580cc2c9b23308e21b8c52"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.13.0/markdown-viewer-x86_64-apple-darwin.tar.gz"
      sha256 "3ef7e473f08eb50cc64873920acd2285920954f9cb04b388b16f06053c12bcb9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.13.0/markdown-viewer-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "357cc269f3b35e003e56bccd52fde25e0ae8739d1ea0419cdb3bd747812a590a"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.13.0/markdown-viewer-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3d2a2e5764a4705c77ad758401b278593b6410e1a976a295b37d583f95c40b2a"
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

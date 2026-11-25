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
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.5.0/markdown-viewer-aarch64-apple-darwin.tar.gz"
      sha256 "862e74e861d244298c7f0c8f7ad6517552e8b6a23d74b6f363ff5a28bc9fb308"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.5.0/markdown-viewer-x86_64-apple-darwin.tar.gz"
      sha256 "c8f13960f36b38b6deb7d234a80c7502bd6272c59b30fa52932455a9a9e2c29f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.5.0/markdown-viewer-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "59ecf81b8ecac3a7e1dfa60ac060c19e65137714393c175b1643ac302106f727"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.5.0/markdown-viewer-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4589494a04fa87688e824deb0aa49b70bafe00e0f2786d62fa4aaa17b6e628fb"
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

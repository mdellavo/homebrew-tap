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
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.15.0/markdown-viewer-aarch64-apple-darwin.tar.gz"
      sha256 "dbdbdc5967f308d1cc5a5bd29d9a8b2c7710d11ece3180620a4b854743fd03e4"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.15.0/markdown-viewer-x86_64-apple-darwin.tar.gz"
      sha256 "b98629c834c72e065a109f20f956fb28539e9410327c8d0b00adba36a9d52b95"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.15.0/markdown-viewer-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1def3540a74094dbc44c9f00fe6047ac97ca4ba69896e3ad99100418aead7423"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.15.0/markdown-viewer-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "45e08cd727ca07d9ccce1e23424c066bf156a0a5feba9678cf31ca3dae098517"
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

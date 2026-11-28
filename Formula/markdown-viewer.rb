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
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.15.1/markdown-viewer-aarch64-apple-darwin.tar.gz"
      sha256 "daf7c84e59b45ccc6cbb3753e3883b5f95f5328829e244086a4ec665f1b26eb8"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.15.1/markdown-viewer-x86_64-apple-darwin.tar.gz"
      sha256 "1f15c73a30824e4a8dc77f14ef1e0f6fc1b85e94428b6da850d5c3f4c25306b9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.15.1/markdown-viewer-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6b5e5e5da64b681ca180a9a2fc17412c4fecf3fea5d57ef6dabf9d01a28e84d6"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.15.1/markdown-viewer-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d568e4acab3ca7700075f20e83500c534e3405c54b14f6e5c801d3df2547fdb2"
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

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
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.12.0/markdown-viewer-aarch64-apple-darwin.tar.gz"
      sha256 "4df1c3d18e88ca341ea03665c0e97789b88efd41270ea65a17d8d80a1fd5c92a"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.12.0/markdown-viewer-x86_64-apple-darwin.tar.gz"
      sha256 "da1b1daa6ffdde8b36d75851f366d2180bc2a51f6755c3ecd8faf46d69410b05"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.12.0/markdown-viewer-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9b838dbbce2da0521530d9a58e6dc248bd482c664ff0c18e2b7ca06340ceb7b8"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.12.0/markdown-viewer-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "dcd793e72f2d6d3cf74cc60e64d3423378f22880faca71edf89b3229c82ae192"
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

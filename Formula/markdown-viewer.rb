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
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.7.1/markdown-viewer-aarch64-apple-darwin.tar.gz"
      sha256 "0a0749b7646673950076c6b5e564914eb100e17ac5c861c7bd330e906163693c"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.7.1/markdown-viewer-x86_64-apple-darwin.tar.gz"
      sha256 "e41ff11563fca1cea68bde87e737ce239b58ac5260ad150d69aa5c1bedda05df"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.7.1/markdown-viewer-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5ca1c050544e7f3506c32077978ae116a61adc96eac83c5ed1db42579b2eee0a"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.7.1/markdown-viewer-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f889dafda4f5be28e606f8b406ba787e24f2909ab118cc6f9b3816b481b74cd0"
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

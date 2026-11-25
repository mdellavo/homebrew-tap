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
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.4.0/markdown-viewer-aarch64-apple-darwin.tar.gz"
      sha256 "e2688610f97e9560c64b07b8bd7edbfd65b56898e9fe6cbae6076e23874a70e1"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.4.0/markdown-viewer-x86_64-apple-darwin.tar.gz"
      sha256 "54111829309115ebd5b14865f0391e756e4c76a107e67340d8cfc254ffda1cd4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.4.0/markdown-viewer-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e910bae11c23682a8ea7198aed6446b390ae59ffe88e066c985380619c05729f"
    end
    on_intel do
      url "https://github.com/mdellavo/markdown-viewer/releases/download/v0.4.0/markdown-viewer-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "40310d560093c93cb0cb8be4c45dc3884a5d4aea335a335ce9f2043bd7415baf"
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

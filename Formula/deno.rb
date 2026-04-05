class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.com/"
  url "https://github.com/denoland/deno/releases/download/v2.7.11/deno_src.tar.gz"
  sha256 "932aef876d77146fef3fca5792d254c2000482b6a28a17d909f34e86bbc40d9a"
  license "MIT"
  compatibility_version 1
  head "https://github.com/denoland/deno.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe: "55ae65c7eaeecd5de16d7f538fd23b7ab8907393a151784cd3c14a5cd4227603"
    sha256 cellar: :any, arm64_sequoia: "f683906334fe37b01402ab728620fdf6c4e2a1031b1e7ab7ccf3eb54d2560f55"
    sha256 cellar: :any, arm64_sonoma: "0505b0aeb880cef4cf039c58f1f30c694c88c57a86bc618321e2bbae6cd2c718"
    sha256 cellar: :any, sonoma: "d1772645aaf3189fbdcdb930da6484c61328d8dbcd29713fff6483918e290147"
    sha256 cellar: :any_skip_relocation, arm64_linux: "88d4e20eb935049691ac3c9230cf0fb0a789ccf73e6cd58f5138879e98580f54"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "286e3dbcc35931b931d771b94e054e39cd5ae8ec19a4f6d250ed0465cbb89827"
  end

  depends_on "cmake" => :build
  depends_on "lld" => :build
  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "little-cms2"
  depends_on "sqlite"

  uses_from_macos "python" => :build
  uses_from_macos "libffi"

  on_linux do
    depends_on "glib" => :build
    depends_on "pcre2" => :build
    depends_on "zlib-ng-compat"
  end

  conflicts_with "dxpy", because: "both install `dx` binaries"

  def llvm
    Formula["llvm"]
  end

  def install
    inreplace "Cargo.toml" do |s|
      s.gsub!(/^lto = true$/, 'lto = "thin"')
      s.gsub!(/^libffi-sys = "(.+)"$/,
              'libffi-sys = { version = "\\1", features = ["system"] }')
      s.gsub!(/^rusqlite = { version = "(.+)", features = \["unlock_notify", "bundled", "session"/,
              'rusqlite = { version = "\\1", features = ["unlock_notify", "session"')
    end

    ENV["LCMS2_LIB_DIR"] = Formula["little-cms2"].opt_lib
    ENV["PYTHON"] = which("python3")
    ENV["NINJA"] = which("ninja")
    ENV["CLANG_BASE_PATH"] = llvm.prefix
    ENV["CC"] = llvm.opt_bin/"clang"
    ENV["CXX"] = llvm.opt_bin/"clang++"
    ENV["AR"] = llvm.opt_bin/"llvm-ar"
    ENV["RANLIB"] = llvm.opt_bin/"llvm-ranlib"
    ENV["LD"] = llvm.opt_bin/"ld.lld"
    ENV["LDFLAGS"] = "-L#{llvm.opt_lib} -Wl,-rpath,#{llvm.opt_lib}"
    ENV["CPPFLAGS"] = "-I#{llvm.opt_include}"
    ENV.prepend_path "PATH", llvm.opt_bin
    ENV["GN_ARGS"] = "clang_version=#{llvm.version.major} use_lld=true"

    system "cargo", "install", "--no-default-features", "-vv", *std_cargo_args(path: "cli")
    bin.install_symlink bin/"deno" => "dx"
    generate_completions_from_executable(bin/"deno", "completions")
  end

  test do
    require "utils/linkage"

    IO.popen("deno run -A -r https://fresh.deno.dev fresh-project", "r+") do |pipe|
      pipe.puts "n"
      pipe.puts "n"
      pipe.close_write
      pipe.read
    end

    assert_match "# Fresh project", (testpath/"fresh-project/README.md").read

    (testpath/"hello.ts").write <<~TYPESCRIPT
      console.log("hello", "deno");
    TYPESCRIPT
    assert_match "hello deno", shell_output("#{bin}/deno run hello.ts")
    assert_match "Welcome to Deno!",
      shell_output("#{bin}/deno run https://deno.land/std@0.100.0/examples/welcome.ts")
    assert_match "hello deno", shell_output("#{bin}/dx -y cowsay hello deno")

    linked_libraries = [
      Formula["sqlite"].opt_lib/shared_library("libsqlite3"),
    ]
    unless OS.mac?
      linked_libraries += [
        Formula["libffi"].opt_lib/shared_library("libffi"),
      ]
    end
    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"deno", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end

{
  pkgs
}:

let
  pkgs_rl = import ./default.nix {};
in
pkgs.stdenv.mkDerivation rec {
  pname = "zls";
  version = "5d53f01";
  src = pkgs.fetchFromGitHub {
    owner = "zigtools";
    repo = "zls";
    rev = "${version}";
    hash = "sha256-nn23p+oD0g9mDFcxzc7q8r7bJz8c0qQaaN5IlfFazfY=";
  };
  
  nativeBuildInputs = [ 
    (pkgs_rl.zig { version = "0.11.0-dev.3363+9461ed503"; })
 ];

  dontConfigure = true;

  passthru.tests.version = pkgs.testers.testVersion {
    package = pkgs_rl.zls;
    command = "zls --version";
    # The output needs to contain the 'version' string without any prefix or suffix.
    version = "0.11.0";
  };

  buildPhase = ''
    # TERM=dumb fixes broken progress output from the build
    TERM=dumb zig build -Doptimize=ReleaseSafe --global-cache-dir $TMPDIR --prefix $out
  '';
}

{
  pkgs
  , version
  , srcHash
  , zigVersion
}:

let
  pkgs_rl = import ./default.nix {};
in
pkgs.stdenv.mkDerivation rec {
  pname = "zls";
   inherit version;
  src = pkgs.fetchFromGitHub {
    owner = "zigtools";
    repo = "zls";
    rev = "${version}";
    hash = "${srcHash}";
  };
  
  nativeBuildInputs = [ 
    (pkgs_rl.zig { version = "${zigVersion}"; })
  ];

  dontConfigure = true;

  passthru.tests.version = pkgs.testers.testVersion {
    package = pkgs_rl.zls;
    command = "zls --version";
    # The output needs to contain the 'version' string without any prefix or suffix.
  #  version = "0.11.0";
  };

  buildPhase = ''
    # TERM=dumb fixes broken progress output from the build
    TERM=dumb zig build -Doptimize=ReleaseSafe --global-cache-dir $TMPDIR --prefix $out
  '';
}

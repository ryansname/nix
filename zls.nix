{
  pkgs
}:

let
  pkgs_rl = import ./default.nix {};
  zig_pkgs = pkgs.callPackage ./zls-deps.nix { };
in
pkgs.stdenv.mkDerivation rec {
  name = "zls";
  version = "master";
  pname = "zls";
  src = pkgs.fetchFromGitHub {
    owner = "zigtools";
    repo = "zls";
    rev = "532cc25";
    hash = "sha256-i33Ez/uYy6VzhByudLOUlNTMmqb+T+gu5m0nEyMr7wA=";
  };
  
  nativeBuildInputs = [ 
    pkgs_rl.zig
  ];

  postPatch = ''
    mkdir -p pkgs
    ln -s ${zig_pkgs} pkgs/p
  '';


  dontConfigure = true;

  passthru.tests.version = pkgs.testers.testVersion {
    package = pkgs_rl.zls;
    command = "zls --version";
    # The output needs to contain the 'version' string without any prefix or suffix.
  #  version = "0.11.0";
  };

  buildPhase = ''
    # TERM=dumb fixes broken progress output from the build
    TERM=dumb zig build -Doptimize=ReleaseSafe --global-cache-dir pkgs --prefix $out
  '';
}

{
  pkgs
  , stdenv ? pkgs.stdenv
}:

let
  version = "0.14.0-dev.2371+c013f45ad";
  os = if stdenv.isDarwin then "macos" else "linux";
  arch = if stdenv.isAarch64 then "aarch64" else "x86_64";
  platform = "${os}-${arch}";
in
pkgs.stdenv.mkDerivation rec {
  name = "zig";
  inherit version;
  pname = "zig";
  src = fetchTarball "https://ziglang.org/builds/zig-${platform}-${version}.tar.xz";

  nativeBuildInputs = if pkgs.stdenv.isDarwin then [] else [pkgs.autoPatchelfHook];

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;
  
  installPhase = ''
    install -Dm755 $src/zig $out/bin/zig
    cp -r $src/lib $out/
    cp -r $src/doc $out/
  '';

  meta = {
    homepage = "https://ziglang.org";
    architectures = [ "amd64" ];
  };
}

{
  pkgs
  , stdenv ? pkgs.stdenv
  , version
}:

let
  os = if stdenv.isDarwin then "macos" else "linux";
  arch = if stdenv.isAarch64 then "aarch64" else "x86_64";
  platform = "${os}-${arch}";
in
pkgs.stdenv.mkDerivation rec {
  pname = "zig";
  inherit version;
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

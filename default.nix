{
  pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/bc3ec5eaa759.tar.gz") {} 
}:

{
	zig = { version }: import ./zig.nix { inherit pkgs version; };
	zls = import ./zls.nix { inherit pkgs; };
}


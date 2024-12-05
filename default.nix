{
  pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/bc3ec5eaa759.tar.gz") {} 
}:

{
	zig = import ./zig.nix { inherit pkgs; };
	zls = import ./zls.nix { inherit pkgs; };
}


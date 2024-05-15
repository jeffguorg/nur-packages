{ pkgs ? (
    let
      inherit (builtins) fetchTree fromJSON readFile;
      inherit ((fromJSON (readFile ../../flake.lock)).nodes) nixpkgs gomod2nix;
    in
    import (fetchTree nixpkgs.locked) {
      overlays = [
        (import "${fetchTree gomod2nix.locked}/overlay.nix")
      ];
    }
  )
, buildGoApplication ? pkgs.buildGoApplication
, sources ? pkgs.callPackage ../../_sources/generated.nix {}
, ...
}:
let
  src = sources.kwok;
in
buildGoApplication {
  inherit (src) pname version;

  goPackagePath = "sigs.k8s.io/kwok";

  subPackages = [
    "cmd/kwok"
    "cmd/kwokctl"
  ];

  modules = ./gomod2nix.toml;

  src = src.src;
}

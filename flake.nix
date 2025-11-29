{
  description = "Static ARMv7 fbterm";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.default = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      # Target: ARMv7 Hard Float, Static Musl
      targetPkgs = pkgs.pkgsCross.armv7l-hf-multiplatform.pkgsStatic;
    in targetPkgs.fbterm;
  };
}

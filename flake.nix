{
  description = "ESP flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = all@{ self, nixpkgs, ... }: {
    devShell.x86_64-linux =
      let
        pkgs = import nixpkgs { system = "x86_64-linux"; };
      in
        pkgs.mkShell {
          buildInputs = [
            pkgs.esphome
          ];
        };
  };
}

{
  description = "ESP flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = all@{ self, nixpkgs, ... }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in
      {
        packages.x86_64-linux = {
          inherit (pkgs) esphome esptool;
        };

        devShell.x86_64-linux =
          pkgs.mkShell {
            buildInputs = [
              pkgs.esphome
              pkgs.esptool

              # Needed at least for seeedd1001
              pkgs.cmake
              pkgs.ninja
              pkgs.libusb1
            ];
          };
      };
}

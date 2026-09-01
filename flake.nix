{
  description = "ESP flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };

      fhs = pkgs.buildFHSEnv {
        name = "esphome-fhs";

        targetPkgs = pkgs: with pkgs; [
          esphome
          esptool

          # Needed at least for seeedd1001
          cmake
          ninja
          libusb1
        ];

        runScript = "bash";
      };
    in
      {
        devShell.x86_64-linux =
          pkgs.mkShell {
            packages = [
              fhs
            ];

            shellHook = ''
              echo "Run: esphome-fhs"
            '';
          };
      };
}

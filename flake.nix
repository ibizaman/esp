{
  description = "ESP flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };

      fhs = pkgs.buildFHSEnv {
        name = "esphome-fhs";

        targetPkgs =
          pkgs: with pkgs; [
            (esphome.overrideAttrs (finalAttrs: {
              version = "2026.8.2";
              src = fetchFromGitHub {
                owner = "esphome";
                repo = "esphome";
                tag = "2026.8.2";
                hash = "sha256-tWUD3aYiDBgCBPieCkL6RyRQ1sh6DniOcGbS4zLcTBI=";
              };
            }))
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
      devShell.x86_64-linux = pkgs.mkShell {
        packages = [
          fhs
        ];

        shellHook = ''
          echo "Run: esphome-fhs"
        '';
      };
    };
}

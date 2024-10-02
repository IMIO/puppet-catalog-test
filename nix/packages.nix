{ inputs, ... }: {
  imports = [
    inputs.cachix-push.flakeModule
  ];
  perSystem =
    { pkgs, ... }: {
      packages = {
        inherit (pkgs) hello;
      };

      cachix-push = {
        cacheName = "imio";
      };
    };

  flake.overlays.default = _final: _prev: { };
}

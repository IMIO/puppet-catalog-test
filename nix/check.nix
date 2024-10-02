{ inputs, ... }: {
  imports = [
    inputs.pre-commit-nix.flakeModule
  ];

  perSystem = { ... }: {
    pre-commit = {
      settings = {
        hooks = {
          nil.enable = true;
          deadnix.enable = true;
          statix.enable = true;
          hadolint.enable = true;
          shellcheck.enable = true;
          shfmt.enable = true;
          markdownlint.enable = false;
          treefmt.enable = true;
        };
      };
    };
  };
}

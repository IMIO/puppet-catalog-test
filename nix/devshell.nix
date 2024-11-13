{ inputs, lib, ... }: {
  imports = [
    inputs.devshell.flakeModule
  ];
  perSystem = { config, pkgs, ... }:
    {
      devshells.default =
        {
          packages =
            [
              pkgs.git
              pkgs.jq
              pkgs.vault
              pkgs.bundix
              (lib.hiPrio pkgs.puppet-catalog-test-env)
              pkgs.puppet-catalog-test-env.wrappedRuby
              pkgs.ruby-lsp
            ];
          devshell.startup.pre-commit.text = config.pre-commit.installationScript;
          commands = [
            {
              name = "fmt";
              help = "Format code";
              command = "nix fmt";
              category = "check";
            }
            {
              name = "check";
              help = "Run all checks";
              command = "nix flake -L check -v";
              category = "check";
            }
            {
              name = "lint";
              help = "Lint code";
              command = "pre-commit run --all-files";
              category = "check";
            }
          ];
          env = [
            {
              name = "VAULT_ADDR";
              value = "https://vault.imio.be";
            }
            {
              name = "SSL_CERT_FILE";
              value =
                "${pkgs.imioCACert}/etc/ssl/certs/ca-bundle.crt";
            }
          ];
        };
    };
}

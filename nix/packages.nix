{ self, inputs, ... }: {
  imports = [
    inputs.cachix-push.flakeModule
  ];
  perSystem =
    { pkgs, ... }: {
      packages = rec {
        puppet-catalog-test-env = pkgs.bundlerEnv {
            name = "puppet-catalog-test-env";
            ruby = pkgs.ruby_3_2;
            gemfile = ../Gemfile;
            lockfile = ../Gemfile.lock;
            gemset = ../gemset.nix;
          };
        puppet-catalog-test = pkgs.buildRubyGem {
            pname = "puppet-catalog-test";
            version = "0.4.5";
            ruby = pkgs.ruby_3_2;
            gemName = "puppet-catalog-test";
            source.sha256 = "sha256-wD0Aw1otrc1WnMi9ThoIgNCuDZHCeeJhKDLCP91kiJY=";
            propagatedBuildInputs = [ puppet-catalog-test-env ];
          };
        default = pkgs.puppet-catalog-test;
      };

      cachix-push = {
        cacheName = "imio";
      };
    };

  flake.overlays.default = final: _prev: {
    inherit (self.packages.${final.system}) puppet-catalog-test puppet-catalog-test-env;
  };
}

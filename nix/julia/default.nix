{ inputs, ... }:
{
  perSystem =
    {
      self',
      pkgs,
      lib,
      system,
      ...
    }:
    let
      inherit (inputs.jupyenv.lib.${system}) mkJupyterlabNew;
    in
    {

      packages.julia-jupyter = mkJupyterlabNew (_: {
        inherit (inputs) nixpkgs;
        kernel.julia.HEG-GTA = {
          enable = true;
          ijuliaRev = "bHdNn";
        };
      });
      devShells.julia-jupyter = inputs.flake-lib.mkShell {
        inherit pkgs;
        name = "julia-jupyter";
        packages = [ self'.packages.julia-jupyter ];
        shellHook = ''
          ${self'.packages.julia-jupyter}/bin/julia -e "using Pkg; Pkg.add(\"IJulia\")"
          ls ~/.julia/packages/IJulia
          ${lib.getExe self'.packages.julia-jupyter}
        '';
      };

    };
}

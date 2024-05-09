{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
  let 
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in {
    devShells.x86_64-linux.default = pkgs.mkShell {
      name = "d7018e-labs";
      packages = with pkgs; [
        haskellPackages.haskell-language-server
        haskellPackages.hlint
      ];
      buildInputs = with pkgs; [
        (haskellPackages.ghcWithPackages (pkgs: with pkgs; [ 
          QuickCheck
          ghcid
        ]))
      ];
    };
  };
}

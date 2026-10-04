{
  description = "Configuración NixOS de ibarona — labwc + Noctalia";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      user = "ibarona";
      hostname = "nixos";
    in
    {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # Si algún dotfile ya existe fuera de Nix, HM hace backup en vez de fallar
            home-manager.backupFileExtension = "hm-bak";
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.${user} = import ./home.nix;
          }
        ];
      };
    };
}

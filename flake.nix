{
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  inputs.disko.url = github:nix-community/disko;
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, disko, ... }@attrs: {
    nixosConfigurations.linode = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        ({modulesPath, ... }: {
          imports = [
            (modulesPath + "/installer/scan/not-detected.nix")
            (modulesPath + "/profiles/qemu-guest.nix")
            disko.nixosModules.disko
          ];
          disko.devices = import ./disk-config.nix {
            lib = nixpkgs.lib;
          };
          boot.loader.grub = {
            enable = true;
            version = 2;
            forceInstall = true;
            device = "nodev";
            extraConfig = ''
              serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
              terminal_input serial;
              terminal_output serial
            '';
            # devices = [ "/dev/sda" ];
            # efiSupport = true;
            # efiInstallAsRemovable = true;
          };
          services.openssh.enable = true;

          users.users.root.openssh.authorizedKeys.keys = [
            # change this to your ssh key
            (builtins.readFile ./key.pub)
          ];
        })
      ];
    };
    nixosConfigurations.hetzner-cloud = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        ({modulesPath, ... }: {
          imports = [
            (modulesPath + "/installer/scan/not-detected.nix")
            (modulesPath + "/profiles/qemu-guest.nix")
            disko.nixosModules.disko
          ];
          disko.devices = import ./disk-config.nix {
            lib = nixpkgs.lib;
          };
          boot.loader.grub = {
            devices = [ "/dev/sda" ];
            efiSupport = true;
            efiInstallAsRemovable = true;
          };
          services.openssh.enable = true;

          users.users.root.openssh.authorizedKeys.keys = [
            # change this to your ssh key
            "CHANGE"
          ];
        })
      ];
    };
  };
}

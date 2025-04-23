{
  # specialArgs
  inputs,
  username,
  ...
} @ args:

{
  imports = [
    inputs.home-manager.nixosModules.default
  ];

  # Home Manager options
  home-manager = {
    # Pass args to home-manager modules
    extraSpecialArgs = args;

    users = {

    };
  };
}
{
  description = "Static ARMv7 fbterm (Fixed)";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.default = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      crossPkgs = pkgs.pkgsCross.armv7l-hf-multiplatform.pkgsStatic;
    in crossPkgs.fbterm.overrideAttrs (old: {
      postPatch = (old.postPatch or "") + ''
        # --- Previous Fixes ---
        sed -i 's/sigset_t sigmask;/sigset_t sigmask, oldSigmask;/' src/fbterm.cpp
        sed -i 's/WAIT_ANY/-1/g' src/fbterm.cpp
        echo "#include <sys/signalfd.h>" > src/signalfd.h
        sed -i '1i #include <cstring>' src/mouse.cpp

        # --- New Fixes ---
        # Fix missing timeval, fd_set, select in improxy.cpp
        sed -i '1i #include <sys/select.h>\n#include <sys/time.h>' src/improxy.cpp
      '';
    });
  };
}

# command: ./bin/fbterm -r 3 -n "ProFontExtended" -s 15 --font-width 11 -a -- htop < /dev/tty1 > /dev/tty1 2>&1

{ pkgs ? import <nixpkgs> {} }:
let
  libPath = with pkgs;
    lib.makeLibraryPath [
      stdenv.cc.cc.lib
    ];
in
  pkgs.mkShell rec {
    nativeBuildInputs = with pkgs; [
      pkg-config
    ];

    buildInputs = with pkgs; [
      (pkgs.python311.withPackages (python-pkgs:
        with python-pkgs; [
          pip
        ]))
    ];

    shellHook = ''
      export LD_LIBRARY_PATH=${libPath}
      [[ -d .venv ]] || python -m venv .venv
      source .venv/bin/activate
    '';
  }

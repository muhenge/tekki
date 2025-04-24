{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.ruby_3_4
    pkgs.postgresql
    pkgs.postgresql.dev
    pkgs.mariadb_114
    pkgs.gcc
    pkgs.gnumake
    pkgs.pkg-config
    pkgs.libffi
    pkgs.zlib
    pkgs.openssl
    pkgs.zstd
    pkgs.libyaml
    pkgs.curl
  ];

  shellHook = ''
    export LD_LIBRARY_PATH=${pkgs.curl.out}/lib:$LD_LIBRARY_PATH
    echo "💎 Dependencies installed successfully, libcurl is in LD_LIBRARY_PATH ✅"
  '';
}

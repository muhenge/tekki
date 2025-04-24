{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.ruby_3_4
    pkgs.postgresql
    pkgs.postgresql.dev
    pkgs.mariadb_114
    # pkgs.mariadb_114.dev
    pkgs.gcc
    pkgs.gnumake
    pkgs.pkg-config
    pkgs.libffi
    pkgs.zlib
    pkgs.openssl
    pkgs.zstd
    pkgs.libyaml
    pkgs.pkg-config
  ];

  shellHook = ''
    echo "💎 Ready to install pg and mysql2 gems!"
  '';
}

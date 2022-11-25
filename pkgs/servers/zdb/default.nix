{ stdenv, fetchFromGitHub, lib }:

stdenv.mkDerivation rec {
  pname = "zdb";
  version = "development-v2";

  src = fetchFromGitHub {
    owner = "threefoldtech";
    repo = "0-db";
    rev = version;
    sha256 = "k2EpmdA6Ps/AE37Fkg516PRrKlnJUAwPYkz2TYn+M9U=";
  };

  doCheck = true;

  buildPhase = ''
    make release
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp zdbd/zdb $out/bin
  '';

  meta = with lib; {
    description = "Fast write ahead persistent redis protocol key-value store";
    longDescription = ''
        0-db (zdb) is a super fast and efficient key-value store which makes data persistant inside an always append datafile, with namespaces support and data offloading.
    '';
    homepage = "https://github.com/threefoldtech/0-db";
    changelog = "https://github.com/threefoldtech/0-db";
    maintainer = maintainers.maxux;
    license = licenses.asl20;
    platforms = platforms.all;
  };
}

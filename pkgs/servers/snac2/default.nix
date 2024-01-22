{ stdenv
, lib
, fetchFromGitea
, curl
, openssl
, nix-update-script
, testers
, snac2
}:

stdenv.mkDerivation rec {
  pname = "snac2";
  version = "2.45";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "grunfink";
    repo = pname;
    rev = version;
    hash = "sha256-zSmzG/Ws7/6rXBNqAtKqnWcsPA9jy/TidXlklwGhArc=";
  };

  buildInputs = [ curl openssl ];

  makeFlags = [ "PREFIX=$(out)" ];

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.isDarwin [
    "-Dst_mtim=st_mtimespec"
    "-Dst_ctim=st_ctimespec"
  ]);

  passthru = {
    tests.version = testers.testVersion {
      package = snac2;
      command = "${meta.mainProgram} || true";
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    homepage = "https://codeberg.org/grunfink/snac2";
    description = "A simple, minimalistic ActivityPub instance (2.x, C)";
    changelog = "https://codeberg.org/grunfink/snac2/src/tag/${version}/RELEASE_NOTES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ misuzu ];
    platforms = platforms.unix;
    mainProgram = "snac";
  };
}

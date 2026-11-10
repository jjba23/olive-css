# olive-css
#
# SPDX-License-Identifier: MIT
# Copyright © Josep Bigorra <jjbigorra@gmail.com>

# The package of this checkout as it stands.  It is the same derivation as the
# `guile-olive-css' package in nixpkgs -- same phases, same layout under $out --
# so that a change which breaks this build breaks that one for the same reason.
# What differs is the source: this file builds the working tree, while nixpkgs
# pins a released tag and its hash.  `maak release' writes `version', so keep
# releasing through it rather than editing the string by hand.

{ lib
, stdenv
, guile
}:

stdenv.mkDerivation {
  pname = "guile-olive-css";
  version = "1.1.3";

  src = ./.;

  nativeBuildInputs = [ guile ];

  buildInputs = [ guile ];

  buildPhase = ''
    runHook preBuild

    siteDir=$out/${guile.siteDir}
    install -d "$siteDir"
    cp -R src/. "$siteDir"/

    export GUILE_AUTO_COMPILE=0
    export GUILE_LOAD_PATH="$siteDir''${GUILE_LOAD_PATH:+:$GUILE_LOAD_PATH}"

    find src -name '*.scm' | while IFS= read -r file; do
      rel="''${file#src/}"
      guild compile -o "$siteDir/''${rel%.scm}.go" "$file"
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 bin/olive-css "$out/bin/olive-css"
    install -Dm644 LICENSE "$out/share/doc/guile-olive-css/LICENSE"
    for doc in README.org CHANGELOG.org docs/*.org; do
      install -Dm644 "$doc" "$out/share/doc/guile-olive-css/$(basename "$doc")"
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Utility-class CSS framework written in Guile Scheme";
    homepage = "https://github.com/jjba23/olive-css";
    license = licenses.mit;
    mainProgram = "olive-css";
    platforms = guile.meta.platforms;
  };
}

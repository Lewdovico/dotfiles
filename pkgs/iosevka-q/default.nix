{
  stdenv,
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  darwin,
  remarshal,
  ttfautohint-nox,
  privateBuildPlan ? ''
    [buildPlans.iosevka-q]
    family = "Iosevka q"
    spacing = "term"
    serifs = "sans"
    noCvSs = true
    exportGlyphNames = false

      [buildPlans.iosevka-q.variants]
      inherits = "ss14"

        [buildPlans.iosevka-q.variants.design]
        brace = "curly-flat-boundary"

      [buildPlans.iosevka-q.ligations]
      inherits = "dlig"
  '',
  extraParameters ? null,
  set ? "q",
}:
assert (privateBuildPlan != null) -> set != null;
assert (extraParameters != null) -> set != null;
  buildNpmPackage rec {
    pname =
      if set != null
      then "iosevka-${set}"
      else "iosevka";
    version = "28.0.0-alpha.2";

    src = fetchFromGitHub {
      owner = "be5invis";
      repo = "iosevka";
      rev = "v${version}";
      hash = "sha256-8XTFMQocdyHAsdN7nAAusTMIM+hNd+hqjCUgnFL+k9E=";
    };

    npmDepsHash = "sha256-PTKGmlzofjlXrUjuInFUF8bJ02f1odarL4ivE0wX97I=";

    nativeBuildInputs =
      [
        remarshal
        ttfautohint-nox
      ]
      ++ lib.optionals stdenv.isDarwin [
        # libtool
        darwin.cctools
      ];

    buildPlan =
      if builtins.isAttrs privateBuildPlan
      then builtins.toJSON {buildPlans.${pname} = privateBuildPlan;}
      else privateBuildPlan;

    inherit extraParameters;
    passAsFile =
      ["extraParameters"]
      ++ lib.optionals
      (!(builtins.isString privateBuildPlan
        && lib.hasPrefix builtins.storeDir privateBuildPlan)) ["buildPlan"];

    configurePhase = ''
      runHook preConfigure
      ${lib.optionalString (builtins.isAttrs privateBuildPlan) ''
        remarshal -i "$buildPlanPath" -o private-build-plans.toml -if json -of toml
      ''}
      ${lib.optionalString (builtins.isString privateBuildPlan
        && (!lib.hasPrefix builtins.storeDir privateBuildPlan)) ''
        cp "$buildPlanPath" private-build-plans.toml
      ''}
      ${lib.optionalString (builtins.isString privateBuildPlan
        && (lib.hasPrefix builtins.storeDir privateBuildPlan)) ''
        cp "$buildPlan" private-build-plans.toml
      ''}
      ${lib.optionalString (extraParameters != null) ''
        echo -e "\n" >> params/parameters.toml
        cat "$extraParametersPath" >> params/parameters.toml
      ''}
      runHook postConfigure
    '';

    buildPhase = ''
      export HOME=$TMPDIR
      runHook preBuild
      npm run build --no-update-notifier -- --jCmd=$NIX_BUILD_CORES --verbose=9 ttf::$pname
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      fontdir="$out/share/fonts/truetype"
      install -d "$fontdir"
      install "dist/$pname/TTF"/* "$fontdir"
      runHook postInstall
    '';

    enableParallelBuilding = true;

    meta = with lib; {
      homepage = "https://typeof.net/Iosevka/";
      downloadPage = "https://github.com/be5invis/Iosevka/releases";
      description = "Versatile typeface for code, from code.";
      longDescription = ''
        Iosevka is an open-source, sans-serif + slab-serif, monospace +
        quasi‑proportional typeface family, designed for writing code, using in
        terminals, and preparing technical documents.
      '';
      license = licenses.ofl;
      platforms = platforms.all;
      maintainers = with maintainers; [ludovicopiero];
    };
  }

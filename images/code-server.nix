{
  # build tools
  dockerTools,
  buildEnv,
  # runtime dependencies
  fnm, # https://github.com/Schniz/fnm
  fontconfig, # provides libfontconfig
  ...
}: let
  name = "code-server";
  tag = "4.22.1";
  digest = "sha256:1c005305028b5fadb9e17fefe161144df1df9e31f6f76eb86934825c2fa9f3e0";

  baseImage = dockerTools.pullImage {
    imageName = "linuxserver/code-server";
    imageDigest = digest;
    finalImageName = name;
    finalImageTag = tag;
    sha256 = "sha256-KoduBsxv7032Q3rCq1T2KocH+kZHW0eQVXlUzcuuN/w=";
  };
in
  dockerTools.buildImage {
    inherit name tag;

    # compress properly
    compressor = "zstd";

    # lets pull the previous code-server image
    # we'll modify it to our needs e.g. by
    # adding packages that we need to the PATH
    fromImage = baseImage;

    # build a FHS environment containing our packages
    # and copy it to the image root
    copyToRoot = buildEnv {
      name = "image-root";
      paths = [
        fnm
        fontconfig.lib
      ];

      # make package executables available to us
      pathsToLink = ["/bin"];
    };
  }

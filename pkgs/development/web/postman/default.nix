{ stdenv, fetchurl, makeDesktopItem, wrapGAppsHook
, atk, at-spi2-atk, alsaLib, cairo, cups, dbus, expat, gdk-pixbuf, glib, gtk3
, freetype, fontconfig, nss, nspr, pango, udev, libX11, libxcb, libXi
, libXcursor, libXdamage, libXrandr, libXcomposite, libXext, libXfixes
, libXrender, libXtst, libXScrnSaver
}:

stdenv.mkDerivation rec {
  pname = "postman";
  version = "7.12.0";

  src = fetchurl {
    url = "https://dl.pstmn.io/download/version/${version}/linux64";
    sha256 = "0sz7cidajrsj43vq5g8jrkxlrp97r7n8dfr9gp8l0wxnidiqm401";
    name = "${pname}.tar.gz";
  };

  dontBuild = true; # nothing to build
  dontConfigure = true;

  desktopItem = makeDesktopItem {
    name = "postman";
    exec = "postman";
    icon = "postman";
    comment = "API Development Environment";
    desktopName = "Postman";
    genericName = "Postman";
    categories = "Application;Development;";
  };

  buildInputs = [
    stdenv.cc.cc.lib
    atk
    at-spi2-atk
    alsaLib
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    freetype
    fontconfig
    nss
    nspr
    pango
    udev
    libX11
    libxcb
    libXi
    libXcursor
    libXdamage
    libXrandr
    libXcomposite
    libXext
    libXfixes
    libXrender
    libXtst
    libXScrnSaver
  ];

  nativeBuildInputs = [ wrapGAppsHook ];


  installPhase = ''
    mkdir -p $out/share/postman
    cp -R app/* $out/share/postman
    rm $out/share/postman/Postman

    mkdir -p $out/bin
    ln -s $out/share/postman/_Postman $out/bin/postman

    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/

    iconRootDir=$out/share/icons
    iconSizeDir=$out/share/icons/hicolor/128x128/apps
    mkdir -p $iconSizeDir
    ln -s $out/share/postman/resources/app/assets/icon.png $iconRootDir/postman.png
    ln -s $out/share/postman/resources/app/assets/icon.png $iconSizeDir/postman.png
  '';

  postFixup = ''
    pushd $out/share/postman
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" _Postman
    for file in $(find . -type f \( -name \*.node -o -name _Postman -o -name \*.so\* \) ); do
      ORIGIN=$(patchelf --print-rpath $file); \
      patchelf --set-rpath "${stdenv.lib.makeLibraryPath buildInputs}:$ORIGIN" $file
    done
    popd
  '';

  meta = with stdenv.lib; {
    homepage = https://www.getpostman.com;
    description = "API Development Environment";
    license = licenses.postman;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ xurei evanjs ];
  };
}

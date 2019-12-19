{ lib, buildPythonPackage, fetchPypi, future, lxml }:

buildPythonPackage rec {
  pname = "pymavlink";
  version = "2.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "80ee6481cf9cb566d7546786fd4401fdb575462645a5349efa7737cacdb0b86f";
  };

  propagatedBuildInputs = [ future lxml ];

  # No tests included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "Python MAVLink interface and utilities";
    homepage = "https://github.com/ArduPilot/pymavlink";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ lopsided98 ];
  };
}

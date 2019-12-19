{ lib
, buildPythonPackage
, fetchPypi
, mock
}:

buildPythonPackage rec {
  pname = "coverage";
  version = "5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e1bad043c12fb58e8c7d92b3d7f2f49977dcb80a08a6d1e7a5114a11bf819fca";
  };

  # No tests in archive
  doCheck = false;
  checkInputs = [ mock ];

  meta = {
    description = "Code coverage measurement for python";
    homepage = http://nedbatchelder.com/code/coverage/;
    license = lib.licenses.bsd3;
  };
}
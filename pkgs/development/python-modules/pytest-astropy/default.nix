{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pytest-doctestplus
, pytest-remotedata
, pytest-openfiles
, pytest-arraydiff
}:

buildPythonPackage rec {
  pname = "pytest-astropy";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0e383262b2f9c2ef456cdd612cb0c485430a6a2530e3d5662e8930702e0bdd44";
  };

  propagatedBuildInputs = [
    pytest
    pytest-doctestplus
    pytest-remotedata
    pytest-openfiles
    pytest-arraydiff
  ];

  # pytest-astropy is a meta package and has no tests
  doCheck = false;

  meta = with lib; {
    description = "Meta-package containing dependencies for testing";
    homepage = https://astropy.org;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}

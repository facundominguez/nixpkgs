{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, docutils
, requests
, requests_download
, zipfile36
, pythonOlder
, pytest_4
, testpath
, responses
, pytoml
}:

# Flit is actually an application to build universal wheels.
# It requires Python 3 and should eventually be moved outside of
# python-packages.nix. When it will be used to build wheels,
# care should be taken that there is no mingling of PYTHONPATH.

buildPythonPackage rec {
  pname = "flit";
  version = "2.1.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "6c954c3ec4e87a84fac55cca1a1d692a39354affa7c791eb49f6631b71ddbb40";
  };

  propagatedBuildInputs = [ docutils requests requests_download pytoml ]
    ++ lib.optional (pythonOlder "3.6") zipfile36;

  checkInputs = [ pytest_4 testpath responses ];

  # Disable test that needs some ini file.
  # Disable test that wants hg
  checkPhase = ''
    HOME=$(mktemp -d) pytest -k "not test_invalid_classifier and not test_build_sdist"
  '';

  meta = with lib; {
    description = "A simple packaging tool for simple packages";
    homepage = https://github.com/takluyver/flit;
    license = licenses.bsd3;
    maintainers = [ maintainers.fridh ];
  };
}

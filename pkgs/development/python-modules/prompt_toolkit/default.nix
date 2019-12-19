{ lib
, buildPythonPackage
, fetchPypi
, pytest
, six
, wcwidth
}:

buildPythonPackage rec {
  pname = "prompt_toolkit";
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "63daee79aa8366c8f1c637f1a4876b890da5fc92a19ebd2f7080ebacb901e990";
  };
  checkPhase = ''
    py.test -k 'not test_pathcompleter_can_expanduser'
  '';

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ six wcwidth ];

  meta = {
    description = "Python library for building powerful interactive command lines";
    longDescription = ''
      prompt_toolkit could be a replacement for readline, but it can be
      much more than that. It is cross-platform, everything that you build
      with it should run fine on both Unix and Windows systems. Also ships
      with a nice interactive Python shell (called ptpython) built on top.
    '';
    homepage = https://github.com/jonathanslenders/python-prompt-toolkit;
    license = lib.licenses.bsd3;
  };
}

{ buildPythonPackage
, fetchPypi
, dateutil
, jmespath
, docutils
, ordereddict
, simplejson
, mock
, nose
, urllib3
}:

buildPythonPackage rec {
  pname = "botocore";
  version = "1.13.43"; # N.B: if you change this, change boto3 and awscli to a matching version

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lpb3wc2psmnhdacbmwg74g190qdrj0y72r12jjk0rwp8j711hjs";
  };

  outputs = [ "out" "dev" ];

  # they need to figure out how to update setuptools
  postPatch = ''
    sed -i 's/python-dateutil>=2.1,<2.8.1/python-dateutil~=2.1/g' setup.py
  '';

  propagatedBuildInputs = [
    dateutil
    jmespath
    docutils
    ordereddict
    simplejson
    urllib3
  ];

  checkInputs = [ mock nose ];

  checkPhase = ''
    nosetests -v
  '';

  # Network access
  doCheck = false;

  meta = {
    homepage = https://github.com/boto/botocore;
    license = "bsd";
    description = "A low-level interface to a growing number of Amazon Web Services";
  };
}

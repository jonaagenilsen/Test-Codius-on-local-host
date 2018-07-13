#
# Required packages:
#
# yum install bind-utils -y -q
#

usage () {
  echo -e "Usage: test-codius-upload.sh \e[93m<hostname>\e[0m"
  echo -e "- Example #1: \e[0;32mtest-codius-upload.sh\e[0m \e[93mlocal\e[0m          (test your local server)"
  echo -e "- Example #2: \e[0;32mtest-codius-upload.sh\e[0m \e[93mhodling-xrp.no\e[0m (test remote hostname)"
  exit
}

HOST=$1

if [ "$HOST" != '' ]; then
  if [ "$HOST" != 'local' ]; then
    host $HOST
    if [ "$?" -eq "0" ]; then
      echo "$HOST resolves with DNS. Continuing script."
      echo
    else
      usage
    fi
  fi
else
  usage
fi

cd
npm install -g codius

POD="/root/scripts/upload-test"
mkdir -p $POD

cat << EOF > $POD/codius.json
{
  "manifest": {
    "name": "my-codius-create-react-app",
    "version": "1.0.0",
    "machine": "small",
    "port": "3000",
    "containers": [{
      "id": "app",
      "image": "androswong418/example-pod-1@sha256:8933bced1637e7d3b08c4aa50b96a45aef0b63f504f595bb890f57253af68b11"
    }]
  }
}
EOF
cat << EOF > $POD/codiusvars.json
{
  "vars": {
    "public": {},
    "private": {}
  }
}
EOF

cd $POD
if [ "$HOST" == 'local' ]; then
  HOSTNAME=`hostname`
else
  HOSTNAME=$HOST
fi

echo -e "Uploading and testing server: \e[0;32m$HOSTNAME\e[0m"
echo
codius upload --host https://$HOSTNAME --duration 30 -o -y

rm -rf $POD

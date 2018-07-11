cd
npm install -g codius

POD="/root/upload-test"
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
codius upload --host https://`hostname` --duration 30 -o -y


helm package charts
helm registry login registry-1.docker.io -u toodo
helm push elune-aio-1.0.0.tgz oci://registry-1.docker.io/toodo

helm upgrade --install --wait elune-aio ./charts
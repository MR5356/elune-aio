set -uex
BRANCH=develop
VERSION="v1.1.0-dev_build.$(date +%Y%m%d_%H%M%S)"

rm -rf out
rm -rf elune
rm -rf elune-backend

echo "准备代码"
git clone -b ${BRANCH} --depth=1 https://github.com/MR5356/elune.git elune
git clone -b ${BRANCH} --depth=1 https://github.com/MR5356/elune-backend.git elune-backend

echo "构建镜像"
docker buildx build --platform linux/arm64,linux/amd64 -t registry.cn-hangzhou.aliyuncs.com/toodo/elune-aio:${VERSION} . --push
docker buildx build --platform linux/arm64,linux/amd64 -t registry.cn-hangzhou.aliyuncs.com/toodo/elune-aio:latest . --push
mkdir -p out
docker buildx build -f Dockerfile-bin --output type=local,dest=out .

echo "清理目录"
rm -rf elune
rm -rf elune-backend

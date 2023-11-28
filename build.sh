set -x
BRANCH=main
VERSION=v1.0.5

rm -rf out

echo "准备代码"
git clone -b ${BRANCH} --depth=1 git@github.com:MR5356/Elune.git elune
git clone -b ${BRANCH} --depth=1 git@github.com:MR5356/elune-backend.git elune-backend

echo "构建镜像"
docker buildx build --platform linux/arm64,linux/amd64 -t registry.cn-hangzhou.aliyuncs.com/toodo/elune-aio:${VERSION} . --push
mkdir -p out
docker buildx build -f Dockerfile-bin --output type=local,dest=out .

echo "清理目录"
rm -rf elune
rm -rf elune-backend

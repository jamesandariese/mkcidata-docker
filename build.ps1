$ALPINE_VERSION=get-content ALPINE_VERSION
$XORRISO_VERSION=get-content XORRISO_VERSION

$IMAGE="jamesandariese/mkcidata"
$TAG="alpine-${ALPINE_VERSION}_xorriso-${XORRISO_VERSION}"

docker build --build-arg ALPINE_VERSION=$ALPINE_VERSION --build-arg XORRISO_VERSION=$XORRISO_VERSION -t "${IMAGE}:${TAG}" .
docker tag "${IMAGE}:${TAG}" "${IMAGE}:latest"
docker push "${IMAGE}:${TAG}"
docker push "${IMAGE}:latest"

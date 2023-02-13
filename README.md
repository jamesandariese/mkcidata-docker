
# `mkisofs-docker`

A docker image for building trivial ISOs trivially

## Usage

In examples, we'll be assembling some sample files for demonstration.  These are described below.

#### Source Files
Files assembled:
* `user-data-fragments/00_header.yaml`
```yaml
#cloud-config
```
* `user-data-fragments/10_controlplane.yaml`
```yaml
type: controlplane
```
* `user-data-fragments/99_token.yaml`
```yaml
token: kermit
```

#### Target Files
Intended contents of files will be:

* `meta-data`
```yaml
instance-id: i-unknown01
```

* `user-data`
```yaml
#cloud-config
type: controlplane
token: kermit
```

### Modes

Simple, local-only:

```bash
docker run -v "$PWD":"/out" mkisofs "meta-data=instance-id: i-unknown01" "user-data=$(cat user-data-fragments/*.yaml)"
```

More complex, works remotely:
```bash
function mkcidata() {
	OUT="$1"
	shift
	# create the image in the background so we get a container id
	IMG="$(docker run -d mkisofs "$@")"

	# then wait for the container to exit while watching its logs
	docker log -f "$IMG"

	if [ x"$(docker wait "$IMG")" != x0 ];then
		# if the container exited with an error, exit this script with an error, too
	    exit 1
	fi

	docker cp "$IMG":"/out/build-iso.iso" "$OUT"
}

mkcidata cidata.iso "meta-data=instance-id: i-unknown01" "user-data=$(cat user-data-fragments/*.yaml)"
```

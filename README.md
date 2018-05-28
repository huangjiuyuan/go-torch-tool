# Go Torch Tool

## Generate Torch Graph with Script
Run the following command to generate torch graph with `profile.sh`:
```
./profile.sh
```
Graph will be saved under `output` directory. Run `./profile -h` for more information.

## Generate Torch Graph with Docker
Run the following command to generate torch graph with Docker:
```
docker run uber/go-torch -u http://[address-of-host] -p > torch.svg
```
Use `-u` to set the listening address of `pprof`.

## Expose Docker Profiling Endpoint
For extracting profiling data, it is required that the debug mode of Docker is turned on:
* Modify `/etc/docker/daemon.json`, set `"debug": true`.
* Run `sudo kill -SIGHUP $(pidof dockerd)` to send `SIGHUP` signal.
* Run `docker info | grep -i debug.*server` to see if the modification is valid.

If the remote access endpoint of Docker is off, it is required to forward traffic to a local port:
```
socat -d -d TCP-LISTEN:8080,fork,bind=127.0.0.1 unix:/var/run/docker.sock
```

## Dependencies
This tool is for offline environment. The following dependencies are required for the tool: `go`, `go-torch`, `flamegraph.pl`, `perl`.

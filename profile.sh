#!/bin/bash

command_exists() {
    command -v "$@" > /dev/null 2>&1
}

usage() {
    echo "Usage:"
    echo "  -u, --url=         Base URL of your Go program (default: http://localhost:8080)"
    echo "  -t, --seconds=     Number of seconds to profile for (default: 30)"
    echo "  -f, --file=        Output file name (must be .svg)"
    exit 0
}

hostname=$(hostname)
time=$(date '+%Y-%m-%dT%H:%M:%S')
url="http://localhost:8080"
seconds="60"
file="output/${hostname}-${time}"

while getopts "u:t:" arg; do
    case $arg in
        u | url)
            url="${OPTARG}"
            ;;
        t | seconds)
            seconds="${OPTARG}"
            ;;
        f | file)
            file="${OPTARG}"
            ;;
        [?])
            usage
            ;;
    esac
done

if ! command_exists go; then
    tar -C /usr/local -xzf go*.tar.gz
    export PATH=$PATH:/usr/local/go/bin
fi

if [ ! -e "./output" ]; then
    mkdir output
fi

echo "# Extracting logs..."
tail -n 200000 /var/log/messages > output/$hostname-$time.log

echo "# Generating torch graph..."
./go-torch -u $url -t $seconds -f $file-cpu_time.svg
./go-torch -alloc_space $url/debug/pprof/heap -f $file-alloc_space.svg --colors=mem
./go-torch -inuse_space $url/debug/pprof/heap -f $file-inuse_space.svg --colors=mem

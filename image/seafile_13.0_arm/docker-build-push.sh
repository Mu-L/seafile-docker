
#!/bin/bash

version=$1

docker build --pull -t --build-arg server_version=$version seafileltd/seafile-mc:${version}-arm-testing ./



docker push seafileltd/seafile-mc:${version}-arm-testing



echo seafileltd/seafile-mc:${version}-arm-testing

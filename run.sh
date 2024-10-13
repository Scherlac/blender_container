#!/bin/env bash

docker run -it --rm -e ACCESS_PW=newPW -v xa:/Xauthority -p 6080:6080 -p 8888:8888 -p 5900:5900 blender-notebook

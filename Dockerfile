FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        xz-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    

WORKDIR /opt/blender
# ADD https://ftp.halifax.rwth-aachen.de/blender/release/Blender4.2/blender-4.2.2-linux-x64.tar.xz /tmp/blender.tar.xz

RUN mkdir -p /opt/blender \
    && curl -sSL https://ftp.halifax.rwth-aachen.de/blender/release/Blender4.2/blender-4.2.2-linux-x64.tar.xz -o /tmp/blender.tar.xz \
    && tar -xf /tmp/blender.tar.xz -C /opt/blender --strip-components=1 \
    && ln -s /opt/blender/4.2/python/bin/python3.11 /opt/blender/4.2/python/bin/python3 \
    && ln -s /opt/blender/4.2/python/bin/python3.11 /opt/blender/4.2/python/bin/python

ENV PATH="/opt/blender:/opt/blender/4.2/python/bin:${PATH}"

# ADD https://bootstrap.pypa.io/get-pip.py /tmp/get-pip.py
RUN curl -sSL https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py \
    && python /tmp/get-pip.py

COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

# error while loading shared libraries: libX11.so.6: cannot open shared object file: No such file or directory
RUN apt-get update && apt-get install -y \
        xvfb \
        xauth \
        x11vnc \
        x11-utils \
        x11-xserver-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# SRC: https://github.com/cheng-chi/blender_notebook/tree/master/blender_notebook
# need to add github blob:https://github.com/eacab325-d960-4ef7-a046-d6788ebee842
COPY blender /root/.local/share/jupyter/kernels/blender



EXPOSE 8888 6080
WORKDIR /workspace

# RUN apt-get update \
#     && apt-get install -y --no-install-recommends \
#       adduser \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

# RUN addgroup --system xusers \
#     && adduser \
#       --home /home/xuser \
#       --disabled-password \
#       --shell /bin/bash \
#       --gecos "user for running X Window stuff" \
#       --ingroup xusers \
#       --quiet \
#       xuser

RUN mkdir -p /Xauthority
#  \
#     && chown -R xuser:xusers /Xauthority

VOLUME /Xauthority

COPY BlenderNotebook.ipynb ./
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# # switch to user and start
# USER xuser

# error while loading shared libraries: libxkbcommon.so.0: cannot open shared object file: No such file or directory
RUN apt-get update && apt-get install -y \
        libxkbcommon-x11-0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    
ENV DISPLAY=:0

# start the command:
# like: jupyter notebook --allow-root --no-browser --ip=0.0.0.0
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]


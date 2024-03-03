FROM ghcr.io/engineer-man/piston:latest

RUN apt-get update && \
    apt-get install -y git && \
    apt-get clean && \
    git clone https://github.com/engineer-man/piston /piston_repo && \
    cd /piston_repo && \
    cd cli && npm i && cd - && \
    apt-get autoremove -y git

COPY myspec.pps /piston_repo/myspec.pps

RUN cd /piston_api && \
    mkdir -p /piston/packages && \
    cat /piston_repo/myspec.pps && \
    nohup bash -c 'node src &' && \
    sleep 5 && \
    /piston_repo/cli/index.js -u "http://127.0.0.1:2000" ppman spec /piston_repo/myspec.pps && \
    sync && \
    sleep 5 && \
    killall node && \
    rm -rf /piston_repo

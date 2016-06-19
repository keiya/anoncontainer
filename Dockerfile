FROM ubuntu:latest

RUN apt-get update && apt-get install -y libglu1-mesa firefox

# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/user01 && \
    echo "user01:x:${uid}:${gid}:User01,,,:/home/user01:/bin/bash" >> /etc/passwd && \
    echo "user01:x:${uid}:" >> /etc/group && \
    mkdir -p /etc/sudoers.d && \
    echo "user01 ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/user01 && \
    chmod 0440 /etc/sudoers.d/user01 && \
    chown ${uid}:${gid} -R /home/user01

USER user01
ENV HOME /home/user01
CMD /usr/bin/firefox

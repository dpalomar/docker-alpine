FROM alpine:latest
MAINTAINER dicotraining
RUN apk update
RUN apk upgrade
RUN apk add openssh bash nano sudo
RUN addgroup student
RUN adduser -s /bin/bash -G student student -D
RUN echo student:student | chpasswd
RUN sed -ri 's/(wheel:x:10:root)/\1,student/' /etc/group
RUN sed -ri 's/# %wheel ALL=\(ALL\) ALL/%wheel ALL=\(ALL\) ALL/' /etc/sudoers
RUN sed -ri 's;^(root:x:0:0:root:/root:)/bin/ash;\1/bin/bash;' /etc/passwd
RUN mkdir /var/run/sshd
RUN sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
ENV KEYGEN="ssh-keygen -b 2048 -t rsa -f"
RUN $KEYGEN /etc/ssh/ssh_host_rsa_key -q -N ""
RUN $KEYGEN /etc/ssh/ssh_host_dsa_key -q -N ""
RUN $KEYGEN /etc/ssh/ssh_host_ecdsa_key -q -N ""
RUN $KEYGEN /etc/ssh/ssh_host_ed25519_key -q -N ""
EXPOSE 22
CMD ["/usr/sbin/sshd","-D"] 

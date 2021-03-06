FROM ubuntu:18.04
MAINTAINER MaLu <malu@malu.me> 

WORKDIR /root

#时区设置
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#国内源
ADD sources.list /etc/apt/sources.list

#Add root files
ADD root/ /root

# Install packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install openssh-server pwgen \
    build-essential g++ curl libssl-dev git subversion vim libxml2-dev byobu htop man lrzsz wget supervisor \
    inetutils-ping cron expect \
    #压缩工具安装
    unzip p7zip p7zip-full && \
    # 用完包管理器后安排打扫卫生可以显著的减少镜像大小.
    apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    # */

################ [ssh start] ################
RUN mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && \
    sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && \
    sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config && \
    echo "gatewayports yes" >> /etc/ssh/sshd_config && \
    sed -i 's/.*StrictHostKeyChecking.*/    StrictHostKeyChecking no/' /etc/ssh/ssh_config && \
    sed -i "s/AcceptEnv.*/#AcceptEnv\ LANG\ LC_\*/g" /etc/ssh/sshd_config
################ [ssh end] ################

RUN echo "root:passwd" | chpasswd

VOLUME ["/app"]

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]


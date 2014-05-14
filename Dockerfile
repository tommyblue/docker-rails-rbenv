FROM ubuntu:14.04
MAINTAINER Tommaso Visconti <tommaso.visconti@gmail.com>
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y sudo git zsh wget build-essential zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev libsqlite3-dev
RUN apt-get clean

RUN apt-get install -y openssh-server supervisor
RUN mkdir -p /var/run/sshd
RUN mkdir -p /var/log/supervisor
ADD sshd_config /etc/ssh/sshd_config
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN groupadd --system admin
RUN adduser --gecos 'Rails user' --shell /bin/zsh --disabled-password --home /home/railsuser railsuser
RUN adduser railsuser admin
RUN git clone git://github.com/robbyrussell/oh-my-zsh.git /home/railsuser/.oh-my-zsh
ADD zshrc.zsh-template /home/railsuser/.zshrc
RUN chown -R railsuser:railsuser /home/railsuser
RUN echo "railsuser:s3cr3t" | chpasswd

RUN git clone https://github.com/sstephenson/rbenv.git /home/railsuser/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /home/railsuser/.rbenv/plugins/ruby-build
RUN echo 'gem: --no-rdoc --no-ri' > /home/railsuser/.gemrc
RUN chown -R railsuser:railsuser /home/railsuser
RUN su - railsuser -c 'export PATH="$HOME/.rbenv/bin:$PATH" && eval "$(rbenv init -)"'

RUN su - railsuser -c 'export PATH="$HOME/.rbenv/bin:$PATH" && rbenv install 2.1.2'
RUN su - railsuser -c 'export PATH="$HOME/.rbenv/bin:$PATH" && rbenv global 2.1.2'
RUN su - railsuser -c 'export PATH="$HOME/.rbenv/bin:$PATH" && rbenv local 2.1.2'
RUN su - railsuser -c 'export PATH="$HOME/.rbenv/bin:$PATH" && eval "$(rbenv init -)" && gem install bundler'

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libmysqlclient-dev libpq-dev

EXPOSE 3000 22

CMD ["/usr/bin/supervisord"]

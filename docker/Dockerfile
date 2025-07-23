FROM ruby:2.6

ENV DOCKER 1
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && \
    apt-get install -y \
    curl \
    elinks \
    ghostscript \
    git \
    libmagic-dev \
    pdftk \
    poppler-utils \
    postgresql-client \
    python-dev \
    sendmail \
    tnef \
    unrtf \
    mutt \
    libxapian-dev

# PyYAML
RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o /tmp/get-pip.py && \
    python /tmp/get-pip.py && \
    pip install pyyaml==3.13

# Wait-for-it
RUN git clone https://github.com/vishnubob/wait-for-it.git /tmp/wait-for-it && \
    chmod +x /tmp/wait-for-it/wait-for-it.sh && \
    ln -s /tmp/wait-for-it/wait-for-it.sh /bin/wait-for-it

WORKDIR /alaveteli/
RUN gem install sqlite3 -v 1.4.2
RUN gem install net-imap -v 0.3.8
RUN gem install mailcatcher -v 0.8.0 --conservative

EXPOSE 3000
EXPOSE 1080
CMD wait-for-it db:5432 --strict -- ./docker/entrypoint.sh

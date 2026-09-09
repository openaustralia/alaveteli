ARG RUBY_VERSION=3.4
FROM ruby:${RUBY_VERSION}-trixie

ENV DOCKER 1
ENV DEBIAN_FRONTEND noninteractive

# Debian trixie only packages postgresql-client 17, whose pg_dump writes
# `SET transaction_timeout = 0;` into db/structure.sql. That parameter is
# PostgreSQL 17+ only, so an older server rejects the file and db:migrate
# aborts before creating a single table. Take the client from PGDG instead and
# pin it to the same major version as docker/Dockerfile-postgres.
RUN install -d /usr/share/postgresql-common/pgdg && \
    curl -fsSL -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc \
      https://www.postgresql.org/media/keys/ACCC4CF8.asc && \
    echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt trixie-pgdg main" \
      > /etc/apt/sources.list.d/pgdg.list

RUN apt-get update -y && \
    apt-get install -y \
    elinks \
    ghostscript \
    libmagic-dev \
    pdftk \
    poppler-utils \
    postgresql-client-15 \
    sendmail \
    tnef \
    unrtf \
    mutt

# Wait-for-it
RUN git clone https://github.com/vishnubob/wait-for-it.git /tmp/wait-for-it && \
    chmod +x /tmp/wait-for-it/wait-for-it.sh && \
    ln -s /tmp/wait-for-it/wait-for-it.sh /bin/wait-for-it

WORKDIR /alaveteli
RUN git config --global --add safe.directory /alaveteli

# Pin to the last RubyGems 3.x release. RubyGems 4.0 removed the deprecated
# Gem::Specification#has_rdoc= method, which the mysociety/ruby-msg fork's
# gemspec still calls, breaking `bundle`/`Bundler.setup` at boot.
RUN gem update --system 3.7.2

EXPOSE 3000
CMD wait-for-it db:5432 --strict -- ./docker/entrypoint.sh

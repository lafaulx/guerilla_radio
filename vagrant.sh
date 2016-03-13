#!/usr/bin/env bash

# Installing Postgres
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
apt-get update
apt-get -y upgrade
apt-get install -y postgresql-9.5 pgadmin3
cat << EOF | su - postgres -c psql
CREATE USER vagrant WITH PASSWORD '';
EOF

# Installing Node
curl -sL https://deb.nodesource.com/setup_4.x | bash -
apt-get install -y nodejs

# Installing Elixir
sh -c 'echo "deb http://packages.erlang-solutions.com/ubuntu $(lsb_release -cs) contrib" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - http://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | apt-key add -
apt-get update
apt-get install -y esl-erlang elixir
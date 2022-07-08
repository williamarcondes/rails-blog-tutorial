FROM ruby:3.0.3-bullseye

RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends \
       build-essential locales curl git vim gawk file \
       nodejs npm imagemagick libzbar-dev \
       libpq-dev postgresql-client \
       liblzma-dev zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && gem update --system

ARG USER_ID
ARG USER_NAME
ENV USER_ID $USER_ID

# Cria usuário para gerar arquivos com permissão correta
RUN groupadd -g $USER_ID $USER_NAME && useradd -u $USER_ID -g $USER_NAME --create-home $USER_NAME

RUN mkdir -p /projeto && chown $USER_NAME:$USER_NAME /projeto
WORKDIR /projeto
COPY ./ /projeto

RUN npm install -g yarn
RUN yarn install
RUN yarn upgrade
RUN bundle install --jobs 20 --retry 5
RUN bundle update

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
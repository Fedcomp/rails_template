FROM ruby:2.5.1

RUN apt-get update
RUN apt-get install -y less vim pv # for container debugging

# Unicode locale fix
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN apt-get update # update postgres index
RUN apt-get install -y postgresql-client-10

# capybara
# RUN apt-get install -y chromium unzip libgconf-2-4
# RUN wget https://chromedriver.storage.googleapis.com/2.36/chromedriver_linux64.zip
# RUN unzip chromedriver_linux64.zip && mv chromedriver /bin && rm chromedriver_linux64.zip

# node.js
# RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
# RUN apt-get install -y nodejs
# RUN npm install -g yarn

ARG USERID=1000
RUN useradd -m backend -u $USERID
RUN chown -R backend:backend /usr/local/bundle
USER backend
WORKDIR /app

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]

FROM ghcr.io/virtualstaticvoid/heroku-docker-r:shiny

RUN apt-get update && apt-get install -y --no-install-recommends \ 
  sudo \ 
  libpq-dev \ 
  libcurl4-openssl-dev 

RUN install.r RPostgres

ENV PORT=8080

CMD ["/usr/bin/R", "--no-save", "--gui-none", "-f", "/app/run.R"]
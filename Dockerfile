FROM ghcr.io/virtualstaticvoid/heroku-docker-r:shiny
ENV PORT=8080
CMD ["/usr/bin/R", "--no-save", "--gui-none", "-f", "/app/run.R", "sudo apt-get install libpq-dev"]
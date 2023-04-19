FROM ubuntu:22.04
RUN apt-get update -y
RUN useradd user
RUN mkdir /server
COPY ./ooad /server/FileCosmos
RUN chown -R root:user /server && chmod -R 750 /server

CMD ["/server/FileCosmos"]

EXPOSE 80
FROM ubuntu:22.04
RUN apt-get update -y
RUN useradd user
RUN mkdir /server
COPY ./main /server/main
RUN chown -R root:user /server && chmod -R 750 /server

CMD ["/server/main"]

EXPOSE 80
FROM openjdk:17-alpine

RUN apk update && apk add --no-cache imagemagick

WORKDIR /app

COPY Watermark.java /app/Watermark.java

RUN javac Watermark.java

ENTRYPOINT ["java", "Watermark"]

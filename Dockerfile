# Build a JAR File
FROM openjdk:8-jdk-alpine AS build
#FROM nginx

WORKDIR /home/app
EXPOSE 5000

COPY /target/*.jar /home/app/

ENTRYPOINT ["sh", "-c", "java -jar hello-world-java.jar"]

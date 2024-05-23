#
# BUILD STAGE
#
FROM maven:3.8.7-eclipse-temurin-19 AS build
WORKDIR /app
COPY pom.xml .
COPY src/ src/
RUN mvn -f pom.xml clean package

#
# PACKAGE STAGE
#
FROM  eclipse-temurin:19 AS hello
WORKDIR /app
COPY --from=build /app/target/hello-1.0.jar hello-1.0.jar
EXPOSE 8080 8080
CMD ["java","-jar","hello-1.0.jar"]

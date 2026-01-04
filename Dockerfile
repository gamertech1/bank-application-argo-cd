# Multi-stage Dockerfile for building and running the Spring Boot application
FROM maven:3.9.4-eclipse-temurin-17 AS build
WORKDIR /workspace

# Copy only what is needed for dependency resolution first (speeds up rebuilds)
COPY pom.xml mvnw ./
COPY .mvn .mvn
RUN mvn -B -ntp dependency:go-offline

# Copy source and build
COPY src ./src
RUN mvn -B -ntp package -DskipTests -DskipIT

FROM eclipse-temurin:17-jre
WORKDIR /app

# Copy the built jar from the build stage
COPY --from=build /workspace/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]

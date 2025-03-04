# Use an official Maven image to build the project
FROM maven:3.9.9-eclipse-temurin-21-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy the Maven project files
COPY pom.xml .
COPY src ./src

# Run Maven clean package to build the application
RUN mvn clean package -DskipTests

# Use a lightweight JDK image for running the application
FROM openjdk:21

# Set the working directory
WORKDIR /app

# Copy the built JAR file from the builder stage
COPY --from=builder /app/target/*.jar remote-debugging.jar

ENV JAVA_TOOL_OPTIONS -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005

EXPOSE 5005

ENTRYPOINT ["java", "-jar", "remote-debugging.jar"]
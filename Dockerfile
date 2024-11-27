FROM --platform=linux/amd64 openjdk:21-jdk-slim as build

# Set working directory
WORKDIR /app

# Copy Gradle wrapper and project files
COPY gradlew gradlew.bat settings.gradle.kts build.gradle.kts /app/
COPY gradle /app/gradle
COPY src /app/src

# Build the application
RUN ./gradlew bootJar --no-daemon

# Runtime image
FROM --platform=linux/amd64 openjdk:21-jdk-slim

# Set working directory in container
WORKDIR /app

# Copy built application from build stage
COPY --from=build /app/build/libs/*.jar app.jar

# Expose the application's port
EXPOSE 8080

# Command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]

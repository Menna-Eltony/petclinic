# Stage 1:pull base image Build the application
FROM maven:3.9.7-amazoncorretto-17 AS builder
# Set the working directory inside the container
WORKDIR /app
# Copy the source code and build the application and config postgres
COPY ./spring-petclinic .
RUN ./mvnw package -DskipTests -Dspring-boot.run.profiles=postgres
# Stage 2: Create a minimal runtime image ,pull base image
FROM amazoncorretto:17
# Set the working directory inside the container
WORKDIR /app
# Copy the JAR file artifact from the build stage
COPY --from=builder /app/target/spring-petclinic-*.jar /app/app.jar
# Expose the port that the application will run on
EXPOSE 8080
#enviroment variables to connect the application to the database
ENV SPRING_PROFILES_ACTIVE=postgres
ENV POSTGRES_DB=petclinic
ENV POSTGRES_USER=petclinic
ENV POSTGRES_PASSWORD=petclinic
ENV POSTGRES_URL=jdbc:postgresql://192.168.205.129:5432/petclinic
# Command to run the application,java run file jar
CMD ["java", "-jar", "/app/app.jar"]

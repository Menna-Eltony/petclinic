FROM maven:3.9.7-amazoncorretto-17 AS base
WORKDIR /app
COPY . .
COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
RUN ./mvnw package -Dmaven.test.skip -Dspring-boot.run.profiles=postgres


FROM amazoncorretto:17 AS production
EXPOSE 8080
WORKDIR /app
COPY --from=base /app/target/spring-petclinic-*.jar /app/spring-petclinic.jar

# Set PostgreSQL connection properties as environment variables
ENV SPRING_PROFILES_ACTIVE=postgres
ENV POSTGRES_URL=jdbc:postgresql://192.168.205.129:5432/petclinic
ENV POSTGRES_USER=petclinic
ENV POSTGRES_PASSWORD=petclinic

CMD ["java", "-jar", "/app/spring-petclinic.jar"]


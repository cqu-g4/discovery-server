FROM eclipse-temurin:17-jdk-jammy AS build

WORKDIR /app
COPY . /app/

RUN java --version
RUN ./mvnw clean package

FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

COPY --from=build /app/target/discovery-server*.jar /app/
RUN find /app -iname discovery-server-\* -exec ln -sf '{}' /app/discovery-server.jar \;

RUN ls -l /app

ENV JAVA_OPTS "-Xms512m -Xmx512m"
#ENV APP_ARGS "-Dspring.config.location=/app/conf/application.properties "

HEALTHCHECK CMD nc -z localhost 8761
EXPOSE 8761

CMD java $JAVA_OPTS $APP_ARGS -jar /app/discovery-server.jar
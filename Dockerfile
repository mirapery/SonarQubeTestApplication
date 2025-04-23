FROM openjdk:17

COPY target/*.jar /usr/src/myapp/app.jar
WORKDIR /usr/src/myapp
RUN App.java
CMD ["java", "-jar", "app.jar"]
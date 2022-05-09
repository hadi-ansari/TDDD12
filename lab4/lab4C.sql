/*
Lab 4C report <Hadi Ansari (hadan326) and Sayed Ismail Safwat (saysa289)>
*/


/*
Drop all user created tables that have been created when solving the lab
*/


SET FOREIGN_KEY_CHECKS = 0; DROP TABLE Years; SET FOREIGN_KEY_CHECKS=1;
SET FOREIGN_KEY_CHECKS = 0; DROP TABLE Days; SET FOREIGN_KEY_CHECKS=1;
SET FOREIGN_KEY_CHECKS = 0; DROP TABLE Airport; SET FOREIGN_KEY_CHECKS=1;
SET FOREIGN_KEY_CHECKS = 0; DROP TABLE Route; SET FOREIGN_KEY_CHECKS=1;
SET FOREIGN_KEY_CHECKS = 0; DROP TABLE Weekly_Schedule; SET FOREIGN_KEY_CHECKS=1;
SET FOREIGN_KEY_CHECKS = 0; DROP TABLE Passenger; SET FOREIGN_KEY_CHECKS=1;
SET FOREIGN_KEY_CHECKS = 0; DROP TABLE ContactPerson; SET FOREIGN_KEY_CHECKS=1;
SET FOREIGN_KEY_CHECKS = 0; DROP TABLE Flight; SET FOREIGN_KEY_CHECKS=1;
SET FOREIGN_KEY_CHECKS = 0; DROP TABLE Customer; SET FOREIGN_KEY_CHECKS=1;
SET FOREIGN_KEY_CHECKS = 0; DROP TABLE Reservation; SET FOREIGN_KEY_CHECKS=1;
SET FOREIGN_KEY_CHECKS = 0; DROP TABLE ReservedFor; SET FOREIGN_KEY_CHECKS=1;
SET FOREIGN_KEY_CHECKS = 0; DROP TABLE BookedFor; SET FOREIGN_KEY_CHECKS=1;
SET FOREIGN_KEY_CHECKS = 0; DROP TABLE Booking; SET FOREIGN_KEY_CHECKS=1;


DROP PROCEDURE IF EXISTS addYear;
DROP PROCEDURE IF EXISTS addDay;




/*
TABLES  
*/
CREATE TABLE Years(Year INTEGER PRIMARY KEY, ProfitFactor DOUBLE);

CREATE TABLE Days(Day VARCHAR(10) PRIMARY KEY, WeekdayFactor DOUBLE, Year INTEGER, FOREIGN KEY (Year) REFERENCES Years(Year));

CREATE TABLE Airport(AirportCode VARCHAR(3) PRIMARY KEY, Country VARCHAR(30), Name VARCHAR(30));

CREATE TABLE Route(RoutePrice DOUBLE, A_Airport_Code VARCHAR(3), D_Airport_Code VARCHAR(3), Year INTEGER, FOREIGN KEY (A_Airport_Code) REFERENCES Airport(AirportCode), FOREIGN KEY (D_Airport_Code) REFERENCES Airport(AirportCode), FOREIGN KEY (Year) REFERENCES Years(Year), PRIMARY KEY (A_Airport_Code, D_Airport_Code));

CREATE TABLE Weekly_Schedule(ScheduleID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY, Time TIME, A_Airport_Code VARCHAR(3), D_Airport_Code VARCHAR(3), Day VARCHAR(10), Year INTEGER, FOREIGN KEY (A_Airport_Code) REFERENCES Route(A_Airport_Code), FOREIGN KEY (D_Airport_Code) REFERENCES Route(D_Airport_Code), FOREIGN KEY (Day) REFERENCES Days(Day), FOREIGN KEY (Year) REFERENCES Years(Year));

CREATE TABLE Passenger(PassportNo INTEGER PRIMARY KEY, FirstName VARCHAR(30), LastName VARCHAR(30));

CREATE TABLE ContactPerson(Passport_No INTEGER PRIMARY KEY, Email VARCHAR(30), PhoneNo BIGINT, FOREIGN KEY (Passport_No) REFERENCES Passenger(PassportNo));

CREATE TABLE Flight(FlightNo INTEGER NOT NULL AUTO_INCREMENT, Schedule_ID INTEGER, Week INTEGER, AvailableSeats INTEGER DEFAULT 40, PRIMARY KEY (FlightNo, Schedule_ID), FOREIGN KEY (Schedule_ID) REFERENCES Weekly_Schedule(ScheduleID));

CREATE TABLE Customer(CardNo BIGINT PRIMARY KEY, CardHolderName VARCHAR(30));

CREATE TABLE Reservation(ReservationID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY, Flight_No INTEGER, FOREIGN KEY (Flight_No) REFERENCES Flight(FlightNo));

CREATE TABLE ReservedFor(Reservation_ID INTEGER, Passport_No INTEGER, PRIMARY KEY(Reservation_ID, Passport_No), FOREIGN KEY (Reservation_ID) REFERENCES Reservation(ReservationID), FOREIGN KEY (Passport_No) REFERENCES Passenger(PassportNo));

CREATE TABLE BookedFor(TicketNo BIGINT PRIMARY KEY, Passport_No INTEGER, Reservation_ID INTEGER, FOREIGN KEY (Passport_No) REFERENCES Passenger(PassportNo), FOREIGN KEY (Reservation_ID) REFERENCES Reservation(ReservationID));

CREATE TABLE Booking(Reservation_ID INTEGER PRIMARY KEY, NoBookedPassenger INTEGER, Card_No BIGINT, FOREIGN KEY (Reservation_ID) REFERENCES Reservation(ReservationID), FOREIGN KEY (Card_No) REFERENCES Customer(CardNo));

/*
PROCEDURES
*/

delimiter //
CREATE PROCEDURE addYear(IN year INTEGER, IN factor DOUBLE)BEGIN INSERT INTO Years VALUES (year, factor); END;//
delimiter ;


delimiter //
CREATE PROCEDURE addDay(IN year INTEGER, IN day VARCHAR(10), IN factor DOUBLE)BEGIN INSERT INTO Days VALUES (day, factor, year); END;//
delimiter ;

delimiter //
CREATE PROCEDURE addDestination(IN airport_code VARCHAR(3), IN name VARCHAR(30), IN country VARCHAR(30)) BEGIN INSERT INTO Airport VALUES (airport_code, name, country); END;//
delimiter ;

delimiter //
CREATE PROCEDURE addRoute(IN departure_airport_code VARCHAR(3), IN arrival_airport_code VARCHAR(3), IN year INTEGER, IN routeprice DOUBLE) BEGIN INSERT INTO Route (RoutePrice, A_Airport_Code, D_Airport_Code, Year) VALUES (routeprice, arrival_airport_code, departure_airport_code, year); END;//
delimiter ;



delimiter //
CREATE PROCEDURE addFlight(IN departure_airport_code VARCHAR(3), IN arrival_airport_code VARCHAR(3), IN year INTEGER, IN day VARCHAR(10), IN departure_time Time)
      BEGIN
      DECLARE schedule_id INTEGER;
      DECLARE counter INTEGER;
      INSERT INTO Weekly_Schedule(Time, A_Airport_Code, D_Airport_Code, Day, Year) VALUES (departure_time, arrival_airport_code, departure_airport_code, day, year);
      SET schedule_id = (SELECT max(ScheduleID) FROM Weekly_Schedule);
      SET counter = 1;
      WHILE counter < 53 DO
      INSERT INTO Flight (Schedule_ID, Week) VALUES (schedule_id, counter);
      SET counter = counter + 1;
      END WHILE; 
      END//

delimiter ;
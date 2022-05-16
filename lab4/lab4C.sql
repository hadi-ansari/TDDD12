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
DROP PROCEDURE IF EXISTS addDestination;
DROP PROCEDURE IF EXISTS addRoute;

DROP FUNCTION IF EXISTS calculateFreeSeats;
DROP FUNCTION IF EXISTS calculatePrice;

DROP FUNCTION IF EXISTS issueTicket;





/*
TABLES  
*/
CREATE TABLE Years(Year INTEGER PRIMARY KEY, ProfitFactor DOUBLE);

CREATE TABLE Days(Day VARCHAR(10), WeekdayFactor DOUBLE, IdentifyingYear INTEGER, FOREIGN KEY (IdentifyingYear) REFERENCES Years(Year), PRIMARY KEY (Day, IdentifyingYear));

CREATE TABLE Airport(AirportCode VARCHAR(3) PRIMARY KEY, Country VARCHAR(30), AirportName VARCHAR(30));

CREATE TABLE Route(RoutePrice DOUBLE, A_Airport_Code VARCHAR(3), D_Airport_Code VARCHAR(3), RouteYear INTEGER, FOREIGN KEY (A_Airport_Code) REFERENCES Airport(AirportCode), FOREIGN KEY (D_Airport_Code) REFERENCES Airport(AirportCode), FOREIGN KEY (RouteYear) REFERENCES Years(Year), PRIMARY KEY (A_Airport_Code, D_Airport_Code));

CREATE TABLE Weekly_Schedule(ScheduleID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY, Time TIME, SA_Airport_Code VARCHAR(3), SD_Airport_Code VARCHAR(3), WeekDay VARCHAR(10), ScheduleYear INTEGER, FOREIGN KEY (SA_Airport_Code) REFERENCES Route(A_Airport_Code), FOREIGN KEY (SD_Airport_Code) REFERENCES Route(D_Airport_Code), FOREIGN KEY (WeekDay, ScheduleYear) REFERENCES Days(Day, IdentifyingYear), FOREIGN KEY (ScheduleYear) REFERENCES Years(Year));

CREATE TABLE Passenger(PassportNo INTEGER PRIMARY KEY, Name VARCHAR(30));

CREATE TABLE ContactPerson(Passport_No INTEGER PRIMARY KEY, Email VARCHAR(30), PhoneNo BIGINT, FOREIGN KEY (Passport_No) REFERENCES Passenger(PassportNo));

CREATE TABLE Flight(FlightNo INTEGER NOT NULL AUTO_INCREMENT, Schedule_ID INTEGER, Week INTEGER, AvailableSeats INTEGER DEFAULT 40, PRIMARY KEY (FlightNo, Schedule_ID), FOREIGN KEY (Schedule_ID) REFERENCES Weekly_Schedule(ScheduleID));

CREATE TABLE Customer(CardNo BIGINT PRIMARY KEY, CardHolderName VARCHAR(30));

CREATE TABLE Reservation(ReservationID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY, Flight_No INTEGER, NoReservedPassenger INTEGER, FOREIGN KEY (Flight_No) REFERENCES Flight(FlightNo));

CREATE TABLE ReservedFor(Reservation_ID INTEGER, Passport_No INTEGER, PRIMARY KEY(Reservation_ID, Passport_No), FOREIGN KEY (Reservation_ID) REFERENCES Reservation(ReservationID), FOREIGN KEY (Passport_No) REFERENCES Passenger(PassportNo));

CREATE TABLE BookedFor(TicketNo BIGINT PRIMARY KEY, Passport_No INTEGER, Reservation_ID INTEGER, FOREIGN KEY (Passport_No) REFERENCES Passenger(PassportNo), FOREIGN KEY (Reservation_ID) REFERENCES Reservation(ReservationID));

CREATE TABLE Booking(Reservation_ID INTEGER PRIMARY KEY, Card_No BIGINT, FOREIGN KEY (Reservation_ID) REFERENCES Reservation(ReservationID), FOREIGN KEY (Card_No) REFERENCES Customer(CardNo));

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
CREATE PROCEDURE addRoute(IN departure_airport_code VARCHAR(3), IN arrival_airport_code VARCHAR(3), IN year INTEGER, IN routeprice DOUBLE) BEGIN INSERT INTO Route (RoutePrice, A_Airport_Code, D_Airport_Code, RouteYear) VALUES (routeprice, arrival_airport_code, departure_airport_code, year); END;//
delimiter ;



delimiter //
CREATE PROCEDURE addFlight(IN departure_airport_code VARCHAR(3), IN arrival_airport_code VARCHAR(3), IN year INTEGER, IN day VARCHAR(10), IN departure_time Time)
      BEGIN
      DECLARE schedule_id INTEGER;
      DECLARE counter INTEGER;
      INSERT INTO Weekly_Schedule(Time, SA_Airport_Code, SD_Airport_Code, WeekDay, ScheduleYear) VALUES (departure_time, arrival_airport_code, departure_airport_code, day, year);
      SET schedule_id = (SELECT LAST_INSERT_ID());
      SET counter = 1;
      WHILE counter < 53 DO
      INSERT INTO Flight (Schedule_ID, Week) VALUES (schedule_id, counter);
      SET counter = counter + 1;
      END WHILE; 
      END//

delimiter ;

delimiter //
CREATE FUNCTION calculateFreeSeats(flightnumber INTEGER)
      RETURNS INTEGER
      BEGIN 
      DECLARE freeSeats INTEGER;
      SELECT AvailableSeats INTO freeSeats FROM Flight WHERE FlightNo = flightnumber;
      RETURN freeSeats;
      END //

delimiter ;

          
delimiter //
CREATE FUNCTION calculatePrice(flightnumber INT)
      RETURNS DOUBLE
      BEGIN
      DECLARE rPrice DOUBLE;
      DECLARE wdFactor DOUBLE;
      DECLARE sFactor DOUBLE;
      DECLARE pFactor DOUBLE;
      SET rPrice =  (SELECT RoutePrice FROM (SELECT * FROM Weekly_Schedule AS W, Route AS R WHERE W.SA_Airport_Code = R.A_Airport_Code AND W.SD_Airport_Code = R.D_Airport_Code) AS T, Flight AS F WHERE T.ScheduleID = F.Schedule_ID AND F.FlightNo = flightnumber);
      SET wdFactor = (SELECT WeekdayFactor  FROM (SELECT * FROM Weekly_Schedule AS W, Days AS D WHERE W.Weekday = D.Day AND W.ScheduleYear = D.IdentifyingYear) AS T, Flight AS F WHERE T.ScheduleID = F.Schedule_ID AND F.FlightNo = flightnumber);
      SET sFactor =  (SELECT ((40 - AvailableSeats + 1 )/40) FROM Flight WHERE FlightNo = flightnumber);
      SET pFactor =  (SELECT ProfitFactor FROM (SELECT * FROM Weekly_Schedule AS W, Years AS Y WHERE W.ScheduleYear = Y.Year) AS T, Flight AS F WHERE T.ScheduleID = F.Schedule_ID AND F.FlightNo = flightnumber);
      RETURN (rPrice * wdFactor * sFactor * pFactor);
      END;

delimiter ;


CREATE TRIGGER issueTicket BEFORE INSERT ON BookedFor FOR EACH ROW SET NEW.TicketNo = CAST(RAND() * 1000000 AS INT);

delimiter //
CREATE PROCEDURE addReservation(IN departure_airport_code VARCHAR(3), IN arrival_airport_code VARCHAR(3), IN year INTEGER, IN week INTEGER, IN day VARCHAR(10), IN time TIME, IN number_of_passenger INTEGER, OUT output_reservation_nr INTEGER )
BEGIN
DECLARE Fnumber INTEGER;
SET Fnumber = (SELECT FlightNo FROM Flight AS F, Weekly_Schedule AS W WHERE F.Schedule_ID = W.ScheduleID AND W.SA_Airport_Code = arrival_airport_code AND W.SD_Airport_Code = departure_airport_code AND W.ScheduleYear = year AND W.WeekDay = day AND W.Time = time AND F.Week = week);
SELECT CAST(RAND() * 1000000 AS INT) INTO output_reservation_nr;
INSERT INTO Reservation VALUES (output_reservation_nr, Fnumber, number_of_passenger);

END;

delimiter ;




delimiter // 
CREATE PROCEDURE addPassenger(IN reservation_nr INTEGER, IN passport_number INTEGER, IN name VARCHAR(30))
BEGIN
DECLARE addedPassenger INTEGER;
DECLARE noOfReservedPassenger INTEGER;
SET addedPassenger = (SELECT COUNT(*) FROM ReservedFor WHERE Reservation_ID = reservation_nr);
SET noOfReservedPassenger = (SELECT NoReservedPassenger FROM Reservation WHERE ReservationID = reservation_nr);
IF addedPassenger = noOfReservedPassenger THEN
      UPDATE Reservation SET NoReservedPassenger = NoReservedPassenger + 1 WHERE ReservationID = reservation_nr;
END IF;

INSERT INTO Passenger VALUES (passport_number, name);
INSERT INTO ReservedFor VALUES (reservation_nr, passport_number);

END;

delimiter ;

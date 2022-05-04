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






CREATE TABLE Years(Year INTEGER PRIMARY KEY, ProfitFactor DOUBLE);

CREATE TABLE Days(Day VARCHAR(10) PRIMARY KEY, WeekdayFactor DOUBLE, Year INTEGER, FOREIGN KEY (Year) REFERENCES Years(Year));

CREATE TABLE Airport(AirportCode VARCHAR(3) PRIMARY KEY, Country VARCHAR(30), Name VARCHAR(30));

CREATE TABLE Route(RouteID INTEGER AUTO_INCREMENT PRIMARY KEY, RoutePrice DOUBLE, A_Airport_Code VARCHAR(3), D_Airport_Code VARCHAR(3), Year INTEGER, FOREIGN KEY (A_Airport_Code) REFERENCES Airport(AirportCode), FOREIGN KEY (D_Airport_Code) REFERENCES Airport(AirportCode), FOREIGN KEY (Year) REFERENCES Years(Year));

CREATE TABLE Weekly_Schedule(ScheduleID INTEGER AUTO_INCREMENT PRIMARY KEY, Time TIME, Route_ID INTEGER, Day VARCHAR(10), Year INTEGER, FOREIGN KEY (Route_ID) REFERENCES Route(RouteID), FOREIGN KEY (Day) REFERENCES Days(Day), FOREIGN KEY (Year) REFERENCES Years(Year));

CREATE TABLE Passenger(PassportNo INTEGER PRIMARY KEY, FirstName VARCHAR(30), LastName VARCHAR(30));

CREATE TABLE ContactPerson(Passport_No INTEGER PRIMARY KEY, Email VARCHAR(30), PhoneNo BIGINT, FOREIGN KEY (Passport_No) REFERENCES Passenger(PassportNo));

CREATE TABLE Flight(FlightNo INTEGER, Schedule_ID INTEGER, Week INTEGER, Passport_No INTEGER, PRIMARY KEY (FlightNo, Schedule_ID), FOREIGN KEY (Passport_No) REFERENCES ContactPerson(Passport_No));

CREATE TABLE Customer(CardNo BIGINT PRIMARY KEY, CardHolderName VARCHAR(30));

CREATE TABLE Reservation(ReservationID INTEGER AUTO_INCREMENT PRIMARY KEY, Flight_No INTEGER, FOREIGN KEY (Flight_No) REFERENCES Flight(FlightNo));

CREATE TABLE ReservedFor(Reservation_ID INTEGER, Passport_No INTEGER, PRIMARY KEY(Reservation_ID, Passport_No), FOREIGN KEY (Reservation_ID) REFERENCES Reservation(ReservationID), FOREIGN KEY (Passport_No) REFERENCES Passenger(PassportNo));

CREATE TABLE BookedFor(TicketNo BIGINT PRIMARY KEY, Passport_No INTEGER, Reservation_ID INTEGER, FOREIGN KEY (Passport_No) REFERENCES Passenger(PassportNo), FOREIGN KEY (Reservation_ID) REFERENCES Reservation(ReservationID));

CREATE TABLE Booking(Reservation_ID INTEGER PRIMARY KEY, NoBookedPassenger INTEGER, Card_No BIGINT, FOREIGN KEY (Reservation_ID) REFERENCES Reservation(ReservationID), FOREIGN KEY (Card_No) REFERENCES Customer(CardNo));
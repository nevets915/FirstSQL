SET ECHO ON

SPOOL "C:\Users\Steven\p2\Documents\Ma_Steven_SQL_Hotel_Database.txt"
--
--Assignment 1 for COMP 2714, Set 2A
--Steven Ma, A00596388
--

ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD';

SELECT SYSDATE
FROM DUAL;

--1.Dropping tables in order.
DROP TABLE Booking;
DROP TABLE OldBooking;
DROP TABLE Guest;
DROP TABLE Room;
DROP TABLE Hotel;

--2. Creating Hotel table then Room Table.
CREATE TABLE Hotel 
(hotelNo   CHAR(4)     NOT NULL
,hotelName VARCHAR(20) NOT NULL
,city      VARCHAR(20) NOT NULL
,PRIMARY KEY (hotelNo)
);

--Room Table created.
CREATE TABLE Room
(roomNo  CHAR(3)      NOT NULL
,hotelNo CHAR(4)      NOT NULL
,type    CHAR(6)      NOT NULL
,price   DECIMAL(5,2) NOT NULL
,PRIMARY KEY (roomNo, hotelNo)
,FOREIGN KEY (hotelNo) REFERENCES Hotel (hotelNo)
  ON DELETE CASCADE
,CONSTRAINT rmtype CHECK(type IN ('Single' , 'Double' , 'Family'))
,CONSTRAINT rmprice CHECK(price BETWEEN 10 AND 100)
,CONSTRAINT rmnumber CHECK(roomNo BETWEEN 1 AND 100)
);

--3. Creating Guest Table and Booking table.
CREATE TABLE Guest
(guestNo      CHAR(3)     NOT NULL
,guestName    VARCHAR(20) NOT NULL
,guestAddress VARCHAR(20) NOT NULL
,PRIMARY KEY (guestNo)
);


--Creating Booking Table.
CREATE TABLE Booking
(hotelNo  CHAR(4) NOT NULL
,guestNo  CHAR(3) NOT NULL
,dateFrom DATE    NOT NULL
,dateTo   DATE    NOT NULL
,roomNo   CHAR(3) NOT NULL
,PRIMARY KEY(hotelNo, guestNo, dateFrom)
,FOREIGN KEY(roomNo, hotelNo) REFERENCES Room (roomNo, hotelNo)
  ON DELETE CASCADE
,FOREIGN KEY(guestNo) REFERENCES Guest (guestNo)
  ON DELETE CASCADE
,CONSTRAINT booking_rmnumber CHECK(roomNo BETWEEN 1 AND 100)
);

--4. Inserting samples into Hotel table.
INSERT INTO Hotel
  VALUES
  ('0001' , 'Hampton' , 'Deviant');

INSERT INTO Hotel
  VALUES
  ('0002' , 'Holiday Inn' , 'Deviant');

INSERT INTO Hotel
  VALUES
  ('0003' , 'Sun View' , 'Deviant');

INSERT INTO Room
  VALUES
  ('001' , '0001' , 'Single' , 50);

INSERT INTO Room
  VALUES
  ('001' , '0002' , 'Double' , 75);

INSERT INTO Room
  VALUES
  ('001' , '0003' , 'Family' , 100);

INSERT INTO Guest
  VALUES
  ('001' , 'Al' , '123 Guilty Spark St.');

INSERT INTO Guest
  VALUES
  ('002' , 'Bob' , '7215 Narnia Ave.');

INSERT INTO Guest
  VALUES
  ('003' , 'Harry' , '34 Privet Dr.');

INSERT INTO Booking
  VALUES
  ('0001' , '001' , '2015-01-20' , '2015-06-11', '001');

INSERT INTO Booking
  VALUES
  ('0002' , '002' , '2015-07-12' , '2012-08-01', '001');

INSERT INTO Booking
  VALUES
  ('0003' , '003' , '2015-10-15' , '2016-01-10', '001');

--5.a) Dropping previous constraint for Room Table.
ALTER TABLE Room
  DROP
  CONSTRAINT rmtype;

--Adding table constraint to add Deluxe size.
ALTER TABLE Room
  ADD
  CONSTRAINT rmtype CHECK (type IN ('Single' , 'Double' , 'Family' , 'Deluxe'));

--5.b) Adding discount to Room table.
ALTER TABLE Room
  ADD discount DECIMAL(2,0) DEFAULT 0 NOT NULL;

--6.a) Increased pricing of one hotel.
UPDATE Room
  SET price = price * 1.15
  WHERE type = 'Double' AND hotelNo = '0002';

--6.b) Updated guest staying time.
UPDATE Booking
  SET dateTo =  '2015-01-19', dateFrom = '2015-06-12'
  WHERE hotelNo = '0001' AND guestNo = '001'AND dateTo =  '2015-01-20'

--7.a) Created OldBooking table from Booking.
CREATE TABLE OldBooking
(hotelNo  CHAR(4) NOT NULL
,guestNo  CHAR(3) NOT NULL
,dateFrom DATE    NOT NULL
,dateTo   DATE    NOT NULL
,roomNo   CHAR(3) NOT NULL
,PRIMARY KEY(hotelNo, guestNo,dateFrom)
,FOREIGN KEY(roomNo, hotelNo) REFERENCES Room (roomNo, hotelNo)
  ON DELETE CASCADE
,FOREIGN KEY(guestNo) REFERENCES Guest (guestNo)
  ON DELETE CASCADE
,CONSTRAINT oldbooking_rmnumber CHECK(roomNo BETWEEN 1 AND 100)
);

--7.b) Copying data from Booking table to OldBooking table.
INSERT INTO OldBooking
  SELECT *
  FROM Booking
  WHERE dateTo < TO_DATE('2016-01-01');

--7. c) Deleting Booking data that is already contained in OldBooking.
DELETE FROM Booking
  WHERE dateTo < TO_DATE('2016-01-01');


SPOOL OFF

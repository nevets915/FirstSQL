SET ECHO ON
SPOOL "C:\Users\Steven\p2\Documents\Ma_Steven_HotelTable_Manipulation.txt"
--
--Assignment 2 for COMP 2714, Set 2A
--Ma, Steven A00596388
--
ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD';

SELECT SYSDATE
FROM DUAL;

-- 1)
SELECT h.hotelName, h.hotelAddress, r.type, r.price
  FROM   Hotel h
    INNER JOIN Room r ON h.hotelNo = r.hotelNo
  WHERE h.hotelAddress LIKE '%London%'
    AND r.type IN('Single', 'Double', 'Family')
	AND r.price < 100.00
  ORDER BY h.hotelName DESC, r.price ASC, r.type DESC
;

-- 2)  
SELECT h.hotelName, h.hotelAddress, r.roomNo, b.dateFrom, b.dateTo
  FROM   Hotel h
    INNER JOIN Room r    ON h.hotelNo = r.hotelNo
	INNER JOIN Booking b ON b.roomNo = r.roomNo AND b.hotelNo = h.hotelNo
  WHERE  h.hotelAddress LIKE '%Vancouver%'
    AND  h.hotelAddress NOT LIKE '%West Vancouver%'
	AND  h.hotelAddress NOT LIKE '%North Vancouver%'
    AND  dateTo IS NULL
;

-- 3)
SELECT h.hotelName, AVG(r.price) AS "Avg.Price"
  FROM Hotel h
    INNER JOIN Room r ON h.hotelNo = r.hotelNo
  GROUP BY h.hotelName
  ORDER BY h.hotelName
;
 
-- 4) 
SELECT h.hotelName, SUM(r.price) AS "DoubleRevenue"
  FROM Hotel h
    INNER JOIN Room r ON h.hotelNo = r.hotelNo
  WHERE r.type = 'Double'
  GROUP BY h.hotelName
    HAVING SUM(r.price) > 500
	  AND SUM(r.price) < 1000
  ORDER BY h.hotelName
;

-- 5)  
SELECT r.type, r.price, COUNT(*) AS NumRooms
  FROM Hotel h
    INNER JOIN Room r ON h.hotelNo = r.hotelNo
  WHERE h.hotelName LIKE '%Grosvenor%'
  GROUP BY r.type, r.price
    HAVING COUNT(*) > 3
;

-- 6)  
SELECT g.guestName, r.roomNo
  FROM Hotel h
    INNER JOIN Room r ON h.hotelNo = r.hotelNo
	INNER JOIN Booking b ON b.roomNo = r.roomNo AND b.hotelNo = h.hotelNo
	INNER JOIN Guest g ON g.guestNo = b.guestNo
  WHERE h.hotelName LIKE '%Grosvenor Hotel%'
    AND (b.dateTo > DATE'2016-02-01' OR b.dateTo IS NULL)
	AND b.dateFrom < DATE'2016-02-01'
;

-- 7)
SELECT SUM(r.price) AS "TodayRevenue"
  FROM Hotel h
    INNER JOIN Room r ON h.hotelNo = r.hotelNo
	INNER JOIN Booking b ON b.roomNo = r.roomNo AND b.hotelNo = h.hotelNo
  WHERE h.hotelName LIKE '%Grosvenor%'
    AND (b.dateTo > DATE'2016-02-01' OR b.dateTo IS NULL)
	AND b.dateFrom <= DATE'2016-02-01'
;
  
-- 8)

SELECT h.hotelName, r.type, SUM(r.price) AS "TodayRevenue"
  FROM Hotel h
    INNER JOIN Room r ON h.hotelNo = r.hotelNo
	INNER JOIN Booking b ON b.roomNo = r.roomNo AND b.hotelNo = h.hotelNo
  WHERE (b.dateTo > DATE'2016-02-01' OR b.dateTo IS NULL)
    AND b.dateFrom <= DATE'2016-02-01'
  GROUP BY h.hotelName, r.type
;

-- 9)

SELECT h.hotelName
  FROM Hotel h
    LEFT JOIN Room r ON h.hotelNo = r.hotelNo
  WHERE r.roomNo IS NULL
;

-- 10)

SELECT COUNT(DISTINCT h.hotelNo) AS Total,
	   COUNT(DISTINCT r.hotelNo) AS Completed,
       COUNT(DISTINCT h.hotelNo) - COUNT(DISTINCT r.hotelNo) AS UnderCon,
	   (COUNT(DISTINCT h.hotelNo) - COUNT(DISTINCT r.hotelNo)) / 
	   COUNT(DISTINCT h.hotelNo) * 100.0 AS PercentUnderCon
  FROM Hotel h
    LEFT JOIN Room r ON h.hotelNo = r.hotelNo
;
SPOOL OFF
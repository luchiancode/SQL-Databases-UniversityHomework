CREATE DATABASE Homework1_Ionica_Mihai
USE Homework1_Ionica_Mihai
GO

CREATE TABLE Branch (
  ID int PRIMARY KEY,
  Location varchar(30),
  Name varchar(20),
  NumberOfEmployees int
);

SELECT * FROM Branch

CREATE TABLE Publisher (
  ID char(10) PRIMARY KEY,
  Name varchar(30),
  Location varchar(30),
  Code varchar(20),
);

SELECT * FROM Publisher

CREATE TABLE Author (
  ID int PRIMARY KEY,
  Name varchar(30),
);

SELECT * FROM Author

CREATE TABLE Book (
  ID int PRIMARY KEY,
  Title varchar(30),
  Paperback char(3) CHECK (Paperback IN ('YES','NO')),
  Code varchar(20),
  _Type varchar(20),
  Price int,
  PublicationDate date
);

DROP TABLE Book

CREATE TABLE Wrote (
  ID_Book              int FOREIGN KEY REFERENCES Book(ID) ON DELETE CASCADE ON UPDATE CASCADE,
  ID_Author            int FOREIGN KEY REFERENCES Author(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

SELECT * FROM Wrote

CREATE TABLE Pub_Book (
  ID_Book             int FOREIGN KEY REFERENCES Book(ID) ON DELETE CASCADE ON UPDATE CASCADE,
  ID_Publisher        char(10) FOREIGN KEY REFERENCES Publisher(ID) ON DELETE CASCADE ON UPDATE CASCADE
  );

SELECT * FROM Pub_Book

CREATE TABLE Inventory
  ( ID_Inventory			int primary key clustered,
	ID_Branch    		    int FOREIGN KEY REFERENCES Branch(ID) ON DELETE CASCADE ON UPDATE CASCADE,
	ID_Book              	int,
	Units					int,
	On_Hand					int
	);



INSERT INTO Branch (ID, Location, Name, NumberOfEmployees) 
            VALUES ('1','Sibiu','Clasic','10'),
			       ('2','Constanta','Roman','3'),
				   ('3','Bucuresti','Roman','30'),
				   ('4','Cluj','Fiction','15'),
				   ('5','Iasi','Biography','35'),
				   ('6','Vaslui','Documentary','130'),
				   ('7','Botosani','Non-Fiction','730'),
				   ('8','Alba Iulia','Theatre','11'),
				   ('9','Brasov','Poetry','14'),
				   ('10','Oradea','Narrative','16')
				   
SELECT * FROM Branch

DROP TABLE Publisher
DROP TABLE Pub_Book

INSERT INTO Publisher (ID, Name, Location, Code)
            VALUES ('AA','Polirom','Bucuresti','RH'),
			       ('AB','Libris','Cluj','HR'),
				   ('AC','Litera','Sibiu','RH'),
				   ('AD','Historia','Constanta','RH'),
			       ('AE','Humanitas','Iasi','HR'),
				   ('AF','Publica','Botosani','RH'),
				   ('AG','Tor Books','Vaslui','RH'),
			       ('AH','Tor Books','Brasov','HR'),
				   ('AI','Corint','Alba Iulia','RH'),
				   ('AJ','Tor Books','Oradea','RH')



SELECT * FROM Publisher

INSERT INTO Author (ID, Name)
            VALUES ('1','Dostoievski'),
			       ('0','Orwell'),
				   ('2','Orwell'),
				   ('3','Dostoievski'),
			       ('4','Dostoievski'),
				   ('5','Leo Tolstoy'),
				   ('6','Orwell'),
			       ('7','Oscar Wilde'),
				   ('8','Joseph Heller'),
				   ('9','Miguel de Cervantes')


SELECT * FROM Author

INSERT INTO Book (ID, Title, Paperback, Code, _Type, Price,PublicationDate)
            VALUES ('0','Demonii','NO','1234','HOR',10,'1995'),
			       ('1','1984','YES','4321','ART',30,'1995'),
				   ('2','Homage to Catalonia','YES','2345','ART',20,'1995'),
				   ('3','Karamazov','NO','5432','TRA',15,'2000'),
			       ('4','Crime and Punishment','YES','3456','PSY',14,'2000'),
				   ('5','Anna Karenina','YES','6543','CMP',16,'2000'),
				   ('6','Animal Farm','NO','4567','HOR',2,'2002'),
			       ('7','Dorian Gray','YES','7654','CMP',10,'2004'),
				   ('8','Catch-22','YES','5678','TRA',19,'2007'),
				   ('9','Don Quixote','YES','8765','PSY',14,'2007')

SELECT * FROM Book

INSERT INTO Wrote (ID_Book, ID_Author)
             VALUES (0,1),
			        (1,0),
					(2,2),
					(3,3),
			        (4,4),
					(5,5),
					(6,6),
			        (7,7),
					(8,8),
					(9,9)


SELECT * FROM Wrote

DELETE FROM Wrote

INSERT INTO Pub_Book (ID_Book, ID_Publisher)
            VALUES (0,'AA'),
			       (1,'AB'),
				   (2,'AC'),
				   (3,'AD'),
			       (4,'AE'),
				   (5,'AF'),
				   (6,'AG'),
			       (7,'AH'),
				   (8,'AI'),
				   (9,'AJ')


SELECT * FROM Pub_Book

INSERT INTO Inventory (ID_Inventory, ID_Branch, ID_Book, Units, On_Hand)
            VALUES (0,1,0,10,1),
			       (1,2,1,20,3),
				   (2,3,2,15,7),
				   (3,4,3,14,0),
			       (4,5,4,16,0),
				   (5,6,5,25,2),
				   (6,7,6,50,3),
			       (7,8,7,72,1),
				   (8,9,8,8,10),
				   (9,10,9,96,1)

DROP TABLE Inventory

SELECT * FROM Inventory

--8
SELECT Name FROM Publisher WHERE Location = 'Bucuresti';
--9
SELECT Name FROM Publisher WHERE Location != 'Bucuresti';
--10
SELECT Title, Book.Code FROM Book INNER JOIN  Pub_Book  ON Pub_Book.ID_Book = Book.ID INNER JOIN Publisher ON Publisher.ID = Pub_Book.ID_Publisher 
WHERE Publisher.Code = 'RH' OR _Type = 'HOR'
--11
SELECT Code, Title, Price FROM Book WHERE Price >= 20 and Price <= 30
--12
SELECT Code, Title, Price FROM Book WHERE Price >= 30
--13
SELECT Code, Title FROM Book WHERE _Type = 'ART' AND Price <= 20
--14
SELECT Code, Title FROM Book WHERE _Type = 'ART' AND Price >= 15
--15
SELECT Code, Title FROM Book WHERE Paperback = 'YES' AND Price >= 10

--16
SELECT ID, Title FROM Book WHERE _Type = 'TRA' OR _Type = 'CMP' OR _Type = 'PSY'
--17
SELECT SUM (NumberOfEmployees) AS TotalNumberOfEmployees FROM Branch
--18
SELECT Book.ID, Title, Price FROM Book JOIN Pub_Book ON Pub_Book.ID_Book = Book.ID JOIN
Publisher ON Publisher.ID = Pub_Book.ID_Publisher WHERE Publisher.Name = 'Tor Books'
--19
SELECT Book.ID, Title, Price FROM Book JOIN Pub_Book ON Pub_Book.ID_Book = Book.ID JOIN
Publisher ON Publisher.ID = Pub_Book.ID_Publisher WHERE Publisher.Name = 'Tor Books' AND Book.Price < 15
--20
SELECT COUNT (ID), PublicationDate AS [CountByYear]  FROM Book GROUP BY PublicationDate 
--21
CREATE FUNCTION BooksForACertainBranch
	(
		@wanted_branch VARCHAR(10)
	)
	RETURNS TABLE
	AS
	RETURN
    (SELECT Book.ID, Author.Name, Book.Title AS [Books on the current Branch] FROM Book
		INNER JOIN Wrote ON Wrote.ID_Book = Book.ID 
		INNER JOIN Author ON Author.ID = Wrote.ID_Author
		INNER JOIN Inventory ON Inventory.ID_Book = Book.ID
		INNER JOIN Branch ON Inventory.ID_Branch = Branch.ID
		WHERE Branch.Name = @wanted_branch
	
	)
DROP FUNCTION BooksForACertainBranch

SELECT * FROM BooksForACertainBranch('Roman')
SELECT * FROM BooksForACertainBranch('Clasic')

--22


CREATE FUNCTION BooksCount
	(
		@wanted_branch VARCHAR(10)
	)
	RETURNS TABLE
	AS
	RETURN
	(
	SELECT Author.Name, COUNT (Author.ID) as [Books Count] FROM Author
		INNER JOIN Wrote ON Author.ID = Wrote.ID_Author
		INNER JOIN Book ON Wrote.ID_Book = Book.ID 
		INNER JOIN Inventory ON Inventory.ID_Book = Book.ID
		INNER JOIN Branch ON Inventory.ID_Branch = Branch.ID
		WHERE Branch.Name = @wanted_branch
		GROUP BY Author.Name
	)

DROP FUNCTION BooksCount

SELECT * FROM BooksCount('Roman')
SELECT * FROM BooksCount('Clasic')


CREATE FUNCTION TotalBooksForAParticularAuthor
	(
		@wanted_author VARCHAR(20)
	)
	RETURNS TABLE
	AS
	RETURN
	(
    SELECT COUNT(Wrote.ID_Author) as [NumberOfBooksWrittenByTheAuthor] FROM Wrote
	INNER JOIN Author on Author.ID = Wrote.ID_Author 
	WHERE Author.Name = @wanted_author GROUP BY Author.Name
	)
	DROP FUNCTION TotalBooksForAParticularAuthor

SELECT * FROM TotalBooksForAParticularAuthor('Orwell')

--23
SELECT Title FROM Book INNER JOIN  Pub_Book  ON Pub_Book.ID_Book = Book.ID INNER JOIN Publisher ON Publisher.ID = Pub_Book.ID_Publisher 
WHERE Publisher.Name = 'Tor Books' OR _Type = 'PSY'   

--24
SELECT Title FROM Book INNER JOIN Wrote ON Wrote.ID_Book = Book.ID INNER JOIN Author ON Author.ID = Wrote.ID_Author 
WHERE Author.Name IN (SELECT Author.Name FROM Author WHERE Author.ID = '4')


--25 
SELECT Title, Book.Code FROM Book INNER JOIN  Pub_Book  ON Pub_Book.ID_Book = Book.ID INNER JOIN Publisher ON Publisher.ID = Pub_Book.ID_Publisher 
WHERE Price < 10 AND Publisher.Location = 'Vaslui'


--26 AND 27
CREATE FUNCTION BooksFromBranch
	(
		@wanted_branch VARCHAR(10)
	)
	RETURNS TABLE
	AS
	RETURN
	(
    SELECT Book.Code, Book.Title, Inventory.Units  AS [Books from Branch] FROM Book
		INNER JOIN Wrote ON Wrote.ID_Book = Book.ID 
		INNER JOIN Author ON Author.ID = Wrote.ID_Author
		INNER JOIN Inventory ON Inventory.ID_Book = Book.ID
	WHERE Inventory.ID_Branch = @wanted_branch
	)
--26
	SELECT * FROM BooksFromBranch(3)
--27
	SELECT * FROM BooksFromBranch(4)

--28
ALTER TABLE Inventory ADD Reorder_Num DECIMAL(1,0) NOT NULL DEFAULT '0';

SELECT * FROM Inventory

--29
UPDATE Inventory SET Reorder_Num = '1' WHERE On_Hand < 3

SELECT * FROM Inventory

--30
INSERT INTO Author (ID, Name)
            VALUES ('26','Ionica Mihai')

--31
INSERT INTO Book (ID, Title, Paperback, Code, _Type, Price,PublicationDate)
            VALUES ('2222','Philosopher''s Stone','YES','2222','III',20,'2000'),
				   ('3333','the Chamber of Secrets','YES','3333','III',20,'2000')

INSERT INTO Publisher (ID, Name, Location, Code)
            VALUES ('AK','TA','Bucuresti','RH'),
			       ('AL','TA','Cluj','HR')		
				   
INSERT INTO Pub_Book (ID_Book, ID_Publisher)
            VALUES (2222,'AK'),
			       (3333,'AL')

		   
--32
--FIRSTLY DELETE PUBLISHER/BOOK FIELD WHICH IS RELATED TO BOOK/PUBLISHER FIELD THROUGH PUB_BOOK
--THEN THE SPECIFIC PUB_BOOK FIELD USED FOR CONNECTION OF THOSE TWO TABLES IS AUTOMATICALLY DELETED

DELETE Publisher FROM Publisher INNER JOIN Pub_Book ON Pub_Book.ID_Publisher = Publisher.ID WHERE Pub_Book.ID_Book = '2222'
DELETE FROM Book WHERE ID = '2222'


SELECT * FROM Book
SELECT * FROM Publisher
SELECT * FROM Pub_Book

USE MASTER
GO

DROP DATABASE Homework1_Ionica_Mihai
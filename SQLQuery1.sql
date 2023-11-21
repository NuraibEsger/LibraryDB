﻿use LibraryDB
--Creating database
CREATE DATABASE LibraryDB

--Creating books table	
CREATE TABLE Books(
	Id INT PRIMARY KEY IDENTITY(1,1),
	Name VARCHAR(100) CHECK(LEN(Name) BETWEEN 2 AND 100) NOT NULL,
	PageCount INT CONSTRAINT PageCount CHECK (PageCount > 2) NOT NULL
)

--Adding values to books table
INSERT INTO Books
VALUES('Spare',416),
('Jadunama',52),
('Monsoon',400),
('Oluler',120),
('Xosrov ve Shirin',560),
('Leyli ve Mecnun',260),
('Jungle',116),
('Maral',86),
('Sheyda',212),
('Uchurum',120),
('Usta Zeynal',560),
('Rus qızı',260)

--Show all values of books table
SELECT * FROM Books

--Creating Authors table
CREATE TABLE Authors(
	Id INT PRIMARY KEY IDENTITY(10,1),
	Name VARCHAR(255) NOT NULL,
	Surname VARCHAR(255) NOT NULL
)

--Adding values to Authors table
INSERT INTO Authors
VALUES('Nizami', 'Gencevi'),
('Celil', 'Memmedquluzade'),
('Hüseyn', 'Cavid'),
('John','Moehringer'),
('Abhay','Khalil'),
('Kasturi','Ray')

--Show all values of the authors table
SELECT * FROM Authors

--Creating AuthorsBooksJuction table which is used for many to many table between books and authors
CREATE TABLE AuthorsBooksJuction(
	Id INT PRIMARY KEY IDENTITY(20,1),
	BooksId INT FOREIGN KEY REFERENCES Books(Id) NOT NULL,
	AuthorsId INT FOREIGN KEY REFERENCES Authors(Id) NOT NULL
)

--Linking Books and Authors tables
INSERT INTO AuthorsBooksJuction
VALUES(4,11),
(5,10),
(6,10),
(1,13),
(3,14),
(7,15),
(8,12),
(9,11),
(11,12),
(12,11)

--Show all values of AuthorsBooksJuction table
SELECT * FROM AuthorsBooksJuction


--Creating View for to show id of books, name of books, count of book's page, author's name
CREATE VIEW BookAuthorView AS
SELECT
    B.Id AS BookId,
    B.Name AS BookName,
    B.PageCount AS BookPageCount,
    A.Name AS AuthorName
FROM
    AuthorsBooksJuction ABJ
JOIN Books B ON ABJ.BooksId = B.Id
JOIN Authors A ON ABJ.AuthorsId = A.Id;

SELECT * FROM BookAuthorView;

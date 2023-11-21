--Creating database
CREATE DATABASE LibraryDB

GO

use LibraryDB
--Creating books table	
CREATE TABLE Books(
	Id INT PRIMARY KEY IDENTITY(1,1),
	Name VARCHAR(100) CHECK(LEN(Name) BETWEEN 2 AND 100) NOT NULL,
	PageCount INT CONSTRAINT PageCount CHECK (PageCount > 2) NOT NULL
)

--Creating Authors table
CREATE TABLE Authors(
	Id INT PRIMARY KEY IDENTITY(10,1),
	Name VARCHAR(255) NOT NULL,
	Surname VARCHAR(255) NOT NULL
)

--Creating AuthorsBooksJuction table which is used for many to many table between books and authors
CREATE TABLE AuthorsBooksJuction(
	Id INT PRIMARY KEY IDENTITY(20,1),
	BooksId INT FOREIGN KEY REFERENCES Books(Id) NOT NULL,
	AuthorsId INT FOREIGN KEY REFERENCES Authors(Id) NOT NULL
)

GO

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

--Adding values to Authors table
INSERT INTO Authors
VALUES('Nizami', 'Gencevi'),
('Celil', 'Memmedquluzade'),
('Hüseyn', 'Cavid'),
('John','Moehringer'),
('Abhay','Khalil'),
('Kasturi','Ray')

--Show all values of books table
SELECT * FROM Books

--Show all values of the authors table
SELECT * FROM Authors

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

GO

--This View is used for to show id of books, name of books, count of book's page, author's name
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

GO

SELECT * FROM BookAuthorView;

GO
--This procedure is used for show the books.id, books.name, books.pagecount, author's fullname by author's name
CREATE PROCEDURE GetBooksByAuthorName
    @AuthorName VARCHAR(255)
AS
BEGIN
    SELECT
        B.Id AS BookId,
        B.Name AS BookName,
        B.PageCount,
        A.Name + ' ' + A.Surname AS FullName
    FROM
        Books B
    INNER JOIN
        AuthorsBooksJuction ABJ ON B.Id = ABJ.BooksId
    INNER JOIN
        Authors A ON ABJ.AuthorsId = A.Id
    WHERE
        A.Name = @AuthorName;
END;

--Show the all books by author's name
EXEC GetBooksByAuthorName 'Nizami'

GO

--This Procedure is used for inserting datas to Authors table
CREATE PROCEDURE InsertAuthors
	@AuthorName VARCHAR(255),
	@AuthorSurname VARCHAR(255)
AS
BEGIN
	INSERT INTO Authors
	VALUES(@AuthorName, @AuthorSurname)

	SELECT * FROM Authors
END

GO

EXEC InsertAuthors 'Nuraib','Esgerov'

GO

--This Procedure is used for updating datas in Authors table
CREATE PROCEDURE UpdateAuthors
	@AuthorId INT,
	@AuthorName VARCHAR(255),
	@AuthorSurname VARCHAR(255)
AS
BEGIN
	Update Authors
	SET Name = @AuthorName, Surname = @AuthorSurname
	WHERE Authors.Id = @AuthorId
	SELECT * FROM Authors
END

GO

EXEC UpdateAuthors 16, 'Zilish', 'Zulfiqarli'

GO

--This Procedure is used for deleting datas from Authors table
CREATE PROCEDURE DeleteAuthors
	@AuthorId INT
AS
BEGIN
	Delete from Authors WHERE Authors.Id = @AuthorId
	SELECT * FROM Authors
END

GO

EXEC DeleteAuthors 16

GO

--This View is used for show us the author's id, author's fullname, max count of author's books , max count of page
CREATE VIEW AuthorBooksView AS
SELECT
    A.Id AS AuthorId,
    A.Name + ' ' + A.Surname AS FullName,
    COUNT(ABJ.BooksId) AS BooksCount,
    MAX(B.PageCount) AS MaxPageCount
FROM
    Authors A
INNER JOIN
    AuthorsBooksJuction ABJ ON A.Id = ABJ.AuthorsId
INNER JOIN
    Books B ON ABJ.BooksId = B.Id
GROUP BY
    A.Id, A.Name, A.Surname;

GO
SELECT * FROM AuthorBooksView
create database Library_db
use Library_db

CREATE TABLE Category (
    Category_ID INT PRIMARY KEY,
    Category_Name VARCHAR(50) NOT NULL
);

CREATE TABLE Book (
    Book_ID INT PRIMARY KEY,
    Title VARCHAR(100) NOT NULL,
    Author VARCHAR(100) NOT NULL,
    Category_ID INT,
    CONSTRAINT FK_Category FOREIGN KEY (Category_ID) REFERENCES Category(Category_ID)
);

CREATE TABLE [User] (
    User_ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    UserType VARCHAR(20) NOT NULL -- Assuming two user types: Student or Teacher
);

CREATE TABLE Issue (
    Issue_ID INT PRIMARY KEY,
    Book_ID INT,
    User_ID INT,
    Issue_Date DATE NOT NULL,
    Return_Date DATE,
    Fine_Amount DECIMAL(10,2),
    CONSTRAINT FK_Book FOREIGN KEY (Book_ID) REFERENCES Book(Book_ID),
    CONSTRAINT FK_User FOREIGN KEY (User_ID) REFERENCES [User] (User_ID),
    CONSTRAINT CK_ReturnDate CHECK (Return_Date >= Issue_Date),
    CONSTRAINT CK_FineAmount CHECK (Fine_Amount >= 0)
);

CREATE TABLE Fine (
    Fine_ID INT PRIMARY KEY,
    Issue_ID INT,
    Fine_Amount DECIMAL(10,2) NOT NULL,
    Fine_Reason VARCHAR(255),
    CONSTRAINT FK_Issue FOREIGN KEY (Issue_ID) REFERENCES Issue(Issue_ID)
);

CREATE TABLE Author (
    Author_ID INT PRIMARY KEY,
    Author_Name VARCHAR(100) NOT NULL
);

CREATE TABLE Publisher (
    Publisher_ID INT PRIMARY KEY,
    Publisher_Name VARCHAR(100) NOT NULL
);

CREATE TABLE BookCopy (
    Copy_ID INT PRIMARY KEY,
    Book_ID INT,
    Publisher_ID INT,
    Copy_Status VARCHAR(20) NOT NULL, -- Status of the book copy (e.g., available, issued)
    CONSTRAINT FK_BookCopy_Book FOREIGN KEY (Book_ID) REFERENCES Book(Book_ID),
    CONSTRAINT FK_BookCopy_Publisher FOREIGN KEY (Publisher_ID) REFERENCES Publisher(Publisher_ID)
);


ALTER TABLE Book
ADD Author_ID INT,
CONSTRAINT FK_Book_Author FOREIGN KEY (Author_ID) REFERENCES Author(Author_ID);


--- List Of A Books Issue By User

CREATE PROCEDURE GetIssuedBooks
    @UserID  INT
AS
BEGIN
    SELECT b.Title, b.Author, i.Issue_Date, i.Return_Date
    FROM Issue i
    INNER JOIN Book b ON i.Book_ID = b.Book_ID
    WHERE i.User_ID = @UserID;
END;

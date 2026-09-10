-- ===================
-- DATENBANK-SETUP
-- ===================

-- Alte Datenbank löschen
DROP DATABASE IF EXISTS bookexchange;

-- Neue Datenbank erstellen
CREATE DATABASE bookexchange CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Verwenden der neuen Datenbank
USE bookexchange;

-- ================================
-- DATENBANK-TABELLEN ERSTELLEN
-- ================================

-- Erstellen der User-Rollen-Tabelle
CREATE TABLE Roles (
    RoleId INTEGER AUTO_INCREMENT PRIMARY KEY,
    Role VARCHAR(50) NOT NULL, 
    Description VARCHAR(100) 
);

-- Einfügen der 2 Standard-User-Rollen
INSERT INTO Roles (Role, Description)
VALUES
    ('User', 'Kann Bücher suchen und einstellen, Leihanfragen stellen, Verleihen, etc.'),
    ('Administrator', 'Verwaltung der Datenbank');

-- Erstellen der Städte-Tabelle
CREATE TABLE Cities (
    CityId INTEGER AUTO_INCREMENT PRIMARY KEY,
    City VARCHAR(200) NOT NULL,
    PostCode VARCHAR(5) NOT NULL
);


-- Erstellen der User-Tabelle
CREATE TABLE Users (
    UserId INTEGER AUTO_INCREMENT PRIMARY KEY,
    Email VARCHAR(200) NOT NULL UNIQUE,
    Password VARCHAR(50) NOT NULL,
    Name VARCHAR(200) NOT NULL,
    Address VARCHAR(200),
    CityId INTEGER NOT NULL,
    RoleId INTEGER NOT NULL,
    RegistrationDate DATETIME NOT NULL,
    UserState VARCHAR(30) NOT NULL DEFAULT 'Active',

    FOREIGN KEY (CityId)
        REFERENCES Cities(CityId),

    FOREIGN KEY (RoleId)
        REFERENCES Roles(RoleId)
);

-- Erstellen der Autoren-Tabelle
CREATE TABLE Authors (
    AuthorId INTEGER AUTO_INCREMENT PRIMARY KEY,
    Author VARCHAR(200) NOT NULL
);

-- Erstellen der Publisher-Tabelle
CREATE TABLE Publishers (
    PublisherId INTEGER AUTO_INCREMENT PRIMARY KEY,
    Publisher VARCHAR(200) NOT NULL
);


-- Erstellen der Sprachen-Tabelle
CREATE TABLE Languages (
    LanguageId INTEGER AUTO_INCREMENT PRIMARY KEY,
    Language VARCHAR(50) NOT NULL
);


-- Erstellen der Genre-Tabelle
CREATE TABLE Genres (
    GenreId INTEGER AUTO_INCREMENT PRIMARY KEY,
    Genre VARCHAR(100) NOT NULL
);


-- Erstellen der Book-Tabelle
CREATE TABLE Books (
    BookId INTEGER AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(200) NOT NULL,
    Description VARCHAR(500),
    ISBN VARCHAR(17),
    PublisherId INTEGER,
    LanguageId INTEGER,
    MaxBorrowTime INTEGER NOT NULL,
    OwnerId INTEGER NOT NULL,

    FOREIGN KEY (PublisherId)
        REFERENCES Publishers(PublisherId),

    FOREIGN KEY (LanguageId)
        REFERENCES Languages(LanguageId),

    FOREIGN KEY (OwnerId)
        REFERENCES Users(UserId)
        ON DELETE CASCADE 
);

-- Erstellen der Book-Autor-Beziehungstabelle
CREATE TABLE BookAuthors (
    BookId INTEGER NOT NULL,
    AuthorId INTEGER NOT NULL,

    PRIMARY KEY (BookId, AuthorId),

    FOREIGN KEY (BookId)
        REFERENCES Books(BookId)
        ON DELETE CASCADE,

    FOREIGN KEY (AuthorId)
        REFERENCES Authors(AuthorId)
);

-- Erstellen der Book-Genre-Beziehungstabelle
CREATE TABLE BookGenres (
    BookId INTEGER NOT NULL,
    GenreId INTEGER NOT NULL,

    PRIMARY KEY (BookId, GenreId),

    FOREIGN KEY (BookId)
        REFERENCES Books(BookId)
        ON DELETE CASCADE,

    FOREIGN KEY (GenreId)
        REFERENCES Genres(GenreId)
);

-- Erstellen der BorrowRequests-Tabelle
CREATE TABLE BorrowRequests (
    BorrowRequestId INTEGER AUTO_INCREMENT PRIMARY KEY,

    UserId INTEGER NOT NULL,
    BookId INTEGER NOT NULL,

    PickupWindowStart DATETIME NOT NULL,
    PickupWindowEnd DATETIME NOT NULL,
    RequestedUntilTime DATETIME NOT NULL,
    RequestTime DATETIME NOT NULL,

    BorrowRequestState VARCHAR(30) NOT NULL,

    FOREIGN KEY (UserId)
        REFERENCES Users(UserId)
        ON DELETE CASCADE,

    FOREIGN KEY (BookId)
        REFERENCES Books(BookId)
        ON DELETE CASCADE 
);

-- Erstellen der Borrows-Tabelle
CREATE TABLE Borrows (
    BorrowId INTEGER AUTO_INCREMENT PRIMARY KEY,

    OwnerId INTEGER NOT NULL,
    BorrowerId INTEGER NOT NULL,
    BookId INTEGER NOT NULL,

    PickupLocation VARCHAR(200) NOT NULL,
    PickupWindowStart DATETIME NOT NULL,
    PickupWindowEnd DATETIME NOT NULL,

    ReturnLocation VARCHAR(200),
    ReturnWindowStart DATETIME,
    ReturnWindowEnd DATETIME,

    BorrowState VARCHAR(30) NOT NULL,

    FOREIGN KEY (OwnerId)
        REFERENCES Users(UserId),

    FOREIGN KEY (BorrowerId)
        REFERENCES Users(UserId),

    FOREIGN KEY (BookId)
        REFERENCES Books(BookId)
        ON DELETE CASCADE 
);

-- Erstellen der Valuations-Tabelle
CREATE TABLE Valuations (
    ValuationId INTEGER AUTO_INCREMENT PRIMARY KEY,
    BookId INTEGER NOT NULL,
    UserId INTEGER NOT NULL,
    Grade INTEGER NOT NULL,
    Comment VARCHAR(500),
    ValuationTime DATETIME NOT NULL,

    FOREIGN KEY (BookId)
        REFERENCES Books(BookId)
        ON DELETE CASCADE ,

    FOREIGN KEY (UserId)
        REFERENCES Users(UserId)
        ON DELETE CASCADE 
);

-- Erstellen der Complaints-Tabelle
CREATE TABLE Complaints (
    ComplaintId INTEGER AUTO_INCREMENT PRIMARY KEY,
    Complaint VARCHAR(500) NOT NULL,
    BookId INTEGER,
    ComplaintUserId INTEGER NOT NULL,
    ComplainerUserId INTEGER NOT NULL,
    ComplaintTime DATETIME NOT NULL,

    FOREIGN KEY (BookId)
        REFERENCES Books(BookId)
        ON DELETE CASCADE ,

    FOREIGN KEY (ComplaintUserId)
        REFERENCES Users(UserId)
        ON DELETE CASCADE,

    FOREIGN KEY (ComplainerUserId)
        REFERENCES Users(UserId)
        ON DELETE CASCADE 
);

-- ========================
-- Testdaten einfügen
-- ========================

-- Einfügen von 10 Beispiel-Städten
INSERT INTO Cities (City, PostCode)
VALUES
    ('Berlin', '10115'),
    ('Hamburg', '20095'),
    ('München', '80331'),
    ('Köln', '50667'),
    ('Frankfurt', '60311'),
    ('Stuttgart', '70173'),
    ('Dresden', '01067'),
    ('Leipzig', '04109'),
    ('Hannover', '30159'),
    ('Bremen', '28195');

-- Einfügen von 10 Beispiel-Usern
INSERT INTO Users
    (Email, Password, Name, Address, CityId, RoleId, RegistrationDate, UserState)
VALUES
    ('art.vandelay@vandalay-industries.com', 'password1', 'Art Vandelay', 'Hauptstraße 12', 1, 1, '2026-01-10 09:15:00', 'Active'),
    ('h.e.pennypacker@pennypecker-imports.com', 'password2', 'H.E. Pennypacker', 'Bahnhofstraße 5', 2, 1, '2026-01-12 10:30:00', 'Active'),
    ('kel.varnsen@varnsen-inc.com', 'password3', 'Kel Varnsen', 'Gartenstraße 8', 3, 1, '2026-01-15 14:20:00', 'Active'),
    ('george.costanza@example.com', 'password4', 'George Costanza', 'Schulstraße 21', 4, 1, '2026-01-20 11:45:00', 'Active'),
    ('elaine.benes@example.com', 'password5', 'Elaine Benes', 'Ringstraße 3', 5, 1, '2026-02-01 08:10:00', 'Active'),
    ('cosmo.kramer@example.com', 'password6', 'Cosmo Kramer', 'Dorfstraße 17', 6, 1, '2026-02-05 16:30:00', 'Active'),
    ('fdr@example.com', 'password7', 'Franklin Delano Romanowsky', 'Parkweg 4', 7, 1, '2026-02-10 12:00:00', 'Active'),
    ('jerry.seinfeld@example.com', 'password8', 'Jerry Seinfeld', 'Waldstraße 19', 8, 1, '2026-02-15 13:25:00', 'Active'),
    ('j.peterman@example.com', 'password9', 'J. Peterman', 'Marktplatz 2', 9, 1, '2026-02-20 09:50:00', 'Active'),
    ('kenny.bania@example.com', 'password10', 'Kenny Bania', 'Mozartstraße 10', 10, 2, '2026-02-25 17:15:00', 'Active');

-- Einfügen von 10 Beispiel-Autoren
INSERT INTO Authors (Author)
VALUES
    ('J.R.R. Tolkien'),
    ('George Orwell'),
    ('Frank Herbert'),
    ('J.K. Rowling'),
    ('Isaac Asimov'),
    ('Agatha Christie'),
    ('Stephen King'),
    ('Ernest Hemingway'),
    ('Douglas Adams'),
    ('Terry Pratchett'),
    ('Stephen Baxter'),
    ('Lee Child'),
    ('Cixin Liu'),
    ('Rita Falk');

-- Einfügen von 10 Beispiel-Publishers
INSERT INTO Publishers (Publisher)
VALUES
    ('Penguin Books'),
    ('Random House'),
    ('HarperCollins'),
    ('Bloomsbury'),
    ('Tor Books'),
    ('Simon & Schuster'),
    ('Macmillan Publishers'),
    ('Oxford University Press'),
    ('Fischer Verlag'),
    ('Suhrkamp Verlag'),
    ('Blanvalet'),
    ('Heine'),
    ('dtv'),
    ('Martha Wells');   

-- Einfügen von 10 Beispiel-Sprachen
INSERT INTO Languages (Language)
VALUES
    ('Deutsch'),
    ('Englisch'),
    ('Französisch'),
    ('Spanisch'),
    ('Italienisch'),
    ('Portugiesisch'),
    ('Niederländisch'),
    ('Schwedisch'),
    ('Polnisch'),
    ('Japanisch');

-- Einfügen von 10 Beispiel-Genres
INSERT INTO Genres (Genre)
VALUES
    ('Fantasy'),
    ('Science-Fiction'),
    ('Krimi'),
    ('Thriller'),
    ('Horror'),
    ('Abenteuer'),
    ('Roman'),
    ('Komödie'),
    ('Sachbuch'),
    ('Drama');

-- Einfügen von 10 Beispiel-Büchern
INSERT INTO Books
    (Name, Description, ISBN, PublisherId, LanguageId, MaxBorrowTime, OwnerId)
VALUES
    ('Der Bluthund', 'Ein Jack-Reacher-Roman.', '9783734110771', 11, 2, 30, 1),
    ('1984', 'Dystopischer Roman über einen totalitären Staat. Ein Science-Fiction-Klassiker.', '9780451524935', 2, 2, 14, 2),
    ('Der Herr der Ringe', 'Epische Fantasy-Trilogie mit Elben, Zwergen, Orks, und natürlich den Hobbits.', '9780261102385', 1, 2, 30, 3),
    ('Dune', 'Ein Antikriegs-Roman auf dem Wüstenplaneten Arrakis, in einer düsteren Science-Fiction-Zukunft.', '9780441172719', 5, 2, 21, 4),
    ('Die Drei Sonnen', 'Das Schicksal der gesamten Menschheit steht auf dem Spiel. Galaktischer Sci-Fi-Roman aus China.', '9783453317161', 12, 2, 14, 5),
    ('Foundation', 'Science-Fiction-Klassiker über die Zukunft der Menschheit.', '9780553293357', 2, 2, 21, 6),
    ('Weißwurst-Connection', 'Kultige Krimikomödie mit dem Komissar Franz Eberhofer.', '9783423261272', 13, 2, 14, 7),
    ('Es', 'Horrorroman über eine unheimliche Kreatur.', '9781501142970', 6, 1, 30, 7),
    ('Per Anhalter durch die Galaxis', 'Absolut durchgeknallte Reise quer durch die Galaxis. Herrlich schwarzer Humor.', '9780345391803', 7, 2, 21, 8),
    ('Wachen! Wachen!', 'Fantasy-Komödie aus der Scheibenwelt. Kult!', '9780552131070', 10, 2, 14, 8),
    ('Der lange Krieg', 'Science-Fiction aus der Langwelt. Voller verrückter Ideen! Die Reise geht weiter!', '9783442547289', 2, 2, 14, 9),
    ('Tagebuch eines Killerbots', 'Der Beginn der Killerbot-Reise... bekannt aus der erfolgreichen Serie!', '9783453320345', 12, 2, 14, 10);

-- Einfügen von 10 Beziehungen von Book -> Autor
INSERT INTO BookAuthors (BookId, AuthorId)
VALUES
    (1, 12),
    (2, 2),
    (3, 1),
    (4, 3),
    (5, 13),
    (6, 5),
    (7, 14),
    (8, 7),
    (9, 9),
    (10, 10),
    (11, 10),
    (11, 11),
    (12, 14);

-- Einfügen von 10 Beziehungen von Book -> Genre
INSERT INTO BookGenres (BookId, GenreId)
VALUES
    (1, 3),
    (2, 7),
    (2, 2),
    (3, 1),
    (4, 2),
    (5, 2),
    (6, 2),
    (7, 3),
    (8, 5),
    (9, 8),
    (9, 2),
    (10, 8),
    (10, 1),
    (11, 1),
    (11, 2),
    (12, 2),
    (12, 8);

-- Einfügen von 10 Beispiel-Leihanfragen
INSERT INTO BorrowRequests
    (UserId, BookId, PickupWindowStart, PickupWindowEnd,
     RequestedUntilTime, RequestTime, BorrowRequestState)
VALUES
    (2, 1, '2026-08-26 17:00:00', '2026-08-26 19:00:00', '2026-08-30 23:59:59', '2026-08-25 09:00:00', 'Pending'),
    (3, 2, '2026-08-27 16:00:00', '2026-08-27 18:00:00', '2026-08-31 23:59:59', '2026-08-25 09:30:00', 'Accepted'),
    (4, 3, '2026-08-28 15:00:00', '2026-08-28 17:00:00', '2026-09-01 23:59:59', '2026-08-25 10:00:00', 'Pending'),
    (5, 4, '2026-08-29 14:00:00', '2026-08-29 16:00:00', '2026-09-02 23:59:59', '2026-08-25 10:30:00', 'Rejected'),
    (6, 5, '2026-08-30 13:00:00', '2026-08-30 15:00:00', '2026-09-03 23:59:59', '2026-08-25 11:00:00', 'Pending'),
    (7, 6, '2026-08-31 17:00:00', '2026-08-31 19:00:00', '2026-09-04 23:59:59', '2026-08-25 11:30:00', 'Accepted'),
    (8, 7, '2026-09-01 16:00:00', '2026-09-01 18:00:00', '2026-09-05 23:59:59', '2026-08-25 12:00:00', 'Pending'),
    (9, 8, '2026-09-02 15:00:00', '2026-09-02 17:00:00', '2026-09-06 23:59:59', '2026-08-25 12:30:00', 'Rejected'),
    (10, 9, '2026-09-03 14:00:00', '2026-09-03 16:00:00', '2026-09-07 23:59:59', '2026-08-25 13:00:00', 'Pending'),
    (1, 10, '2026-09-04 13:00:00', '2026-09-04 15:00:00', '2026-09-08 23:59:59', '2026-08-25 13:30:00', 'Accepted');

-- Einfügen von 10 Beispiel-Leihungen
INSERT INTO Borrows
    (OwnerId, BorrowerId, BookId,
     PickupLocation, PickupWindowStart, PickupWindowEnd,
     ReturnLocation, ReturnWindowStart, ReturnWindowEnd,
     BorrowState)
VALUES
    (1, 2, 1,
     'Berlin Hauptbahnhof', '2026-08-26 17:00:00', '2026-08-26 19:00:00',
     'Berlin Hauptbahnhof', '2026-09-20 17:00:00', '2026-09-20 19:00:00',
     'Active'),

    (2, 3, 2,
     'Hamburg Hauptbahnhof', '2026-08-27 16:00:00', '2026-08-27 18:00:00',
     'Hamburg Hauptbahnhof', '2026-09-10 16:00:00', '2026-09-10 18:00:00',
     'Returned'),

    (3, 4, 3,
     'München Marienplatz', '2026-08-28 15:00:00', '2026-08-28 17:00:00',
     'München Marienplatz', '2026-09-25 15:00:00', '2026-09-25 17:00:00',
     'Active'),

    (4, 5, 4,
     'Köln Dom', '2026-08-29 14:00:00', '2026-08-29 16:00:00',
     'Köln Dom', '2026-09-19 14:00:00', '2026-09-19 16:00:00',
     'Active'),

    (5, 6, 5,
     'Frankfurt Hauptbahnhof', '2026-08-30 13:00:00', '2026-08-30 15:00:00',
     'Frankfurt Hauptbahnhof', '2026-09-13 13:00:00', '2026-09-13 15:00:00',
     'Returned'),

    (6, 7, 6,
     'Stuttgart Schlossplatz', '2026-08-31 17:00:00', '2026-08-31 19:00:00',
     'Stuttgart Schlossplatz', '2026-09-21 17:00:00', '2026-09-21 19:00:00',
     'Active'),

    (7, 8, 7,
     'Dresden Neustadt', '2026-09-01 16:00:00', '2026-09-01 18:00:00',
     'Dresden Neustadt', '2026-09-15 16:00:00', '2026-09-15 18:00:00',
     'Active'),

    (8, 9, 8,
     'Leipzig Markt', '2026-09-02 15:00:00', '2026-09-02 17:00:00',
     'Leipzig Markt', '2026-10-02 15:00:00', '2026-10-02 17:00:00',
     'Active'),

    (9, 10, 9,
     'Hannover Kröpcke', '2026-09-03 14:00:00', '2026-09-03 16:00:00',
     'Hannover Kröpcke', '2026-09-24 14:00:00', '2026-09-24 16:00:00',
     'Active'),

    (10, 1, 10,
     'Bremen Marktplatz', '2026-09-04 13:00:00', '2026-09-04 15:00:00',
     'Bremen Marktplatz', '2026-09-18 13:00:00', '2026-09-18 15:00:00',
     'Returned');

-- Einfügen von 10 Beispiel-Buchbewertungen
INSERT INTO Valuations
    (BookId, UserId, Grade, Comment, ValuationTime)
VALUES
    (1, 2, 5, 'Sehr gutes Buch, liest sich gut weg ... guter Zustand.', '2026-08-20 10:00:00'),
    (2, 3, 4, 'Sehr interessant und gut geschrieben. Am Ende ein bisschen Längen...', '2026-08-21 11:00:00'),
    (3, 4, 5, 'Ein Klassiker :)', '2026-08-21 14:00:00'),
    (4, 5, 5, 'Sehr empfehlenswert.', '2026-08-22 09:30:00'),
    (5, 6, 4, 'Guter Zustand.', '2026-08-22 12:00:00'),
    (6, 7, 5, 'Sehr spannende Geschichte, aber Charaktere etwas platt.', '2026-08-23 10:15:00'),
    (7, 8, 4, 'Guter Krimi.', '2026-08-23 13:00:00'),
    (8, 9, 5, 'Spannend und gut erhalten.', '2026-08-24 09:00:00'),
    (9, 10, 5, 'Sehr lustig, und manchmal sehr überdreht :)', '2026-08-24 12:30:00'),
    (10, 1, 4, 'Unterhaltsam und humorvoll!', '2026-08-24 15:00:00');

-- Einfügen von 10 Beispiel-Beschwerden
INSERT INTO Complaints
    (Complaint, BookId, ComplaintUserId, ComplainerUserId, ComplaintTime)
VALUES
    ('Der Typ kam viel zu spät!! Was soll das?', 1, 2, 1, '2026-08-20 09:00:00'),
    ('Buch war stärker beschädigt als behauptet.', 2, 3, 2, '2026-08-20 11:00:00'),
    ('Abholtermin wurde überhaupt nicht eingehalten!', 3, 4, 3, '2026-08-21 10:30:00'),
    ('Rückgabe erfolgte viel zu spät!!!', 4, 5, 4, '2026-08-21 14:00:00'),
    ('Beschreibung des Buchzustands war nicht unbedingt ... vollständig ;)', 5, 6, 5, '2026-08-22 09:45:00'),
    ('Übergabeort wurde seeehr kurzfristig geändert.', 6, 7, 6, '2026-08-22 13:15:00'),
    ('Buch wurde nicht zum vereinbarten Zeitpunkt übergeben.', 7, 8, 7, '2026-08-23 10:00:00'),
    ('Rückgabeort wurde nicht eingehalten, auf nix kann man sich verlassen!', 8, 9, 8, '2026-08-23 16:00:00'),
    ('Buch war scheinbar nicht verfügbar.', 9, 10, 9, '2026-08-24 11:00:00'),
    ('Abholung wurde ohne Absprache abgesagt, bin voll enttäuscht.', 10, 1, 10, '2026-08-24 14:30:00');

-- ==========================================
-- Test Cases für User: User-Verwaltung
-- ==========================================

-- User anlegen -> Registrierung
INSERT INTO Users (Email, Password, Name, Address, CityId, RoleId, RegistrationDate, UserState)
VALUES ('joe.davola@example.com', 'password11', 'Joe Davola', 'Lindenstraße 15', 1, 1, NOW(), 'Active');

SET @new_user_id = LAST_INSERT_ID();

-- Userprofil ändern
UPDATE Users
SET Name = 'Crazy Joe Davola', Address = 'Sonnenallee 42', CityId = 2
WHERE UserId = @new_user_id;

-- ==========================================
-- Test Cases für User: Bücherverwaltung
-- ==========================================

-- Buch anlegen
INSERT INTO Books (Name, Description, ISBN, PublisherId, LanguageId, MaxBorrowTime, OwnerId)
VALUES ('Neuromancer', 'Sci-Fi Klassiker von William Gibson.', '9780441569564', 1, 2, 21, 2);

SET @test_book_id = LAST_INSERT_ID();

-- Genre und Autor verknüpfen
INSERT INTO BookAuthors (BookId, AuthorId) VALUES (@test_book_id, 2);
INSERT INTO BookGenres (BookId, GenreId) VALUES (@test_book_id, 2);

-- Buch ändern
UPDATE Books
SET Description = 'Aktualisierte Beschreibung: Ein absoluter Cyberpunk-Klassiker.', MaxBorrowTime = 28
WHERE BookId = @test_book_id;

-- Buch löschen
DELETE FROM Books
WHERE BookId = @test_book_id;

-- ==========================================
-- Test Cases für User: Buch ausleihen
-- ==========================================

-- Ausleihanfrage stellen (User 3 fragt Buch 4 bei User 4 an)
INSERT INTO BorrowRequests (UserId, BookId, PickupWindowStart, PickupWindowEnd, RequestedUntilTime, RequestTime, BorrowRequestState)
VALUES (3, 4, '2026-09-01 10:00:00', '2026-09-01 12:00:00', '2026-09-15 23:59:59', NOW(), 'Pending');

SET @borrow_request_id = LAST_INSERT_ID();

-- Status der Anfrage auf 'Accepted' setzen
UPDATE BorrowRequests
SET BorrowRequestState = 'Accepted'
WHERE BorrowRequestId = @borrow_request_id;

-- Buch tatsächlich ausleihen (Eintrag in Borrows-Tabelle erstellen)
INSERT INTO Borrows (OwnerId, BorrowerId, BookId, PickupLocation, PickupWindowStart, PickupWindowEnd, BorrowState)
VALUES (4, 3, 4, 'Köln Dom', '2026-09-01 10:00:00', '2026-09-01 12:00:00', 'Active');

SET @active_borrow_id = LAST_INSERT_ID();

-- Buch zurückgeben
UPDATE Borrows
SET ReturnLocation = 'Köln Dom',
    ReturnWindowStart = '2026-09-15 10:00:00',
    ReturnWindowEnd = '2026-09-15 12:00:00',
    BorrowState = 'Returned'
WHERE BorrowId = @active_borrow_id;

-- ==================================================
-- Test Cases für User: Bewertung und Beschwerden 
-- ==================================================

-- Buch bewerten
INSERT INTO Valuations (BookId, UserId, Grade, Comment, ValuationTime)
VALUES (4, 3, 5, 'Super Abwicklung und genialer Roman!', NOW());

-- Beschwerden abgeben
INSERT INTO Complaints (Complaint, BookId, ComplaintUserId, ComplainerUserId, ComplaintTime)
VALUES ('Das Buch hatte Flecken auf Seite 20.', 4, 4, 3, NOW());

-- ==================================================
-- Test Cases für User: Suchanfragen für Bücher
-- ==================================================

-- Suche nach Buchtitel, Genre oder Autor (z. B. nach "Fantasy" oder "Tolkien")
SELECT DISTINCT
    b.BookId,
    b.Name AS BookTitle,
    a.Author,
    g.Genre,
    l.Language,
    u.Name AS Owner
FROM Books b
LEFT JOIN BookAuthors ba ON b.BookId = ba.BookId
LEFT JOIN Authors a ON ba.AuthorId = a.AuthorId
LEFT JOIN BookGenres bg ON b.BookId = bg.BookId
LEFT JOIN Genres g ON bg.GenreId = g.GenreId
LEFT JOIN Languages l ON b.LanguageId = l.LanguageId
LEFT JOIN Users u ON b.OwnerId = u.UserId
WHERE
    u.UserState = 'Active'
    AND (
        b.Name LIKE '%Herr der Ringe%'
        OR a.Author LIKE '%Tolkien%'
        OR g.Genre LIKE '%Fantasy%'
    );

-- zeige alle Bücher
-- (mehrere Autoren und Genres werden in einer kommaseparierten Liste zusammengefasst)
SELECT
    b.Name AS Book,
    GROUP_CONCAT(DISTINCT a.Author ORDER BY a.Author SEPARATOR ', ') AS Authors,
    GROUP_CONCAT(DISTINCT g.Genre ORDER BY g.Genre SEPARATOR ', ') AS Genres
FROM Books b
LEFT JOIN BookAuthors ba
    ON b.BookId = ba.BookId
LEFT JOIN Authors a
    ON ba.AuthorId = a.AuthorId
LEFT JOIN BookGenres bg
    ON b.BookId = bg.BookId
LEFT JOIN Genres g
    ON bg.GenreId = g.GenreId
GROUP BY
    b.BookId,
    b.Name;

-- Zeige alle gerade verliehenen Bücher.
SELECT
    Books.Name AS Book,
    Owner.Name AS Owner,
    Borrower.Name AS Borrower,
    Borrows.BorrowState
FROM Borrows
JOIN Books
    ON Borrows.BookId = Books.BookId
JOIN Users AS Owner
    ON Borrows.OwnerId = Owner.UserId
JOIN Users AS Borrower
    ON Borrows.BorrowerId = Borrower.UserId
WHERE Borrows.BorrowState = 'Active';

-- Zeige alle Bücher von allen Usern
SELECT
    Books.Name AS Book,
    Users.Name AS Owner
FROM Books
JOIN Users
    ON Books.OwnerId = Users.UserId
WHERE Users.UserState = 'Active';

-- ==========================================
-- Test Cases für Admin: User sperren
-- ==========================================

-- User durch Admin sperren
UPDATE Users
SET UserState = 'Banned'
WHERE UserId = @new_user_id;

-- alle Anfragen des gesperrten Users auf Bücher abbrechen
UPDATE BorrowRequests
SET BorrowRequestState = 'Cancelled'
WHERE UserId = @new_user_id
  AND BorrowRequestState = 'Pending';

-- alle Anfragen auf Bücher des gesperrten Users abbrechen
UPDATE BorrowRequests br
JOIN Books b
    ON br.BookId = b.BookId
SET br.BorrowRequestState = 'Cancelled'
WHERE b.OwnerId = @new_user_id
  AND br.BorrowRequestState = 'Pending';

-- gesperrten User anzeigen
SELECT
    UserId,
    Name,
    RoleId,
    UserState
FROM Users
WHERE UserId = @new_user_id;

-- ==========================================
-- Test Cases für Admin: User löschen
-- ==========================================

-- User durch Admin komplett löschen 
-- (nur wenn keine Borrows existieren - BorrowRequests werden automatisch gelöscht)
DELETE FROM Users 
WHERE UserId = @new_user_id;

-- ==========================================
-- Test Cases für Admin: Buch löschen
-- ==========================================

-- Buch löschen
DELETE FROM Books
WHERE BookId = 8;

-- ================================================
-- Test Cases für Admin: Beschwerden verwalten
-- ================================================

-- Offenen Beschwerden einsehen inklusive Details zu Buch, Beschwerdeführer und Beschuldigtem
SELECT 
    c.ComplaintId,
    c.Complaint,
    c.ComplaintTime,
    b.Name AS BookTitle,
    complainer.Name AS Complainer,
    complained_user.Name AS ComplainedUser
FROM Complaints c
LEFT JOIN Books b ON c.BookId = b.BookId
JOIN Users complainer ON c.ComplainerUserId = complainer.UserId
JOIN Users complained_user ON c.ComplaintUserId = complained_user.UserId;

-- Beschwerde bearbeiten/löschen
DELETE FROM Complaints
WHERE ComplaintId = 1;

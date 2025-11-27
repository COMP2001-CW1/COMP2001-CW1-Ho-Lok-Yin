-- TrailService

CREATE TABLE TrailService (
    TrailID varchar(100) NOT NULL PRIMARY KEY,
    TrailName varchar(100) NOT NULL,
    TrailDescription text DEFAULT NULL,
    TrailLength decimal(4,1) DEFAULT NULL,
    TrailTime varchar(20) DEFAULT NULL,
    TrailPoint varchar(20) DEFAULT NULL CHECK (TrailPoint IN ('Loop', 'Point to Point', 'Out and Back')),
    TrailDifficulty varchar(20) DEFAULT NULL CHECK (TrailDifficulty IN ('Easy', 'Moderate', 'Hard'))
);
INSERT INTO TrailService (TrailID,TrailName,TrailDescription,TrailLength,TrailTime,TrailPoint,TrailDifficulty)VALUES
('e1d80825-b296-4e20-8cf0-8b4ba2f1b6db','Plymbridge Circular','Scenic woodland trail with viaduct views',5.0,'1.5 - 2','Loop','Easy');

SELECT * FROM TrailService;

-- AccountService---------------------------------

CREATE TABLE AccountService (
  UserID VARCHAR(100) NOT NULL PRIMARY KEY,
  UserName VARCHAR(100) NOT NULL,
  UserEmail VARCHAR(100) NOT NULL UNIQUE,
  UserPassword VARCHAR(100) NOT NULL
);

INSERT INTO AccountService (UserID, UserName, UserEmail, UserPassword) VALUES
('059bd893-6263-4ac8-9eb9-0d4357bee819', 'Grace Hopper', 'grace@plymouth.ac.uk', 'ISAD123!');
INSERT INTO AccountService (UserID, UserName, UserEmail, UserPassword) VALUES
('062b436c-6496-48b5-9a89-5df6cfe914c5', 'Testing', 'Testing@karzaf.live', 'P@ssw0rd');

SELECT * FROM AccountService;

-- ProfileService---------------------------------

CREATE TABLE ProfileService (
  LogID VARCHAR(100) NOT NULL PRIMARY KEY,
  UserID VARCHAR(100) NOT NULL,
  UserSetting NVARCHAR(MAX) DEFAULT NULL,
  UserDescription NVARCHAR(MAX) DEFAULT NULL,
  UserRole VARCHAR(20) DEFAULT 'User' CHECK (UserRole IN ('Admin', 'User')),
  FOREIGN KEY (UserID) REFERENCES AccountService(UserID)
);

INSERT INTO ProfileService (LogID,UserID,UserSetting,UserDescription,UserRole) VALUES
('a084a8f-e60a-434a-9ef3-e795a3941e0','059bd893-6263-4ac8-9eb9-0d4357bee819',
  '{
    "preferredTrailType": "Loop",
    "difficultyLevel": "Easy",
    "dogFriendly": true,
    "parking": "Free",
    "estimatedTime": "1.5 - 2 hours",
    "features": ["River","Viaduct Views","Woodland","Wildlife","Historic Railway"]
  }',
  'I enjoy peaceful woodland walks with scenic views and wildlife. Plymbridge Circular is ideal for its riverside paths, viaduct crossings, and historic railway charm.',
  'Admin');
  
  SELECT * FROM BadgeService;
  
-- BadgeService---------------------------------


CREATE TABLE BadgeService (
  RecordID VARCHAR(100) NOT NULL PRIMARY KEY,
  UserID VARCHAR(100) NOT NULL,
  TrailID VARCHAR(100) NOT NULL,
  Badge VARCHAR(100) NULL,
  UserCounter INT DEFAULT 0,
  AwardedDate DATETIME DEFAULT GETDATE(),
  FOREIGN KEY (UserID) REFERENCES AccountService(UserID),
  FOREIGN KEY (TrailID) REFERENCES TrailService(TrailID)
);

INSERT INTO BadgeService (RecordID,UserID,TrailID,Badge,UserCounter,AwardedDate) VALUES 
('46fc84c8-eb63-414d-8487-db3b74cb0ee3','059bd893-6263-4ac8-9eb9-0d4357bee819','e1d80825-b296-4e20-8cf0-8b4ba2f1b6db','Hiking Badge',127,'2025-11-22 06:19:00');

SELECT * FROM BadgeService;

-- LinkedDataService---------------------------------

CREATE TABLE LinkedDataService (
  LinkedID VARCHAR(100) NOT NULL PRIMARY KEY,
  UserID VARCHAR(100) NOT NULL,
  LinkedName VARCHAR(100) NOT NULL,
  LinkedData NVARCHAR(MAX) DEFAULT NULL,
  LinkedURL VARCHAR(255) DEFAULT NULL,
  FOREIGN KEY (UserID) REFERENCES AccountService(UserID)
);

INSERT INTO LinkedDataService (LinkedID,UserID,LinkedName,LinkedData,LinkedURL) VALUES 
('8268972-863a-4329-b58f-b408153cb4b1','059bd893-6263-4ac8-9eb9-0d4357bee819','Instagram','Connect with us','https://www.instagram.com/alltrails/');

SELECT * FROM LinkedDataService;

-- CommentsService---------------------------------

CREATE TABLE CommentsService (
  CommentID VARCHAR(100) NOT NULL PRIMARY KEY,
  UserID VARCHAR(100) NOT NULL,
  TrailID VARCHAR(100) NOT NULL,
  Comments NVARCHAR(MAX) NOT NULL,
  CommentsTime DATETIME DEFAULT GETDATE(),
  CommentsLog NVARCHAR(MAX) DEFAULT NULL,
  FOREIGN KEY (UserID) REFERENCES AccountService(UserID),
  FOREIGN KEY (TrailID) REFERENCES TrailService(TrailID)
);

INSERT INTO CommentsService (CommentID,UserID,TrailID,Comments,CommentsTime,CommentsLog) VALUES 
('4b6de2e1-ad47-443a-aec5-dd5bd83dc705','059bd893-6263-4ac8-9eb9-0d4357bee819','e1d80825-b296-4e20-8cf0-8b4ba2f1b6db',
'Easy to try this trail, good for beginners. Loved the viaduct views and peaceful woodland.','2025-11-22 08:00:00',
'[2025-11-22 08:00:00] [Grace Hopper] added a comment');

SELECT * FROM CommentsService;

-- RecommentsService---------------------------------

CREATE TABLE RecommentsService (
  RecommentsID VARCHAR(100) NOT NULL PRIMARY KEY,
  UserID VARCHAR(100) NOT NULL,
  TrailID VARCHAR(100) NOT NULL,
  Recomments NVARCHAR(MAX) NOT NULL,
  RecommentsTime DATETIME DEFAULT GETDATE(),
  RecommentsLog NVARCHAR(MAX) DEFAULT NULL,
  FOREIGN KEY (UserID) REFERENCES AccountService(UserID),
  FOREIGN KEY (TrailID) REFERENCES TrailService(TrailID)
);

INSERT INTO RecommentsService (RecommentsID,UserID,TrailID,Recomments,RecommentsTime,RecommentsLog) VALUES 
('a8b036d2-42c5-440c-9002-b1324eaa31a7','059bd893-6263-4ac8-9eb9-0d4357bee819','e1d80825-b296-4e20-8cf0-8b4ba2f1b6db',
  'If the app added a button to create a clock time counter for each trail, that would be convenient.',
  '2025-11-22 08:00:00','[2025-11-22 08:00:00] [Grace Hopper] Recomments: “If the app added a button to create a clock time counter for each trail, that would be convenient.”');

SELECT * FROM RecommentsService;

-- Views---------------------------------

CREATE VIEW AllTableViews AS
SELECT 
    t.TrailID,t.TrailName,t.TrailDescription,t.TrailLength,t.TrailTime,t.TrailPoint,t.TrailDifficulty,
    a.UserID,a.UserName,a.UserEmail,
    p.UserRole,p.UserDescription,p.UserSetting,
    b.Badge,b.UserCounter,b.AwardedDate,
    l.LinkedName,l.LinkedURL,
    c.CommentID,c.Comments,c.CommentsTime,c.CommentsLog,r.RecommentsID,
    r.Recomments,r.RecommentsTime,r.RecommentsLog
FROM TrailService t
INNER JOIN BadgeService b ON t.TrailID = b.TrailID
INNER JOIN AccountService a ON b.UserID = a.UserID
LEFT JOIN ProfileService p ON a.UserID = p.UserID
LEFT JOIN LinkedDataService l ON a.UserID = l.UserID
LEFT JOIN CommentsService c ON t.TrailID = c.TrailID
LEFT JOIN RecommentsService r ON t.TrailID = r.TrailID;

SELECT * FROM AllTableViews;

-- Trigger--------------------------------------------------------

CREATE TABLE ProfileServiceLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    UserID VARCHAR(100),
    UserRole VARCHAR(20) CHECK (UserRole IN ('Admin', 'User')),
    Action VARCHAR(50),
    Timestamp DATETIME DEFAULT GETDATE());

CREATE TRIGGER ProfileServiceLogging
ON ProfileService
AFTER INSERT
AS
BEGIN
    INSERT INTO ProfileServiceLog (UserID, UserRole, Action)
    SELECT UserID, UserRole, 'INSERT'
    FROM inserted;
END;

INSERT INTO ProfileService (LogID, UserID, UserSetting, UserDescription, UserRole)VALUES 
('95cdb557-5703-4aba-9cb7-c274b8876348','062b436c-6496-48b5-9a89-5df6cfe914c5','{"preferredTrailType":"Loop"}','Test logging','User');

SELECT * FROM ProfileServiceLog;

---


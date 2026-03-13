/*
====================================================
RapidRelief Australia Disaster Response Database
Database Script
Author: Group 09 
Purpose: Create database tables and sample data for disaster response
====================================================
*/

-- Create Database RapidReliefDB --

DROP DATABASE IF EXISTS RapidReliefDB;
CREATE DATABASE RapidReliefDB;
USE RapidReliefDB;

-- Create tables for RapidReliefDB --

-- Create EVENT Table --

CREATE TABLE EVENT (
    EventID INT NOT NULL,
    DisasterType VARCHAR(20) NOT NULL,
    EvSuburb VARCHAR(50) NOT NULL,
    EvState CHAR(3) NOT NULL,
    EvStartDate DATE NOT NULL,
    EvEndDate DATE,
    EvSeverity VARCHAR(6) NOT NULL,

    PRIMARY KEY (EventID),

    -- Create a Constraint for EvState --
    CONSTRAINT chk_evstate 
        CHECK (EvState IN ('VIC','NSW','QLD','SA','WA','TAS','ACT','NT')), 

    -- Create a Constraint for EvSeverity --
    CONSTRAINT chk_evseverity 
        CHECK (EvSeverity IN ('Low','Medium','High')) 
);

-- Create SKILL Table --

CREATE TABLE SKILL (
    SkillID INT NOT NULL,
    SkillName VARCHAR(50) NOT NULL,

    PRIMARY KEY (SkillID)
);

-- Create VOLUNTEER Table --

CREATE TABLE VOLUNTEER (
    VolunteerID INT NOT NULL,
    VolFName VARCHAR(50) NOT NULL,
    VolLName VARCHAR(50) NOT NULL,
    VolPhone CHAR(10) NOT NULL,
    VolEmail VARCHAR(100) NOT NULL,
    VolSuburb VARCHAR(50) NOT NULL,
    VolState CHAR(3) NOT NULL,
    VolActiveStatus VARCHAR(10) NOT NULL,

    PRIMARY KEY (VolunteerID),

    -- Create a Constraint for VolState --
    CONSTRAINT chk_vol_state
        CHECK (VolState IN ('ACT','NSW','NT','QLD','SA','TAS','VIC','WA')), 

    -- Create a Constraint for VolActiveStatus --
    CONSTRAINT chk_vol_status
        CHECK (VolActiveStatus IN ('Active','Inactive')) 
);

-- Create ITEM Table --

CREATE TABLE ITEM (
    ItemID INT NOT NULL,
    ItemName VARCHAR(50) NOT NULL,
    ItemUnit VARCHAR(10) NOT NULL,

    PRIMARY KEY (ItemID) 
);

-- Create TASK Table --

CREATE TABLE TASK (
    TaskID INT NOT NULL,
    EventID INT NOT NULL,
    SkillID INT,
    TaskType VARCHAR(30) NOT NULL,
    TaskPriority VARCHAR(9) NOT NULL,
    TaskStatus VARCHAR(10) NOT NULL,
    TaskStartDate DATE NOT NULL,
    TaskDueDate DATE,

    PRIMARY KEY (TaskID),

    -- Create a Constraint for EventID Foreign Key --
    CONSTRAINT fk_task_event
        FOREIGN KEY (EventID) 
        REFERENCES EVENT(EventID),

    -- Create a Constraint for SkillID Foreign Key --
    CONSTRAINT fk_task_skill
        FOREIGN KEY (SkillID) 
        REFERENCES SKILL(SkillID),

    -- Create a Constraint for TaskPriority --
    CONSTRAINT chk_task_priority
        CHECK (TaskPriority IN ('Immediate','Urgent','Standard')), 

    -- Create a Constraint for TaskStatus --
    CONSTRAINT chk_task_status
        CHECK (TaskStatus IN ('Pending','Active','Completed')) 
);

-- Create REQUEST Table --

CREATE TABLE REQUEST (
    RequestID INT NOT NULL,
    EventID INT NOT NULL,
    TaskID INT,
    RequestType VARCHAR(20) NOT NULL,
    RequestStatus VARCHAR(15) NOT NULL,
    RequestDate DATE NOT NULL,
    ReqSuburb VARCHAR(50) NOT NULL,
    ReqContactName VARCHAR(60) NOT NULL,
    ReqContactPhone CHAR(10) NOT NULL,

    PRIMARY KEY (RequestID),

    -- Create a Constraint for EventID Foreign Key --
    CONSTRAINT fk_request_event
        FOREIGN KEY (EventID)
        REFERENCES EVENT(EventID),

    -- Create a Constraint for TaskID Foreign Key --
    CONSTRAINT fk_request_task
        FOREIGN KEY (TaskID)
        REFERENCES TASK(TaskID),

    -- Create a Constraint for RequestType --
    CONSTRAINT chk_request_type
        CHECK (RequestType IN ('Food','Shelter','Medical','Transport')), 

    -- Create a Constraint for RequestStatus --
    CONSTRAINT chk_request_status
        CHECK (RequestStatus IN ('New','In Progress','Completed')) 
);

-- Create PACKAGE Table --

CREATE TABLE PACKAGE (
    PackageID INT NOT NULL,
    EventID INT NOT NULL,
    PackageType VARCHAR(20) NOT NULL,
    PreparedDate DATE NOT NULL,
    PackWeightKg DECIMAL(5,2) NOT NULL,

    PRIMARY KEY (PackageID),

    -- Create a Constraint for EventID Foreign Key --
    CONSTRAINT fk_package_event
        FOREIGN KEY (EventID)
        REFERENCES EVENT(EventID),

    -- Create a Constraint for PackageType --
    CONSTRAINT chk_package_type
        CHECK (PackageType IN ('Family Kit','Medical Kit','Hygiene Kit')), 
    -- Create a Constraint for PackWeightKg --
    CONSTRAINT chk_package_weight
        CHECK (PackWeightKg BETWEEN 0.00 AND 999.99) 
);

-- Create VOLUNTEER_SKILL Table --

CREATE TABLE VOLUNTEER_SKILL (
    VolunteerID INT NOT NULL,
    SkillID INT NOT NULL,

    PRIMARY KEY (VolunteerID, SkillID),

    -- Create a Constraint for VolunteerID Foreign Key --
    CONSTRAINT fk_vs_volunteer
        FOREIGN KEY (VolunteerID)
        REFERENCES VOLUNTEER(VolunteerID)
        ON DELETE CASCADE,

    -- Create a Constraint for SkillID Foreign Key --
    CONSTRAINT fk_vs_skill
        FOREIGN KEY (SkillID)
        REFERENCES SKILL(SkillID)
        ON DELETE CASCADE 
);

-- Create TASK_VOLUNTEER Table --

CREATE TABLE TASK_VOLUNTEER (
    TaskID INT NOT NULL,
    VolunteerID INT NOT NULL,

    PRIMARY KEY (TaskID, VolunteerID),

    -- Create a Constraint for TaskID Foreign Key --
    CONSTRAINT fk_tv_task
        FOREIGN KEY (TaskID)
        REFERENCES TASK(TaskID)
        ON DELETE CASCADE,

    -- Create a Constraint for VolunteerID Foreign Key --
    CONSTRAINT fk_tv_volunteer
        FOREIGN KEY (VolunteerID)
        REFERENCES VOLUNTEER(VolunteerID)
        ON DELETE CASCADE
);

-- Create PACKAGE_ITEM Table --

CREATE TABLE PACKAGE_ITEM (
    PackageID INT NOT NULL,
    ItemID INT NOT NULL,
    PackItemQuantity INT NOT NULL,

    PRIMARY KEY (PackageID, ItemID),

    -- Create a Constraint for packageID Foreign Key --
    CONSTRAINT fk_pi_package
        FOREIGN KEY (PackageID)
        REFERENCES PACKAGE(PackageID)
        ON DELETE CASCADE,

    -- Create a Constraint for ItemID Foreign Key --
    CONSTRAINT fk_pi_item
        FOREIGN KEY (ItemID)
        REFERENCES ITEM(ItemID)
        ON DELETE CASCADE,

    -- Create a Constraint for PackItemQuantity --
    CONSTRAINT chk_pack_item_qty
        CHECK (PackItemQuantity BETWEEN 1 AND 999) 
 
);


-- Sample data for RapidReliefDB --

-- Sample data for EVENT table --
INSERT INTO EVENT (EventID, DisasterType, EvSuburb, EvState, EvStartDate, EvEndDate, EvSeverity) VALUES
(100001, 'Flood',     'Shepparton', 'VIC', '2026-05-01', NULL,         'High'),
(100002, 'Bushfire',  'Ballarat',   'VIC', '2026-04-10', '2026-04-18', 'Medium'),
(100003, 'Cyclone',   'Cairns',     'QLD', '2026-05-03', NULL,         'High'),
(100004, 'Flood',     'Lismore',    'NSW', '2026-03-20', '2026-03-28', 'Low');

-- Sample data for SKILL table --
INSERT INTO SKILL (SkillID, SkillName) VALUES
(200001, 'First Aid'),
(200002, 'Boat Licence'),
(200003, 'Heavy Vehicle Licence'),
(200004, 'Translation - Nepali'),
(200005, 'Logistics');

-- Sample data for VOLUNTEER table --
INSERT INTO VOLUNTEER (VolunteerID, VolFName, VolLName, VolPhone, VolEmail, VolSuburb, VolState, VolActiveStatus) VALUES
(300001, 'Kavish',   'Perera',    '0412345678', 'kavish.perera@email.com',   'Shepparton', 'VIC', 'Active'),
(300002, 'Nimali',   'Fernando',  '0423456789', 'nimali.fernando@email.com', 'Melbourne',  'VIC', 'Active'),
(300003, 'Ayesha',   'Khan',      '0434567890', 'ayesha.khan@email.com',     'Cairns',     'QLD', 'Active'),
(300004, 'Rohan',    'Silva',     '0445678901', 'rohan.silva@email.com',     'Ballarat',   'VIC', 'Inactive'),
(300005, 'Dilshan',  'Fernando',  '0456789012', 'dilshan.f@email.com',       'Bendigo',    'VIC', 'Active'),
(300006, 'Saman',    'Jayasinghe','0467890123', 'saman.j@email.com',         'Lismore',    'NSW', 'Active');

-- Sample data for ITEM table --
INSERT INTO ITEM (ItemID, ItemName, ItemUnit) VALUES
(400001, 'Water',         'bottles'),
(400002, 'Blanket',       'pieces'),
(400003, 'First Aid Kit', 'packs'),
(400004, 'Hygiene Soap',  'packs'),
(400005, 'Canned Food',   'packs');

-- Sample data for TASK table --
INSERT INTO TASK (TaskID, EventID, SkillID, TaskType, TaskPriority, TaskStatus, TaskStartDate, TaskDueDate) VALUES
(500001, 100001, 200002, 'Flood Rescue',        'Immediate', 'Active',    '2026-05-01', '2026-05-03'),
(500002, 100001, 200001, 'Medical Support',     'Urgent',    'Pending',   '2026-05-02', '2026-05-04'),
(500003, 100001, 200005, 'Supply Distribution', 'Standard',  'Pending',   '2026-05-03', NULL),
(500004, 100003, 200004, 'Translation Support', 'Urgent',    'Active',    '2026-05-04', '2026-05-06'),
(500005, 100002, 200003, 'Vehicle Transport',   'Standard',  'Completed', '2026-04-11', '2026-04-13'),
(500006, 100003, NULL,   'Evacuation Setup',    'Immediate', 'Pending',   '2026-05-05', NULL);

-- Sample data for REQUEST table --
INSERT INTO REQUEST (RequestID, EventID, TaskID, RequestType, RequestStatus, RequestDate, ReqSuburb, ReqContactName, ReqContactPhone) VALUES
(600001, 100001, 500003, 'Food',      'In Progress', '2026-05-01', 'Shepparton', 'Amara Silva',   '0471111111'),
(600002, 100001, NULL,   'Medical',   'New',         '2026-05-02', 'Shepparton', 'Nuwan Peris',   '0472222222'),
(600003, 100003, 500004, 'Transport', 'Completed',   '2026-05-03', 'Cairns',     'Mala Devi',     '0473333333'),
(600004, 100003, NULL,   'Shelter',   'New',         '2026-05-04', 'Cairns',     'Suresh Rai',    '0474444444'),
(600005, 100002, 500005, 'Food',      'Completed',   '2026-04-11', 'Ballarat',   'Peter Collins', '0475555555');

-- Sample data for PACKAGE table --
INSERT INTO PACKAGE (PackageID, EventID, PackageType, PreparedDate, PackWeightKg) VALUES
(700001, 100001, 'Family Kit',  '2026-05-01', 25.50),
(700002, 100001, 'Medical Kit', '2026-05-02', 12.75),
(700003, 100003, 'Hygiene Kit', '2026-05-04', 10.20),
(700004, 100001, 'Family Kit',  '2026-05-03', 24.10),
(700005, 100002, 'Medical Kit', '2026-04-12', 11.00);

-- Sample data for VOLUNTEER_SKILL table --
INSERT INTO VOLUNTEER_SKILL (VolunteerID, SkillID) VALUES
(300001, 200002), 
(300001, 200001), 
(300002, 200001), 
(300002, 200005), 
(300003, 200004), 
(300004, 200003),
(300005, 200001), 
(300006, 200005); 

-- Sample data for TASK_VOLUNTEER table --
INSERT INTO TASK_VOLUNTEER (TaskID, VolunteerID) VALUES
(500001, 300001),
(500001, 300003),
(500002, 300002),
(500002, 300005),
(500003, 300006),
(500004, 300003),
(500005, 300001);

-- Sample data for PACKAGE_ITEM table --
INSERT INTO PACKAGE_ITEM (PackageID, ItemID, PackItemQuantity) VALUES
(700001, 400001, 24), 
(700001, 400002, 4),  
(700001, 400005, 6),  
(700002, 400003, 5),  
(700002, 400001, 12), 
(700003, 400004, 8),  
(700003, 400001, 10), 
(700004, 400001, 20),
(700004, 400002, 3),
(700005, 400003, 4);
-- Database Schema for Student Advising System
-- Drop tables if they exist to ensure a clean setup
DROP TABLE IF EXISTS AdvisingSessions;
DROP TABLE IF EXISTS MilestonesProgress;
DROP TABLE IF EXISTS Milestones;
DROP TABLE IF EXISTS CourseEnrollment;
DROP TABLE IF EXISTS CourseData;
DROP TABLE IF EXISTS StudentInformation;
DROP TABLE IF EXISTS AdvisorInformation;
DROP TABLE IF EXISTS Programs;
DROP TABLE IF EXISTS Departments;


-- Department Table
CREATE TABLE Departments (
    DepartmentID INT AUTO_INCREMENT PRIMARY KEY,
    DepartmentName VARCHAR(255) NOT NULL UNIQUE,
    DepartmentHead VARCHAR(255), -- Optional: Name or ID of the department head
    OfficeLocation VARCHAR(255)  -- Optional: Location of the department office
);

-- Program Table
CREATE TABLE Programs (
    ProgramID INT AUTO_INCREMENT PRIMARY KEY,
    ProgramName VARCHAR(255) NOT NULL,
    DepartmentID INT,
    DegreeType VARCHAR(50), -- e.g., Bachelor, Master, PhD
    RequiredCredits INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Advisor Information Table [cite: 25, 26]
CREATE TABLE AdvisorInformation (
    AdvisorID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Role VARCHAR(100), -- e.g., Faculty Advisor, Staff Advisor [cite: 26]
    ContactInformation VARCHAR(255), -- e.g., email or phone [cite: 26]
    DepartmentID INT, -- Link advisor to a department
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Student Information Table [cite: 22, 23]
CREATE TABLE StudentInformation (
    StudentID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    ProgramID INT, -- Foreign key to Programs table [cite: 24]
    EnrollmentDate DATE, -- Date when the student enrolled [cite: 24]
    ExpectedGraduationDate DATE,
    DegreeProgress TEXT, -- Detailed notes on progress [cite: 23, 24]
    ContactInformation VARCHAR(255), -- e.g., email, phone [cite: 23]
    AssignedAdvisorID INT, -- Foreign key linking student to their advisor [cite: 28]
    FOREIGN KEY (ProgramID) REFERENCES Programs(ProgramID),
    FOREIGN KEY (AssignedAdvisorID) REFERENCES AdvisorInformation(AdvisorID)
);


-- Course Data Table [cite: 32, 33]
-- Note: Populated partially by api_fetcher.py from an external source
CREATE TABLE CourseData (
    CourseCode VARCHAR(20) PRIMARY KEY, -- Unique course identifier [cite: 33]
    CourseName VARCHAR(255) NOT NULL,
    DepartmentID INT, -- Link course to a department [cite: 34]
    Credits INT, -- Number of credits the course is worth [cite: 34]
    Prerequisites TEXT, -- Description of prerequisites [cite: 33]
    AvailableSeats INT, -- Number of seats available [cite: 33]
    Description TEXT, -- Detailed course description [cite: 34]
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Course Enrollment Table (Many-to-Many relationship between Students and Courses) [cite: 44]
CREATE TABLE CourseEnrollment (
    EnrollmentID INT AUTO_INCREMENT PRIMARY KEY,
    StudentID INT,
    CourseCode VARCHAR(20),
    Semester VARCHAR(50), -- e.g., 'Fall 2024'
    Grade VARCHAR(2), -- e.g., 'A', 'B+', 'IP' (In Progress)
    EnrollmentDate DATE,
    FOREIGN KEY (StudentID) REFERENCES StudentInformation(StudentID),
    FOREIGN KEY (CourseCode) REFERENCES CourseData(CourseCode),
    UNIQUE KEY `student_course_semester` (`StudentID`,`CourseCode`,`Semester`) -- Prevent duplicate enrollment in the same semester
);


-- Advising Sessions Table [cite: 29, 30]
CREATE TABLE AdvisingSessions (
    SessionID INT AUTO_INCREMENT PRIMARY KEY,
    StudentID INT NOT NULL,
    AdvisorID INT NOT NULL,
    Date DATE NOT NULL,
    AdvisorNotes TEXT, -- Notes from the advisor [cite: 30]
    RecommendedCourses TEXT, -- Courses recommended during the session [cite: 30]
    FollowUpActions TEXT, -- Actions to be taken after the session [cite: 30]
    SessionOutcome VARCHAR(255), -- Summary of the outcome [cite: 30]
    FOREIGN KEY (StudentID) REFERENCES StudentInformation(StudentID), -- [cite: 31]
    FOREIGN KEY (AdvisorID) REFERENCES AdvisorInformation(AdvisorID) -- [cite: 31]
);

-- Milestones Table [cite: 35]
CREATE TABLE Milestones (
    MilestoneID INT AUTO_INCREMENT PRIMARY KEY,
    ProgramID INT, -- Link milestone to a specific program [cite: 36]
    MilestoneName VARCHAR(255) NOT NULL, -- e.g., Thesis Proposal, Internship, Comprehensive Exam [cite: 35]
    Description TEXT,
    DefaultDeadlineRule VARCHAR(255), -- e.g., 'End of 3rd Year', 'Start of Final Semester'
    FOREIGN KEY (ProgramID) REFERENCES Programs(ProgramID)
);

-- Student Milestones Progress Table (Tracks individual student progress on milestones) [cite: 36]
CREATE TABLE MilestonesProgress (
    ProgressID INT AUTO_INCREMENT PRIMARY KEY,
    StudentID INT NOT NULL,
    MilestoneID INT NOT NULL,
    CompletionDate DATE, -- Date the milestone was completed
    Status VARCHAR(50) DEFAULT 'Pending', -- e.g., Pending, In Progress, Completed, Waived
    Notes TEXT, -- Any relevant notes about this specific student's milestone progress
    FOREIGN KEY (StudentID) REFERENCES StudentInformation(StudentID),
    FOREIGN KEY (MilestoneID) REFERENCES Milestones(MilestoneID),
    UNIQUE KEY `student_milestone` (`StudentID`,`MilestoneID`) -- Ensure one record per student per milestone
);

-- Add Indexes for Performance [cite: 45, 46]
CREATE INDEX idx_student_name ON StudentInformation (Name);
CREATE INDEX idx_advisor_name ON AdvisorInformation (Name);
CREATE INDEX idx_course_name ON CourseData (CourseName);
CREATE INDEX idx_session_date ON AdvisingSessions (Date);
CREATE INDEX idx_milestone_program ON Milestones (ProgramID);
CREATE INDEX idx_milestone_progress_student ON MilestonesProgress (StudentID);
CREATE INDEX idx_enrollment_student ON CourseEnrollment (StudentID);
CREATE INDEX idx_enrollment_course ON CourseEnrollment (CourseCode);


-- End of Schema
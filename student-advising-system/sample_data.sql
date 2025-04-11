-- Sample Data for Student Advising System

-- Departments
INSERT INTO Departments (DepartmentName, DepartmentHead, OfficeLocation) VALUES
('Computer Science', 'Dr. Alan Turing', 'Tech Hall 101'),
('Mathematics', 'Dr. Ada Lovelace', 'Math Building 205'),
('Physics', 'Dr. Albert Einstein', 'Science Center 300');

-- Programs
INSERT INTO Programs (ProgramName, DepartmentID, DegreeType, RequiredCredits) VALUES
('B.S. in Computer Science', 1, 'Bachelor', 120),
('M.S. in Computer Science', 1, 'Master', 30),
('B.S. in Applied Mathematics', 2, 'Bachelor', 110),
('Ph.D. in Physics', 3, 'PhD', 60);

-- Advisors
INSERT INTO AdvisorInformation (Name, Role, ContactInformation, DepartmentID) VALUES
('Dr. Grace Hopper', 'Faculty Advisor', 'grace.hopper@college.edu', 1),
('Dr. John von Neumann', 'Faculty Advisor', 'john.vn@college.edu', 1),
('Prof. Emmy Noether', 'Staff Advisor', 'emmy.noether@college.edu', 2),
('Dr. Richard Feynman', 'Faculty Advisor', 'richard.feynman@college.edu', 3);

-- Students
INSERT INTO StudentInformation (Name, ProgramID, EnrollmentDate, ExpectedGraduationDate, DegreeProgress, ContactInformation, AssignedAdvisorID) VALUES
('Alice Smith', 1, '2022-09-01', '2026-05-15', 'Completed intro courses. Starting core sequence.', 'alice.s@student.college.edu', 1),
('Bob Johnson', 1, '2023-09-01', '2027-05-15', 'First year student.', 'bob.j@student.college.edu', 2),
('Charlie Brown', 3, '2021-09-01', '2025-05-15', 'Completed core math. Needs electives.', 'charlie.b@student.college.edu', 3),
('Diana Prince', 4, '2020-09-01', '2026-05-15', 'Working on dissertation proposal.', 'diana.p@student.college.edu', 4),
('Eve Adams', 2, '2024-01-15', '2025-12-15', 'Starting Master thesis research.', 'eve.a@student.college.edu', 1);

-- Courses (Some basic examples, more can be added via API fetcher)
INSERT INTO CourseData (CourseCode, CourseName, DepartmentID, Credits, Prerequisites, AvailableSeats, Description) VALUES
('CS101', 'Introduction to Programming', 1, 3, 'None', 50, 'Fundamentals of programming using Python.'),
('CS305', 'Data Structures and Algorithms', 1, 4, 'CS101', 30, 'Study of fundamental data structures and algorithms.'),
('MA201', 'Calculus II', 2, 4, 'Calculus I', 40, 'Techniques of integration, sequences, and series.'),
('PH210', 'Classical Mechanics', 3, 4, 'Calculus II, Intro Physics', 25, 'Newtonian mechanics, oscillations, and waves.');

-- Course Enrollment
INSERT INTO CourseEnrollment (StudentID, CourseCode, Semester, Grade, EnrollmentDate) VALUES
(1, 'CS101', 'Fall 2022', 'A', '2022-09-05'),
(1, 'MA201', 'Spring 2023', 'B+', '2023-01-20'),
(2, 'CS101', 'Fall 2023', 'A-', '2023-09-06'),
(3, 'MA201', 'Spring 2022', 'A', '2022-01-18'),
(1, 'CS305', 'Fall 2024', 'IP', '2024-09-04'); -- IP = In Progress

-- Advising Sessions
INSERT INTO AdvisingSessions (StudentID, AdvisorID, Date, AdvisorNotes, RecommendedCourses, FollowUpActions, SessionOutcome) VALUES
(1, 1, '2024-03-15', 'Discussed Fall 2024 schedule. Student is on track.', 'CS305, CS Elective', 'Register for Fall courses. Explore internship options.', 'Plan confirmed'),
(3, 3, '2024-04-01', 'Reviewed degree audit. Needs two more electives.', 'MA450 (Statistics), MA410 (Linear Algebra)', 'Submit graduation application next semester.', 'Graduation plan reviewed'),
(2, 2, '2023-10-20', 'First advising session. Discussed program structure and resources.', 'CS101 recommended resources', 'Attend CS club meeting. Meet with tutor for Calc I.', 'Initial plan set');

-- Milestones
INSERT INTO Milestones (ProgramID, MilestoneName, Description, DefaultDeadlineRule) VALUES
(1, 'Internship Completion', 'Complete a relevant internship.', 'End of 3rd Year'),
(1, 'Senior Project Proposal', 'Submit proposal for senior capstone project.', 'Start of Senior Year'),
(2, 'Thesis Defense', 'Successfully defend Master thesis.', 'End of 2nd Year'),
(4, 'Qualifying Exam', 'Pass the Physics qualifying examination.', 'End of 2nd Year'),
(4, 'Dissertation Defense', 'Successfully defend PhD dissertation.', 'End of 5th Year');

-- Student Milestones Progress
INSERT INTO MilestonesProgress (StudentID, MilestoneID, CompletionDate, Status, Notes) VALUES
(1, 1, NULL, 'Pending', 'Planning for Summer 2025'),
(1, 2, NULL, 'Pending', ''),
(4, 4, '2022-05-10', 'Completed', 'Passed on first attempt'),
(4, 5, NULL, 'In Progress', 'Working on dissertation draft'),
(5, 3, NULL, 'In Progress', 'Thesis topic approved');

-- End of Sample Data
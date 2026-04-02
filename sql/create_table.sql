	-- GROUP 1
	-- ACCOUNT
	CREATE TABLE ACCOUNT(
	accountID INT AUTO_INCREMENT PRIMARY KEY,
	accountName NATIONAL VARCHAR(100) NOT NULL,
	accountUsername VARCHAR(100) NOT NULL,
	accountEmail VARCHAR(100) NOT NULL,
	accountPassword VARCHAR(100) NOT NULL,
	accountRole ENUM('teacher', 'student') NOT NULL
	);

	-- SUBJECT
	CREATE TABLE SUBJECT (
	subjectID INT AUTO_INCREMENT PRIMARY KEY,
	subjectName NATIONAL VARCHAR(100) NOT NULL
	);
	
	-- =================================================
	
	-- GROUP 2
	-- ISA - SUBROLES
	CREATE TABLE TEACHER (
	accountID INT PRIMARY KEY,
	FOREIGN KEY (accountID) REFERENCES ACCOUNT(accountID)
	ON DELETE CASCADE
	);

	CREATE TABLE STUDENT(
	accountID INT PRIMARY KEY,
	FOREIGN KEY (accountID) REFERENCES ACCOUNT(accountID)
	ON DELETE CASCADE
	);

	-- QUESTION
	CREATE TABLE QUESTION (
	questionID INT AUTO_INCREMENT PRIMARY KEY,
	subjectID INT NOT NULL,
	questionDesc NATIONAL VARCHAR(2000) NOT NULL,
	questionDiff ENUM('easy', 'medium', 'hard') NOT NULL,
	questionType ENUM('contest', 'practice') NOT NULL,
	FOREIGN KEY (subjectID) REFERENCES subject(subjectID)
	ON DELETE CASCADE
	);

	-- =================================================
	
	-- GROUP 3
	-- ANSWER
	CREATE TABLE ANSWER(
	answerID INT AUTO_INCREMENT PRIMARY KEY,
	questionID INT NOT NULL,
	answerDesc NATIONAL VARCHAR(1000) NOT NULL,
	isCorrect BOOLEAN NOT NULL DEFAULT FALSE,
	FOREIGN KEY (questionID) REFERENCES QUESTION(questionID)
	ON DELETE CASCADE
	);
	
	-- EXAM
	CREATE TABLE EXAM(
	examID INT AUTO_INCREMENT PRIMARY KEY,
	subjectID INT NOT NULL,
	accountID INT NOT NULL, -- created BY a teacher
	examTitle NATIONAL VARCHAR(200) NOT NULL,
	examType ENUM('contest','practice') NOT NULL,
	examDuration INT, -- minutes
	startTime DATETIME,
	endTime DATETIME,
	maxAttempt INT DEFAULT 1, -- 1 for contest, >1 for practice
	FOREIGN KEY(subjectID) REFERENCES SUBJECT(subjectID) 
	ON DELETE CASCADE,
	FOREIGN KEY(accountID) REFERENCES teacher(accountID)
	);
	
	-- =================================================
	-- GROUP 4
	-- EXAM STRUCTURE
	CREATE TABLE EXAM_STRUCTURE (
	structureID INT AUTO_INCREMENT PRIMARY KEY,
	examID INT UNIQUE NOT NULL,
	totalEasy INT NOT NULL,
	totalMedium INT NOT NULL,
	totalHard INT NOT NULL,
	FOREIGN KEY (examID) REFERENCES EXAM(examID)
	ON DELETE CASCADE
	);


	-- EXAM_QUESTION
	CREATE TABLE EXAM_QUESTION(
	examID INT NOT NULL,
	questionID INT NOT NULL,
	questionOrder INT,
	PRIMARY KEY(examID, questionID),
	FOREIGN KEY(examID) REFERENCES EXAM(examID)
	ON DELETE CASCADE,
	FOREIGN KEY(questionID) REFERENCES QUESTION(questionID)
	ON DELETE CASCADE
	);

	-- EXAM ATTEMPT
	CREATE TABLE EXAM_ATTEMPT(
	attemptID INT AUTO_INCREMENT PRIMARY KEY,
	examID INT NOT NULL,
	accountID INT NOT NULL,
	startedTime DATETIME DEFAULT CURRENT_TIMESTAMP,
	submittedTime DATETIME,
	submitStatus ENUM('in_progress', 'submitted') DEFAULT 'in_progress',
	attemptNumber INT NOT NULL,
	FOREIGN KEY (examID) REFERENCES EXAM(examID)
	ON DELETE CASCADE,
	FOREIGN KEY (accountID) REFERENCES student(accountID)
	ON DELETE CASCADE
	);

	-- =================================================
	
	-- GROUP 5
	-- RESULT
	CREATE TABLE RESULT(
	resultID INT AUTO_INCREMENT PRIMARY KEY,
	attemptID INT NOT NULL,
	totalAnswer INT NOT NULL,
	correctAnswer INT NOT NULL,
	grade DECIMAL(5,2) DEFAULT 0,
	FOREIGN KEY (attemptID) REFERENCES EXAM_ATTEMPT(attemptID)
	ON DELETE CASCADE
	);

	-- DETAILED_RESULT
	CREATE TABLE DETAILED_RESULT(
	resultID INT NOT NULL,
	questionID INT NOT NULL,
	answerID INT, -- selectedAnswer
	isCorrect BOOLEAN,
	PRIMARY KEY(resultID, questionID),
	FOREIGN KEY(resultID) REFERENCES RESULT(resultID)
	ON DELETE CASCADE,
	FOREIGN KEY(questionID) REFERENCES QUESTION(questionID)
	ON DELETE CASCADE,
	FOREIGN KEY (answerID) REFERENCES ANSWER(answerID)
	);

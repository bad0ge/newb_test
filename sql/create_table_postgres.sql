-- GROUP 1
-- ACCOUNT
CREATE TABLE ACCOUNT(
    accountID SERIAL PRIMARY KEY,
    accountName VARCHAR(100) NOT NULL,
    accountUsername VARCHAR(100) NOT NULL,
    accountEmail VARCHAR(100) NOT NULL,
    accountPassword VARCHAR(100) NOT NULL,
    accountRole VARCHAR(20) CHECK (accountRole IN ('teacher', 'student')) NOT NULL
);

-- SUBJECT
CREATE TABLE SUBJECT (
    subjectID SERIAL PRIMARY KEY,
    subjectName VARCHAR(100) NOT NULL
);

-- =================================================

-- GROUP 2
-- ISA - SUBROLES
CREATE TABLE TEACHER (
    accountID INT PRIMARY KEY REFERENCES ACCOUNT(accountID) ON DELETE CASCADE
);

CREATE TABLE STUDENT(
    accountID INT PRIMARY KEY REFERENCES ACCOUNT(accountID) ON DELETE CASCADE
);

-- QUESTION
CREATE TABLE QUESTION (
    questionID SERIAL PRIMARY KEY,
    subjectID INT NOT NULL REFERENCES SUBJECT(subjectID) ON DELETE CASCADE,
    questionDesc TEXT NOT NULL,
    questionDiff VARCHAR(20) CHECK (questionDiff IN ('easy', 'medium', 'hard')) NOT NULL,
    questionType VARCHAR(20) CHECK (questionType IN ('contest', 'practice')) NOT NULL
);

-- =================================================

-- GROUP 3
-- ANSWER
CREATE TABLE ANSWER(
    answerID SERIAL PRIMARY KEY,
    questionID INT NOT NULL REFERENCES QUESTION(questionID) ON DELETE CASCADE,
    answerDesc TEXT NOT NULL,
    isCorrect BOOLEAN NOT NULL DEFAULT FALSE
);

-- EXAM
CREATE TABLE EXAM(
    examID SERIAL PRIMARY KEY,
    subjectID INT NOT NULL REFERENCES SUBJECT(subjectID) ON DELETE CASCADE,
    accountID INT NOT NULL REFERENCES TEACHER(accountID),
    examTitle VARCHAR(200) NOT NULL,
    examType VARCHAR(20) CHECK (examType IN ('contest', 'practice')) NOT NULL,
    examDuration INT, 
    startTime TIMESTAMP,
    endTime TIMESTAMP,
    maxAttempt INT DEFAULT 1 
);

-- =================================================
-- GROUP 4
-- EXAM STRUCTURE
CREATE TABLE EXAM_STRUCTURE (
    structureID SERIAL PRIMARY KEY,
    examID INT UNIQUE NOT NULL REFERENCES EXAM(examID) ON DELETE CASCADE,
    totalEasy INT NOT NULL,
    totalMedium INT NOT NULL,
    totalHard INT NOT NULL
);

-- EXAM_QUESTION
CREATE TABLE EXAM_QUESTION(
    examID INT NOT NULL REFERENCES EXAM(examID) ON DELETE CASCADE,
    questionID INT NOT NULL REFERENCES QUESTION(questionID) ON DELETE CASCADE,
    questionOrder INT,
    PRIMARY KEY(examID, questionID)
);

-- EXAM ATTEMPT
CREATE TABLE EXAM_ATTEMPT(
    attemptID SERIAL PRIMARY KEY,
    examID INT NOT NULL REFERENCES EXAM(examID) ON DELETE CASCADE,
    accountID INT NOT NULL REFERENCES STUDENT(accountID) ON DELETE CASCADE,
    startedTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    submittedTime TIMESTAMP,
    submitStatus VARCHAR(20) DEFAULT 'in_progress' CHECK (submitStatus IN ('in_progress', 'submitted')),
    attemptNumber INT NOT NULL
);

-- =================================================

-- GROUP 5
-- RESULT
CREATE TABLE RESULT(
    resultID SERIAL PRIMARY KEY,
    attemptID INT NOT NULL REFERENCES EXAM_ATTEMPT(attemptID) ON DELETE CASCADE,
    totalAnswer INT NOT NULL,
    correctAnswer INT NOT NULL,
    grade NUMERIC(5,2) DEFAULT 0
);

-- DETAILED_RESULT
CREATE TABLE DETAILED_RESULT(
    resultID INT NOT NULL REFERENCES RESULT(resultID) ON DELETE CASCADE,
    questionID INT NOT NULL REFERENCES QUESTION(questionID) ON DELETE CASCADE,
    answerID INT REFERENCES ANSWER(answerID), 
    isCorrect BOOLEAN,
    PRIMARY KEY(resultID, questionID)
);
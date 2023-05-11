<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Student home page</title>
</head>
<body>
<%-- Set the scripting language Java and --%>
			<%@ page language="java" import="java.sql.*" %>
			
			<%-- Open Connection Code --%>
				<%
				DriverManager.registerDriver(new org.postgresql.Driver());
				String CREATE_Student_QUERY = 
					"CREATE TABLE Student (/n"+
					"    st_ID VARCHAR(255) PRIMARY KEY,/n"+
					"    st_SSN VARCHAR(255) UNIQUE NOT NULL,/n"+
					"    st_enrollmentStatus VARCHAR(255) NOT NULL,/n"+
					"    st_residential VARCHAR(255)  NOT NULL,/n"+
					"    st_firstName VARCHAR(255)  NOT NULL,/n"+
					"    st_middleName VARCHAR(255) ,/n"+
					"    st_lastName VARCHAR(255)  NOT NULL/n"+
					")";

				String CREATE_AttendancePeriod_QUERY = 
					"CREATE TABLE AttendancePeriod (/n"+
					"    st_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    st_year INT NOT NULL,/n"+
					"    st_quarter VARCHAR(255) NOT NULL,/n"+
					"    PRIMARY KEY(st_ID),/n"+
					"    CONSTRAINT fk_AttendancePeriod_from_Student/n"+
					"        FOREIGN KEY(st_ID) /n"+
					"            REFERENCES Student(st_ID)/n"+
					")";

				String CREATE_PastDegree_QUERY = 
					"CREATE TABLE PastDegree (/n"+
					"    st_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    st_Institution VARCHAR(255) NOT NULL,/n"+
					"    st_level VARCHAR(255) NOT NULL,/n"+
					"    st_date int NOT NULL,/n"+
					"    PRIMARY KEY(st_ID),/n"+
					"    CONSTRAINT fk_PastDegree_from_Student/n"+
					"        FOREIGN KEY(st_ID) /n"+
					"            REFERENCES Student(st_ID)/n"+
					")";

				String CREATE_Probation_QUERY = 
					"CREATE TABLE Probation (/n"+
					"    st_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    st_startDate VARCHAR(255) NOT NULL,/n"+
					"    st_endDate VARCHAR(255) NOT NULL,/n"+
					"    st_reason VARCHAR(255) NOT NULL,/n"+
					"    PRIMARY KEY(st_ID),/n"+
					"    CONSTRAINT fk_st_Probation_from_Student/n"+
					"        FOREIGN KEY(st_ID) /n"+
					"            REFERENCES Student(st_ID)/n"+
					")";

				String CREATE_Undergraduate_QUERY = 
					"CREATE TABLE Undergraduate (/n"+
					"    ug_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    ug_major VARCHAR(255) NOT NULL,/n"+
					"    ug_minor VARCHAR(255),/n"+
					"    PRIMARY KEY(ug_ID),/n"+
					"    CONSTRAINT fk_Undergraduate_from_Student/n"+
					"        FOREIGN KEY(st_ID) /n"+
					"            REFERENCES Student(st_ID)/n"+
					")";

				String CREATE_Graduate_QUERY = 
					"CREATE TABLE Graduate (/n"+
					"    gd_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    PRIMARY KEY(gd_ID),/n"+
					"    CONSTRAINT fk_Graduate_from_Student/n"+
					"        FOREIGN KEY(st_ID) /n"+
					"            REFERENCES Student(st_ID)/n"+
					")";

				String CREATE_MS_QUERY = 
					"CREATE TABLE MS (/n"+
					"    ms_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    PRIMARY KEY(ms_ID),/n"+
					"    CONSTRAINT fk_MS_from_Graduate/n"+
					"        FOREIGN KEY(gd_ID) /n"+
					"            REFERENCES Graduate(gd_ID)/n"+
					")";

				String CREATE_BSMS_QUERY = 
					"CREATE TABLE BSMS (/n"+
					"    bsms_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    PRIMARY KEY(bsms_ID),/n"+
					"    CONSTRAINT fk_BSMS_from_Undergraduate_MS/n"+
					"        FOREIGN KEY(ug_ID) /n"+
					"            REFERENCES Undergraduate(ug_ID)/n"+
					"      //FOREIGN KEY(ms_ID) /n"+
					"      //    REFERENCES MS(ms_ID)/n"+
					")";

				String CREATE_PhD_QUERY = 
					"CREATE TABLE PhD (/n"+
					"    ph_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    PRIMARY KEY(ph_ID),/n"+
					"    CONSTRAINT fk_PhD_from_Graduate/n"+
					"        FOREIGN KEY(gd_ID) /n"+
					"            REFERENCES Graduate(gd_ID)/n"+
					")";

				String CREATE_PreCandidate_QUERY = 
					"CREATE TABLE PreCandidate (/n"+
					"    pre_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    PRIMARY KEY(pre_ID),/n"+
					"    CONSTRAINT fk_PreCandidate_from_PhD/n"+
					"        FOREIGN KEY(ph_ID) /n"+
					"            REFERENCES PhD(ph_ID)/n"+
					")";

				String CREATE_Candidate_QUERY = 
					"CREATE TABLE Candidate (/n"+
					"    cd_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    cd_advisor VARCHAR(255) NOT NULL,/n"+
					"    PRIMARY KEY(cd_ID),/n"+
					"    CONSTRAINT fk_Candidate_from_PhD/n"+
					"        FOREIGN KEY(ph_ID) /n"+
					"            REFERENCES PhD(ph_ID)/n"+
					")";

				String CREATE_Book_QUERY = 
					"CREATE TABLE Book (/n"+
					"    bk_ISBN INT PRIMARY KEY,/n"+
					"    bk_title VARCHAR(255) NOT NULL,/n"+
					"    bk_edition INT ,/n"+
					"    bk_publisher VARCHAR(255) NOT NULL/n"+
					")";

				String CREATE_Author_QUERY = 
					"CREATE TABLE Author (/n"+
					"    au_ISBN INT GENERATED ALWAYS AS IDENTITY,/n"+
					"    au_firstName VARCHAR(255) NOT NULL,/n"+
					"    au_lastName VARCHAR(255) NOT NULL,/n"+
					"    PRIMARY KEY(au_ISBN),/n"+
					"    CONSTRAINT fk_Author_from_Book/n"+
					"        FOREIGN KEY(bk_ISBN) /n"+
					"            REFERENCES Book(bk_ISBN)/n"+
					")";

				String CREATE_Section_QUERY = 
					"CREATE TABLE Section (/n"+
					"    s_sectionID VARCHAR(255) PRIMARY KEY,/n"+
					"    s_limitCapacity INT NOT NULL/n"+
					")";


				String CREATE_WeeklyMeeting_QUERY = 
					"CREATE TABLE WeeklyMeeting (/n"+
					"    wk_location VARCHAR(255) NOT NULL,/n"+
					"    wk_time VARCHAR(255) NOT NULL,/n"+
					"    wk_meetingType VARCHAR(255) NOT NULL,/n"+
					"    wk_dayOfWeek VARCHAR(255) NOT NULL,/n"+
					"    wk_attendanceType VARCHAR(255) NOT NULL/n"+
					"    CONSTRAINT pk_WeeklyMeeting_group/n"+
					"        PRIMARY KEY(wk_location, wk_time, wk_meetingType, wk_dayOfWeek)/n"+
					")";

				String CREATE_ReviewSession_QUERY = 
					"CREATE TABLE ReviewSession (/n"+
					"    rv_location VARCHAR(255) NOT NULL,/n"+
					"    rv_time VARCHAR(255) NOT NULL,/n"+
					"    rv_date VARCHAR(255) NOT NULL/n"+
					"    CONSTRAINT pk_ReviewSession_group/n"+
					"        PRIMARY KEY(rv_location, rv_time, rv_date)/n"+
					")";

				String CREATE_Faculty_QUERY = 
					"CREATE TABLE Faculty (/n"+
					"    fc_name VARCHAR(255) PRIMARY KEY/n"+
					")";

				String CREATE_Professor_QUERY = 
					"CREATE TABLE Professor (/n"+
					"    fc_pfName VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    PRIMARY KEY(fc_pfName),/n"+
					"    CONSTRAINT fk_Professor_from_Faculty/n"+
					"        FOREIGN KEY(fc_name) /n"+
					"            REFERENCES Faculty(fc_name)/n"+
					")";

				String CREATE_Lecturer_QUERY = 
					"CREATE TABLE Lecturer (/n"+
					"    fc_lcName VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    PRIMARY KEY(fc_lcName),/n"+
					"    CONSTRAINT fk_Lecturer_from_Faculty/n"+
					"        FOREIGN KEY(fc_name) /n"+
					"            REFERENCES Faculty(fc_name)/n"+
					")";

				String CREATE_Associate_QUERY = 
					"CREATE TABLE Associate (/n"+
					"    fc_ascName VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    PRIMARY KEY(fc_ascName),/n"+
					"    CONSTRAINT fk_Associate_from_Faculty/n"+
					"        FOREIGN KEY(fc_name) /n"+
					"            REFERENCES Faculty(fc_name)/n"+
					")";

				String CREATE_Assistant_QUERY = 
					"CREATE TABLE Assistant (/n"+
					"    fc_astName VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    PRIMARY KEY(fc_astName),/n"+
					"    CONSTRAINT fk_Assistant_from_Faculty/n"+
					"        FOREIGN KEY(fc_name) /n"+
					"            REFERENCES Faculty(fc_name)/n"+
					")";

				String CREATE_Course_QUERY = 
					"CREATE TABLE Course (/n"+
					"    cr_courseNumber VARCHAR(255) PRIMARY KEY,/n"+
					"    cr_lab VARCHAR(255) NOT NULL/n"+
					")";

				String CREATE_RangedUnitCourse_QUERY = 
					"CREATE TABLE RangedUnitCourse (/n"+
					"    ru_courseNumber VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    ru_minUnit INT NOT NULL,/n"+
					"    ru_maxUnit INT NOT NULL,/n"+
					"    PRIMARY KEY(ru_courseNumber),/n"+
					"    CONSTRAINT fk_RangedUnitCourse_from_Course/n"+
					"        FOREIGN KEY(cr_courseNumber) /n"+
					"            REFERENCES Course(cr_courseNumber)/n"+
					")";

				String CREATE_FixedUnitCourse_QUERY = 
					"CREATE TABLE FixedUnitCourse (/n"+
					"    fu_courseNumber VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    fu_Unit INT NOT NULL,/n"+
					"    PRIMARY KEY(fu_courseNumber),/n"+
					"    CONSTRAINT fk_FixedUnitCourse_from_Course/n"+
					"        FOREIGN KEY(cr_courseNumber) /n"+
					"            REFERENCES Course(cr_courseNumber)/n"+
					")";

				String CREATE_PastCourseNumber_QUERY = 
					"CREATE TABLE PastCourseNumber (/n"+
					"    pc_courseNumber VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    pc_changedYear INT NOT NULL,/n"+
					"    PRIMARY KEY(cr_pc_courseNumber),/n"+
					"    CONSTRAINT fk_cr_pastCourseNumber_from_Course/n"+
					"        FOREIGN KEY(cr_courseNumber) /n"+
					"            REFERENCES Course(cr_courseNumber)/n"+
					")";

				String CREATE_GradeOption_QUERY = 
					"CREATE TABLE GradeOption (/n"+
					"    go_courseNumber VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    go_option VARCHAR(255) NOT NULL,/n"+
					"    PRIMARY KEY(cr_go_courseNumber),/n"+
					"    CONSTRAINT fk_cr_gradeOption_from_Course/n"+
					"        FOREIGN KEY(cr_courseNumber) /n"+
					"            REFERENCES Course(cr_courseNumber)/n"+
					")";

				String CREATE_Department_QUERY = 
					"CREATE TABLE Department (/n"+
					"    dp_departmentID VARCHAR(255) PRIMARY KEY/n"+
					")";

				String CREATE_ThesisCommittee_QUERY = 
					"CREATE TABLE ThesisCommittee (/n"+
					"    tc_ID VARCHAR(255) PRIMARY KEY/n"+
					")";
				
				String CREATE_take_QUERY = 
					"CREATE TABLE take (/n"+
					"    st_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    s_sectionID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    take_enrollmentStatus VARCHAR(255) NOT NULL,/n"+
					"    take_gradingOption VARCHAR(255) NOT NULL/n"+
					"    CONSTRAINT pk_take_group/n"+
					"        PRIMARY KEY(st_ID, s_sectionID)/n"+
					"    CONSTRAINT fk_take_from_Student/n"+
					"        FOREIGN KEY(st_ID) /n"+
					"            REFERENCES Student(st_ID)       /n"+
					"    CONSTRAINT fk_take_from_Section/n"+
					"        FOREIGN KEY(s_sectionID) /n"+
					"            REFERENCES Section(s_sectionID)/n"+
					")";

				String CREATE_need_QUERY = 
					"CREATE TABLE need (/n"+
					"    s_sectionID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    bk_ISBN VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    CONSTRAINT pk_need_group/n"+
					"        PRIMARY KEY(s_sectionID, bk_ISBN)/n"+
					"    CONSTRAINT fk_need_from_Section/n"+
					"        FOREIGN KEY(s_sectionID) /n"+
					"            REFERENCES Course(s_sectionID)      /n"+
					"    CONSTRAINT fk_need_from_Book/n"+
					"        FOREIGN KEY(bk_ISBN) /n"+
					"            REFERENCES Book(bk_ISBN)/n"+
					")";
				
				String CREATE_holdWeekly_QUERY = 
					"CREATE TABLE holdWeekly (/n"+
					"    s_sectionID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    wk_location VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    wk_time VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    wk_meetingType VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    wk_dayOfWeek VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    CONSTRAINT pk_holdWeekly_group/n"+
					"        PRIMARY KEY(s_sectionID, wk_location, wk_time, wk_meetingType, wk_dayOfWeek)/n"+
					"    CONSTRAINT fk_holdWeekly_from_Section/n"+
					"        FOREIGN KEY(s_sectionID) /n"+
					"            REFERENCES Course(s_sectionID)      /n"+
					"    CONSTRAINT fk_holdWeekly_from_WeeklyMeeting_location/n"+
					"        FOREIGN KEY(wk_location) /n"+
					"            REFERENCES WeeklyMeeting(wk_location)/n"+
					"    CONSTRAINT fk_holdWeekly_from_WeeklyMeeting_time/n"+
					"        FOREIGN KEY(wk_time) /n"+
					"            REFERENCES WeeklyMeeting(wk_time)/n"+
					"    CONSTRAINT fk_holdWeekly_from_WeeklyMeeting_meetingType/n"+
					"        FOREIGN KEY(wk_meetingType) /n"+
					"            REFERENCES WeeklyMeeting(wk_meetingType)/n"+
					"    CONSTRAINT fk_holdWeelky_from_WeeklyMeeting_weekOfWeek/n"+
					"        FOREIGN KEY(wk_dayOfWeek) /n"+
					"            REFERENCES WeeklyMeeting(wk_dayOfWeek)/n"+
					")";

				String CREATE_holdReview_QUERY = 
					"CREATE TABLE holdReview (/n"+
					"    s_sectionID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    rv_location VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    rv_time VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    rv_date VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    CONSTRAINT pk_holdReview_group/n"+
					"        PRIMARY KEY(s_sectionID, rv_location, rv_time, )/n"+
					"    CONSTRAINT fk_holdReview_from_Section/n"+
					"        FOREIGN KEY(s_sectionID) /n"+
					"            REFERENCES Course(s_sectionID)      /n"+
					"    CONSTRAINT fk_holdReview_from_ReviewSession_location/n"+
					"        FOREIGN KEY(rv_location) /n"+
					"            REFERENCES ReviewSession(rv_location)/n"+
					"    CONSTRAINT fk_holdReview_from_ReviewSession_time/n"+
					"        FOREIGN KEY(rv_time) /n"+
					"            REFERENCES ReviewSession(rv_time)/n"+
					"    CONSTRAINT fk_holdReview_from_ReviewSession_date/n"+
					"        FOREIGN KEY(rv_date) /n"+
					"            REFERENCES ReviewSession(rv_date)/n"+
					")";
				
				String CREATE_requestConsent_QUERY = 
					"CREATE TABLE requestConsent (/n"+
					" st_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    fc_name VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					" cr_courseNumber VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					" rc_result VARCHAR(255) NOT NULL,/n"+
					"    CONSTRAINT pk_requestConsent_group/n"+
					"        PRIMARY KEY(st_ID, fc_name, cr_courseNmuber)/n"+
					"    CONSTRAINT fk_requestConsent_from_Student/n"+
					"        FOREIGN KEY(st_ID) /n"+
					"            REFERENCES Student(st_ID)/n"+
					"    CONSTRAINT fk_requestConsent_from_Faculty/n"+
					"        FOREIGN KEY(fc_name) /n"+
					"            REFERENCES Faculty(fc_name)/n"+
					"    CONSTRAINT fk_requestConsent_from_Course/n"+
					"        FOREIGN KEY(cr_courseNumber) /n"+
					"            REFERENCES Course(cr_courseNumber)  /n"+
					")";

				String CREATE_prerequisite_QUERY = 
					"CREATE TABLE prerequisite (/n"+
					"    cr_mainCourseNumber VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    cr_prereqCourseNumber VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    CONSTRAINT pk_prerequisite_group/n"+
					"        PRIMARY KEY(cr_mainCourseNumber, cr_prereqCourseNumber)/n"+
					"    CONSTRAINT fk_prerequisite_from_Course_main/n"+
					"        FOREIGN KEY(cr_mainCourseNumber) /n"+
					"            REFERENCES Course(cr_mainCourseNumber)      /n"+
					"    CONSTRAINT fk_prerequisite_from_Course_preq/n"+
					"        FOREIGN KEY(cr_prereqCourseNumber) /n"+
					"            REFERENCES Course(cr_prereqCourseNumber)  /n"+
					")";
				
				String CREATE_offer_QUERY = 
					"CREATE TABLE offer (/n"+
					"    cr_courseNumber VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    dp_departmentID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    CONSTRAINT pk_offer_group/n"+
					"        PRIMARY KEY(cr_courseNumber, dp_departmentID)/n"+
					"    CONSTRAINT fk_offer_from_Course/n"+
					"        FOREIGN KEY(cr_courseNumber) /n"+
					"            REFERENCES Course(cr_courseNumber)      /n"+
					"    CONSTRAINT fk_offer_from_Department/n"+
					"        FOREIGN KEY(dp_departmentID) /n"+
					"            REFERENCES Department(dp_departmentID)/n"+
					")";
				
				String CREATE_give_QUERY = 
					"CREATE TABLE give (/n"+
					"    cr_courseNumber VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    cl_title VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    cl_year INT GENERATED ALWAYS AS IDENTITY,/n"+
					"    cl_quarter VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    CONSTRAINT pk_give_group/n"+
					"        PRIMARY KEY(cr_courseNumber, cl_year, cl_quarter, fc_name)/n"+
					"    CONSTRAINT fk_give_from_Course/n"+
					"        FOREIGN KEY(cr_courseNumber) /n"+
					"            REFERENCES Course(cr_courseNumber)      /n"+
					"    CONSTRAINT fk_give_from_ClassTitle/n"+
					"        FOREIGN KEY(cl_title) /n"+
					"            REFERENCES Class(cl_title)/n"+
					"    CONSTRAINT fk_give_from_ClassYear/n"+
					"        FOREIGN KEY(cl_year) /n"+
					"            REFERENCES Class(cl_year)/n"+
					"    CONSTRAINT fk_give_from_ClassQuarter/n"+
					"        FOREIGN KEY(cl_quarter) /n"+
					"            REFERENCES Class(cl_quarter)/n"+
					")";

				
				String CREATE_workFor_QUERY = 
					"CREATE TABLE workFor (/n"+
					"    fc_name VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    dp_departmentID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    CONSTRAINT pk_workFor_group/n"+
					"        PRIMARY KEY(fc_name, dp_departmentID)/n"+
					"    CONSTRAINT fk_workFor_from_Faculty/n"+
					"        FOREIGN KEY(fc_name) /n"+
					"            REFERENCES Faculty(fc_name)/n"+
					"    CONSTRAINT fk_workFor_from_Department/n"+
					"        FOREIGN KEY(dp_departmentID) /n"+
					"            REFERENCES Department(dp_departmentID)/n"+
					")";

				String CREATE_qualify_QUERY = 
					"CREATE TABLE qualify (/n"+
					"    fc_name VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    cl_title VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    cl_year INT GENERATED ALWAYS AS IDENTITY,/n"+
					"    cl_quarter VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    CONSTRAINT pk_qualify_group/n"+
					"        PRIMARY KEY(fc_name, cl_title, cl_year, cl_quarter)/n"+
					"    CONSTRAINT fk_qualify_from_Faculty/n"+
					"        FOREIGN KEY(fc_name) /n"+
					"            REFERENCES Faculty(fc_name)/n"+
					"    CONSTRAINT fk_qualify_from_ClassTitle/n"+
					"        FOREIGN KEY(cl_title) /n"+
					"            REFERENCES Class(cl_title)/n"+
					"    CONSTRAINT fk_qualify_from_ClassYear/n"+
					"        FOREIGN KEY(cl_year) /n"+
					"            REFERENCES Class(cl_year)/n"+
					"    CONSTRAINT fk_qualify_from_ClassQuarter/n"+
					"        FOREIGN KEY(cl_quarter) /n"+
					"            REFERENCES Class(cl_quarter)/n"+
					")";
				
				String CREATE_teach_QUERY = 
					"CREATE TABLE teach (/n"+
					"    s_sectionID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    fc_name VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    CONSTRAINT pk_teach_group/n"+
					"        PRIMARY KEY(s_sectionID, fc_name)/n"+
					"    CONSTRAINT fk_teach_from_Section/n"+
					"        FOREIGN KEY(s_sectionID) /n"+
					"            REFERENCES Section(s_sectionID)     /n"+
					"    CONSTRAINT fk_teach_from_Faculty/n"+
					"        FOREIGN KEY(fc_name) /n"+
					"            REFERENCES Faculty(fc_name)/n"+
					")";

				String CREATE_split_QUERY = 
					"CREATE TABLE split (/n"+
					"    s_sectionID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    cl_title VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    cl_year INT GENERATED ALWAYS AS IDENTITY,/n"+
					"    cl_quarter VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    CONSTRAINT pk_split_group/n"+
					"        PRIMARY KEY(s_sectionID, cl_title, cl_year, cl_quarter)/n"+
					"    CONSTRAINT fk_split_from_Class/n"+
					"        FOREIGN KEY(s_sectionID) /n"+
					"            REFERENCES Section(s_sectionID)     /n"+
					"    CONSTRAINT fk_split_from_ClassTitle/n"+
					"        FOREIGN KEY(cl_title) /n"+
					"            REFERENCES Class(cl_title)/n"+
					"    CONSTRAINT fk_split_from_ClassYear/n"+
					"        FOREIGN KEY(cl_year) /n"+
					"            REFERENCES Class(cl_year)/n"+
					"    CONSTRAINT fk_split_from_ClassQuarter/n"+
					"        FOREIGN KEY(cl_quarter) /n"+
					"            REFERENCES Class(cl_quarter)/n"+
					")";
				
				String CREATE_academicHistory_QUERY = 
					"CREATE TABLE academicHistory (/n"+
					"    st_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    cl_title VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    cl_year INT GENERATED ALWAYS AS IDENTITY,/n"+
					"    cl_quarter VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    acahis_pastOrCurrent  VARCHAR(255) NOT NULL,/n"+
					"    acahis_grade VARCHAR(255) NOT NULL,/n"+
					"    CONSTRAINT pk_academicHistory_group/n"+
					"        PRIMARY KEY(st_ID, cl_title, cl_year, cl_quarter)/n"+
					"    CONSTRAINT fk_academicHistory_from_Student/n"+
					"        FOREIGN KEY(st_ID) /n"+
					"            REFERENCES Student(st_ID)       /n"+
					"    CONSTRAINT fk_academicHistory_from_ClassTitle/n"+
					"        FOREIGN KEY(cl_title) /n"+
					"            REFERENCES Class(cl_title)/n"+
					"    CONSTRAINT fk_academicHistory_from_ClassYear/n"+
					"        FOREIGN KEY(cl_year) /n"+
					"            REFERENCES Class(cl_year)/n"+
					"    CONSTRAINT fk_academicHistory_from_ClassQuarter/n"+
					"        FOREIGN KEY(cl_quarter) /n"+
					"            REFERENCES Class(cl_quarter)/n"+
					")";
				
				String CREATE_program_QUERY = 
					"CREATE TABLE program (/n"+
					"    st_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    dg_majorCode VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    CONSTRAINT pk_program_group/n"+
					"        PRIMARY KEY(st_ID, dg_majorCode)/n"+
					"    CONSTRAINT fk_program_from_Student/n"+
					"        FOREIGN KEY(st_ID) /n"+
					"            REFERENCES Student(st_ID)       /n"+
					"    CONSTRAINT fk_program_from_Degree/n"+
					"        FOREIGN KEY(dg_majorCode) /n"+
					"            REFERENCES Degree(dg_majorCode)/n"+
					")";

				String CREATE_require_QUERY = 
					"CREATE TABLE require (/n"+
					"    dg_majorCode VARCHAR(255)GENERATED ALWAYS AS IDENTITY,/n"+
					"    dp_departmentID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    require_totalUnit VARCHAR(255),/n"+
					"    CONSTRAINT pk_require_group/n"+
					"        PRIMARY KEY(dg_majorCode, dp_departmentID)/n"+
					"    CONSTRAINT fk_require_from_Department/n"+
					"        FOREIGN KEY(dp_departmentID) /n"+
					"            REFERENCES Department(dp_departmentID)      /n"+
					"    CONSTRAINT fk_require_from_Degree/n"+
					"        FOREIGN KEY(dg_majorCode) /n"+
					"            REFERENCES Degree(dg_majorCode)/n"+
					")";
				
				String CREATE_belongTo_QUERY = 
					"CREATE TABLE belongTo (/n"+
					"    gd_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    dp_departmentID VARCHAR(255) ENERATED ALWAYS AS IDENTITY,/n"+
					"    CONSTRAINT pk_belongTo_group/n"+
					"        PRIMARY KEY(gd_ID, dp_departmentID)/n"+
					"    CONSTRAINT fk_belongTo_from_Graduate/n"+
					"        FOREIGN KEY(gd_ID) /n"+
					"            REFERENCES Graduate(gd_ID)      /n"+
					"    CONSTRAINT fk_belongTo_from_Department/n"+
					"        FOREIGN KEY(dp_departmentID) /n"+
					"            REFERENCES Department(dp_departmentID)/n"+
					")";

				String CREATE_advise_QUERY = 
					"CREATE TABLE advise (/n"+
					"    cd_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    tc_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    CONSTRAINT pk_advise_group/n"+
					"        PRIMARY KEY(cd_ID, tc_ID)/n"+
					"    CONSTRAINT fk_advise_from_ThesisCommittee/n"+
					"        FOREIGN KEY(tc_ID) /n"+
					"            REFERENCES ThesisCommittee(tc_ID)       /n"+
					"    CONSTRAINT fk_advise_from_Candidate/n"+
					"        FOREIGN KEY(cd_ID) /n"+
					"            REFERENCES Candidate(cd_ID)/n"+
					")";
				
				String CREATE_consist_QUERY = 
					"CREATE TABLE consist (/n"+
					"    tc_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    fc_name VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    fc_name1_same VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    fc_name2_same VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    fc_name3_same VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    fc_name1_diff VARCHAR(255) GENERATED ALWAYS AS IDENTITY,/n"+
					"    CONSTRAINT pk_consist_group/n"+
					"        PRIMARY KEY(tc_ID, fc_name)/n"+
					"    CONSTRAINT fk_consist_from_ThesisCommittee/n"+
					"        FOREIGN KEY(tc_ID) /n"+
					"            REFERENCES ThesisCommittee(tc_ID)       /n"+
					"    CONSTRAINT fk_consist_from_Faculty/n"+
					"        FOREIGN KEY(fc_name) /n"+
					"            REFERENCES Faculty(fc_name),/n"+
					"    CONSTRAINT fk_ThesisCommittee_from_Faculty_same1/n"+
					"        FOREIGN KEY(fc_name) /n"+
					"            REFERENCES Faculty(fc_name)/n"+
					"    CONSTRAINT fk_ThesisCommittee_from_Faculty_same2/n"+
					"        FOREIGN KEY(fc_name) /n"+
					"            REFERENCES Faculty(fc_name)/n"+
					"    CONSTRAINT fk_ThesisCommittee_from_Faculty_same3/n"+
					"        FOREIGN KEY(fc_name) /n"+
					"            REFERENCES Faculty(fc_name)/n"+
					"    CONSTRAINT fk_ThesisCommittee_from_Faculty_diff/n"+
					"        FOREIGN KEY(fc_name) /n"+
					"            REFERENCES Faculty(fc_name)/n"+
					")";

				
				// Make a connection to the driver
				Connection connection = DriverManager.getConnection
				("jdbc:postgresql:tritonlink?user=postgres&password=helloworld");
				
				Statement stmt = connection.createStatement();

				stmt.executeQuery(CREATE_Student_QUERY);
				stmt.executeQuery(CREATE_AttendancePeriod_QUERY);
				stmt.executeQuery(CREATE_PastDegree_QUERY);
				stmt.executeQuery(CREATE_Probation_QUERY);
				stmt.executeQuery(CREATE_Undergraduate_QUERY);
				stmt.executeQuery(CREATE_Graduate_QUERY);
				stmt.executeQuery(CREATE_MS_QUERY);
				stmt.executeQuery(CREATE_BSMS_QUERY);
				stmt.executeQuery(CREATE_PhD_QUERY);
				stmt.executeQuery(CREATE_PreCandidate_QUERY);
				stmt.executeQuery(CREATE_Candidate_QUERY);
				stmt.executeQuery(CREATE_Book_QUERY);
				stmt.executeQuery(CREATE_Author_QUERY);
				stmt.executeQuery(CREATE_Section_QUERY);
				stmt.executeQuery(CREATE_WeeklyMeeting_QUERY);
				stmt.executeQuery(CREATE_ReviewSession_QUERY);
				stmt.executeQuery(CREATE_Faculty_QUERY);
				stmt.executeQuery(CREATE_Professor_QUERY);
				stmt.executeQuery(CREATE_Lecturer_QUERY);
				stmt.executeQuery(CREATE_Associate_QUERY);
				stmt.executeQuery(CREATE_Assistant_QUERY);
				stmt.executeQuery(CREATE_Course_QUERY);
				stmt.executeQuery(CREATE_RangedUnitCourse_QUERY);
				stmt.executeQuery(CREATE_FixedUnitCourse_QUERY);
				stmt.executeQuery(CREATE_PastCourseNumber_QUERY);
				stmt.executeQuery(CREATE_GradeOption_QUERY);
				stmt.executeQuery(CREATE_Department_QUERY);
				stmt.executeQuery(CREATE_ThesisCommittee_QUERY);
				stmt.executeQuery(CREATE_take_QUERY);
				stmt.executeQuery(CREATE_require_QUERY);
				stmt.executeQuery(CREATE_holdWeekly_QUERY);
				stmt.executeQuery(CREATE_holdReview_QUERY);
				stmt.executeQuery(CREATE_requestConsent_QUERY);
				stmt.executeQuery(CREATE_prerequisite_QUERY);
				stmt.executeQuery(CREATE_offer_QUERY);
				stmt.executeQuery(CREATE_give_QUERY);
				stmt.executeQuery(CREATE_workFor_QUERY);
				stmt.executeQuery(CREATE_qualify_QUERY);
				stmt.executeQuery(CREATE_teach_QUERY);
				stmt.executeQuery(CREATE_split_QUERY);
				stmt.executeQuery(CREATE_academicHistory_QUERY);
				stmt.executeQuery(CREATE_program_QUERY);
				stmt.executeQuery(CREATE_require_QUERY);
				stmt.executeQuery(CREATE_belongTo_QUERY);
				stmt.executeQuery(CREATE_advise_QUERY);
				stmt.executeQuery(CREATE_consist_QUERY);
				%>

</body>
</html>

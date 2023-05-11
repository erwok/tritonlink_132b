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
					"CREATE TABLE Student (\n"+
						"st_ID VARCHAR(255) PRIMARY KEY,\n"+
						"st_SSN VARCHAR(255) UNIQUE NOT NULL,\n"+
						"st_enrollmentStatus VARCHAR(255) NOT NULL,\n"+
						"st_residential VARCHAR(255)  NOT NULL,\n"+
						"st_firstName VARCHAR(255)  NOT NULL,\n"+
						"st_middleName VARCHAR(255) ,\n"+
						"st_lastName VARCHAR(255)  NOT NULL\n"+
					")\n";

				String CREATE_st_AttendancePeriod_QUERY = 
					"CREATE TABLE st_AttendancePeriod (\n"+
							"st_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
							"st_year INT NOT NULL,\n"+
							"st_quarter VARCHAR(255) NOT NULL,\n"+
							"PRIMARY KEY(st_ID),\n"+
							"CONSTRAINT fk_st_AttendancePeriod_from_Student\n"+
							"	FOREIGN KEY(st_ID) \n"+
							"		REFERENCES Student(st_ID)\n"+
						")\n";

				String CREATE_st_Degree_QUERY = 
					"CREATE TABLE st_Degree (\n"+
						"st_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
						"st_Institution VARCHAR(255) NOT NULL,\n"+
						"st_level VARCHAR(255) NOT NULL,\n"+
						"st_date int NOT NULL,\n"+
						"PRIMARY KEY(st_ID),\n"+
						"CONSTRAINT fk_st_Degree_from_Student\n"+
						"	FOREIGN KEY(st_ID) \n"+
						"		REFERENCES Student(st_ID)\n"+
					")\n";

				String CREATE_st_Probation_QUERY = 
					"CREATE TABLE st_Probation (\n"+
						"st_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
						"st_startDate VARCHAR(255) NOT NULL,\n"+
						"st_endDate VARCHAR(255) NOT NULL,\n"+
						"st_reason VARCHAR(255) NOT NULL,\n"+
						"PRIMARY KEY(st_ID),\n"+
						"CONSTRAINT fk_st_Probation_from_Student\n"+
						"	FOREIGN KEY(st_ID) \n"+
						"		REFERENCES Student(st_ID)\n"+
					")\n";

				String CREATE_Undergraduate_QUERY = 
					"CREATE TABLE Undergraduate (\n"+
						"ug_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
						"ug_major VARCHAR(255) NOT NULL,\n"+
						"ug_minor VARCHAR(255),\n"+
						"PRIMARY KEY(ug_ID),\n"+
						"CONSTRAINT fk_Undergraduate_from_Student\n"+
						"	FOREIGN KEY(st_ID) \n"+
						"		REFERENCES Student(st_ID)\n"+
					")\n";

				String CREATE_Graduate_QUERY = 
					"CREATE TABLE Graduate (\n"+
						"gd_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
						"PRIMARY KEY(gd_ID),\n"+
						"CONSTRAINT fk_Graduate_from_Student\n"+
						"	FOREIGN KEY(st_ID) \n"+
						"		REFERENCES Student(st_ID)\n"+
					")\n";

				String CREATE_MS_QUERY = 
					"CREATE TABLE MS (\n"+
						"ms_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
						"PRIMARY KEY(ms_ID),\n"+
						"CONSTRAINT fk_MS_from_Graduate\n"+
						"	FOREIGN KEY(gd_ID) \n"+
						"		REFERENCES Graduate(gd_ID)\n"+
					")\n";

				String CREATE_BSMS_QUERY = 
					"CREATE TABLE BSMS (\n"+
						"bsms_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
						"PRIMARY KEY(bsms_ID),\n"+
						"CONSTRAINT fk_BSMS_from_Undergraduate_MS\n"+
						"	FOREIGN KEY(ug_ID) \n"+
						"		REFERENCES Undergraduate(ug_ID)\n"+
						"	FOREIGN KEY(ms_ID) \n"+
						"		REFERENCES MS(ms_ID)\n"+
					")\n";

				String CREATE_PhD_QUERY = 
					"CREATE TABLE PhD (\n"+
						"ph_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
						"PRIMARY KEY(ph_ID),\n"+
						"CONSTRAINT fk_PhD_from_Graduate\n"+
						"	FOREIGN KEY(gd_ID) \n"+
						"		REFERENCES Graduate(gd_ID)\n"+
					")\n";

				String CREATE_Pre_candidate_QUERY = 
					"CREATE TABLE Pre_candidate (\n"+
						"pre_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
						"PRIMARY KEY(pre_ID),\n"+
						"CONSTRAINT fk_Pre-candidate_from_PhD\n"+
						"	FOREIGN KEY(ph_ID) \n"+
						"		REFERENCES PhD(ph_ID)\n"+
					")\n";

				String CREATE_Candidate_QUERY = 
					"CREATE TABLE Candidate (\n"+
						"cd_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
						"cd_advisor VARCHAR(255) NOT NULL,\n"+
						"PRIMARY KEY(cd_ID),\n"+
						"CONSTRAINT fk_Candidate_from_PhD\n"+
						"	FOREIGN KEY(ph_ID) \n"+
						"		REFERENCES PhD(ph_ID)\n"+
					")\n";

				String CREATE_Book_QUERY = 
					"CREATE TABLE Book (\n"+
						"bk_ISBN INT PRIMARY KEY,\n"+
						"bk_title VARCHAR(255) NOT NULL,\n"+
						"bk_edition INT ,\n"+
						"bk_publisher VARCHAR(255) NOT NULL\n"+
					")\n";

				String CREATE_Author_QUERY = 
					"CREATE TABLE Author (\n"+
						"au_ISBN INT GENERATED ALWAYS AS IDENTITY,\n"+
						"au_firstName VARCHAR(255) NOT NULL,\n"+
						"au_lastName VARCHAR(255) NOT NULL,\n"+
						"PRIMARY KEY(au_ISBN),\n"+
						"CONSTRAINT fk_Author_from_Book\n"+
						"	FOREIGN KEY(bk_ISBN) \n"+
						"		REFERENCES Book(bk_ISBN)\n"+
					")\n";

				String CREATE_Section_QUERY = 
					"CREATE TABLE Section (\n"+
						"s_sectionID VARCHAR(255) PRIMARY KEY,\n"+
						"s_limitCapacity INT NOT NULL\n"+
					")\n";

				String CREATE_WeeklyMeeting_QUERY = 
					"CREATE TABLE WeeklyMeeting (\n"+
						"wk_location VARCHAR(255) NOT NULL,\n"+
						"wk_time VARCHAR(255) NOT NULL,\n"+
						"wk_meetingType VARCHAR(255) NOT NULL,\n"+
						"wk_dayOfWeek VARCHAR(255) NOT NULL,\n"+
						"wk_attendanceType VARCHAR(255) NOT NULL\n"+
						"CONSTRAINT pk_WeeklyMeeting_group\n"+
						"	PRIMARY KEY(wk_location, wk_time, wk_meetingType, wk_dayOfWeek)\n"+
					")\n";

				String CREATE_ReviewSession_QUERY = 
					"CREATE TABLE ReviewSession (\n"+
						"rv_location VARCHAR(255) NOT NULL,\n"+
						"rv_time VARCHAR(255) NOT NULL,\n"+
						"rv_date VARCHAR(255) NOT NULL\n"+
						"CONSTRAINT pk_ReviewSession_group\n"+
							"PRIMARY KEY(rv_location, rv_time, rv_date)\n"+
					")\n";

				String CREATE_Faculty_QUERY = 
					"CREATE TABLE Faculty (\n"+
						"fc_name VARCHAR(255) PRIMARY KEY\n"+
						")\n";

				String CREATE_Professor_QUERY = 
					"CREATE TABLE Professor (\n"+
						"fc_pf_name VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
						"PRIMARY KEY(fc_pf_name),\n"+
						"CONSTRAINT fk_Professor_from_Faculty\n"+
						"	FOREIGN KEY(fc_name) \n"+
						"		REFERENCES Faculty(fc_name)\n"+
					")\n";

				String CREATE_Lecturer_QUERY = 
					"CREATE TABLE Lecturer (\n"+
						"fc_lc_name VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
						"PRIMARY KEY(fc_lc_name),\n"+
						"CONSTRAINT fk_Lecturer_from_Faculty\n"+
						"	FOREIGN KEY(fc_name) \n"+
						"		REFERENCES Faculty(fc_name)\n"+
					")\n";

				String CREATE_Associate_QUERY = 
					"CREATE TABLE Associate (\n"+
						"fc_asc_name VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
						"PRIMARY KEY(fc_asc_name),\n"+
						"CONSTRAINT fk_Associate_from_Faculty\n"+
						"	FOREIGN KEY(fc_name) \n"+
						"		REFERENCES Faculty(fc_name)\n"+
					")\n";

				String CREATE_Assistant_QUERY = 
					"CREATE TABLE Assistant (\n"+
						"fc_ast_name VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
						"PRIMARY KEY(fc_ast_name),\n"+
						"CONSTRAINT fk_Assistant_from_Faculty\n"+
						"	FOREIGN KEY(fc_name) \n"+
						"		REFERENCES Faculty(fc_name)\n"+
					")\n";

				String CREATE_Course_QUERY = 
					"CREATE TABLE Course (\n"+
						"cr_courseNumber INT PRIMARY KEY,\n"+
						"cr_lab VARCHAR(255) NOT NULL\n"+
					")\n";

				String CREATE_RangedUnitCourse_QUERY = 
					"CREATE TABLE RangedUnitCourse (\n"+
						"cr_ru_courseNumber INT GENERATED ALWAYS AS IDENTITY,\n"+
						"cr_ru_minUnit INT NOT NULL,\n"+
						"cr_ru_maxUnit INT NOT NULL,\n"+
						"PRIMARY KEY(cr_ru_courseNumber),\n"+
						"CONSTRAINT fk_RangedUnitCourse_from_Course\n"+
						"	FOREIGN KEY(cr_courseNumber) \n"+
						"		REFERENCES Course(cr_courseNumber)\n"+
					")\n";

				String CREATE_FixedUnitCourse_QUERY = 
					"CREATE TABLE FixedUnitCourse (\n"+
						"cr_fu_courseNumber INT GENERATED ALWAYS AS IDENTITY,\n"+
						"cr_fu_Unit INT NOT NULL,\n"+
						"PRIMARY KEY(cr_fu_courseNumber),\n"+
						"CONSTRAINT fk_FixedUnitCourse_from_Course\n"+
						"	FOREIGN KEY(cr_courseNumber) \n"+
						"		REFERENCES Course(cr_courseNumber)\n"+
					")\n";

				String CREATE_cr_pastCourseNumber_QUERY = 
					"CREATE TABLE cr_pastCourseNumber (\n"+
						"cr_pc_courseNumber INT GENERATED ALWAYS AS IDENTITY,\n"+
						"cr_pc_changedYear INT NOT NULL,\n"+
						"PRIMARY KEY(cr_pc_courseNumber),\n"+
						"CONSTRAINT fk_cr_pastCourseNumber_from_Course\n"+
						"	FOREIGN KEY(cr_courseNumber) \n"+
						"		REFERENCES Course(cr_courseNumber)\n"+
					")\n";

				String CREATE_cr_gradeOption_QUERY = 
					"CREATE TABLE cr_gradeOption (\n"+
						"cr_go_courseNumber INT GENERATED ALWAYS AS IDENTITY,\n"+
						"cr_go_option VARCHAR(255) NOT NULL,\n"+
						"PRIMARY KEY(cr_go_courseNumber),\n"+
						"CONSTRAINT fk_cr_gradeOption_from_Course\n"+
						"	FOREIGN KEY(cr_courseNumber) \n"+
						"		REFERENCES Course(cr_courseNumber)\n"+
					")\n";

				String CREATE_Department_QUERY = "CREATE TABLE Department (\n"+
						"dp_departmentID VARCHAR(255) PRIMARY KEY\n"+
						")\n";

				String CREATE_ThesisCommittee_QUERY = 
					"CREATE TABLE ThesisCommittee (\n"+
						"tc_ID VARCHAR(255) PRIMARY KEY,\n"+
						"fc_name1_same VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
						"fc_name2_same VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
						"fc_name3_same VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
						"fc_name1_diff VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
						"CONSTRAINT fk_ThesisCommittee_from_Faculty_same1\n"+
						"	FOREIGN KEY(fc_name) \n"+
						"		REFERENCES Faculty(fc_name)\n"+
						"CONSTRAINT fk_ThesisCommittee_from_Faculty_same2\n"+
						"	FOREIGN KEY(fc_name) \n"+
						"		REFERENCES Faculty(fc_name)\n"+
						"CONSTRAINT fk_ThesisCommittee_from_Faculty_same3\n"+
						"	FOREIGN KEY(fc_name) \n"+
						"		REFERENCES Faculty(fc_name)\n"+
						"CONSTRAINT fk_ThesisCommittee_from_Faculty_diff\n"+
						"	FOREIGN KEY(fc_name) \n"+
						"		REFERENCES Faculty(fc_name)\n"+
					")\n";
				
				String CREATE_st_take_s_QUERY = 
					"CREATE TABLE st_take_s (\n"+
						"st_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
					    "s_sectionID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
					    "take_enrollmentStatus VARCHAR(255),\n"+
					    "take_gradingOption VARCHAR(255)\n"+
						"CONSTRAINT pk_st_take_s_group\n"+
						"	PRIMARY KEY(st_ID, s_sectionID)\n"+
						"CONSTRAINT fk_st_take_s_from_Student\n"+
						"	FOREIGN KEY(st_ID) \n"+
						"		REFERENCES Student(st_ID)\n"+
						"CONSTRAINT fk_st_take_s_from_Section\n"+
						"	FOREIGN KEY(s_sectionID) \n"+
						"		REFERENCES Section(s_sectionID)\n"+
					")\n";

				String CREATE_s_require_bk_QUERY = 
					"CREATE TABLE s_require_bk (\n"+
						"s_sectionID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
					    "bk_ISBN VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
						"CONSTRAINT pk_s_require_bk_group\n"+
							"PRIMARY KEY(s_sectionID, bk_ISBN)\n"+
						"CONSTRAINT fk_s_require_bk_from_Section\n"+
						"	FOREIGN KEY(s_sectionID) \n"+
						"		REFERENCES Course(s_sectionID)\n"+
						"CONSTRAINT fk_s_require_bk_from_Book\n"+
						"	FOREIGN KEY(bk_ISBN) \n"+
						"		REFERENCES Book(bk_ISBN)\n"+
					")\n";
				
				String CREATE_s_hold_wk_QUERY = 
					"CREATE TABLE s_hold_wk (\n"+
						"s_sectionID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
					    "wk_location VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
					    "wk_time VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
					    "wk_meetingType VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
					    "wk_dayOfWeek VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
						"CONSTRAINT pk_s_hold_wk_group\n"+
							"PRIMARY KEY(s_sectionID, wk_location, wk_time, wk_meetingType, wk_dayOfWeek)\n"+
						"CONSTRAINT fk_s_hold_wk_from_Section\n"+
						"	FOREIGN KEY(s_sectionID) \n"+
						"		REFERENCES Course(s_sectionID)\n"+
						"CONSTRAINT fk_s_hold_wk_from_WeeklyMeeting_location\n"+
						"	FOREIGN KEY(wk_location) \n"+
						"		REFERENCES WeeklyMeeting(wk_location)\n"+
						"CONSTRAINT fk_s_hold_wk_from_WeeklyMeeting_time\n"+
						"	FOREIGN KEY(wk_time) \n"+
						"		REFERENCES WeeklyMeeting(wk_time)\n"+
						"CONSTRAINT fk_s_hold_wk_from_WeeklyMeeting_meetingType\n"+
						"	FOREIGN KEY(wk_meetingType) \n"+
						"		REFERENCES WeeklyMeeting(wk_meetingType)\n"+
						"CONSTRAINT fk_s_hold_wk_from_WeeklyMeeting_weekOfWeek\n"+
						"	FOREIGN KEY(wk_dayOfWeek) \n"+
						"		REFERENCES WeeklyMeeting(wk_dayOfWeek)\n"+
					")\n";

				String CREATE_s_hold_rv_QUERY = 
					"CREATE TABLE s_hold_rv (\n"+
						"s_sectionID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
					    "rv_location VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
					    "rv_time VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
					    "rv_date VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
						"CONSTRAINT pk_s_hold_rv_group\n"+
							"PRIMARY KEY(s_sectionID, rv_location, rv_time, )\n"+
						"CONSTRAINT fk_s_hold_rv_from_Section\n"+
						"	FOREIGN KEY(s_sectionID) \n"+
						"		REFERENCES Course(s_sectionID)\n"+
						"CONSTRAINT fk_s_hold_rv_from_ReviewSession_location\n"+
						"	FOREIGN KEY(rv_location) \n"+
						"		REFERENCES ReviewSession(rv_location)\n"+
						"CONSTRAINT fk_s_hold_rv_from_ReviewSession_time\n"+
						"	FOREIGN KEY(rv_time) \n"+
						"		REFERENCES ReviewSession(rv_time)\n"+
						"CONSTRAINT fk_s_hold_rv_from_ReviewSession_date\n"+
						"	FOREIGN KEY(rv_date) \n"+
						"		REFERENCES ReviewSession(rv_date)\n"+
					")\n";
				
				String CREATE_requestConsent_QUERY = 
					"CREATE TABLE requestConsent (\n"+
						"s_sectionID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
					    "fc_name VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
					    "st_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
					    "rc_result VARCHAR(255),\n"+
						"CONSTRAINT pk_requestConsent_group\n"+
							"PRIMARY KEY(s_sectionID, fc_name, st_ID)\n"+
						"CONSTRAINT fk_requestConsent_from_Course\n"+
						"	FOREIGN KEY(s_sectionID) \n"+
						"		REFERENCES Course(s_sectionID)\n"+
						"CONSTRAINT fk_requestConsent_from_Faculty\n"+
						"	FOREIGN KEY(fc_name) \n"+
						"		REFERENCES Faculty(fc_name)\n"+
						"CONSTRAINT fk_requestConsent_from_Student\n"+
						"	FOREIGN KEY(st_ID) \n"+
						"		REFERENCES Student(st_ID)\n"+
					")\n";

				String CREATE_prerequisite_QUERY = 
					"CREATE TABLE prerequisite (\n"+
						"s_sectionID_main VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
					    "s_sectionID_preq VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
						"CONSTRAINT pk_prerequisite_group\n"+
							"PRIMARY KEY(s_sectionID_main, s_sectionID_preq)\n"+
						"CONSTRAINT fk_prerequisite_from_Course_main\n"+
						"	FOREIGN KEY(s_sectionID) \n"+
						"		REFERENCES Course(s_sectionID)\n"+
						"CONSTRAINT fk_prerequisite_from_Course_preq\n"+
						"	FOREIGN KEY(s_sectionID) \n"+
						"		REFERENCES Course(s_sectionID)	\n"+
					")\n";
				
				String CREATE_dp_offer_cr_QUERY = 
					"CREATE TABLE dp_offer_cr (\n"+
						"s_sectionID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
						"dp_departmentID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
						"CONSTRAINT pk_dp_offer_cr_group\n"+
							"PRIMARY KEY(s_sectionID, dp_departmentID)\n"+
						"CONSTRAINT fk_dp_offer_cr_from_Course\n"+
						"	FOREIGN KEY(s_sectionID) \n"+
						"		REFERENCES Course(s_sectionID)\n"+
						"CONSTRAINT fk_fc_belong_dp_from_Department\n"+
						"	FOREIGN KEY(dp_departmentID) \n"+
						"		REFERENCES Department(dp_departmentID)\n"+
					")\n";

				String CREATE_cr_offer_cl_QUERY = 
					"CREATE TABLE cr_offer_cl (\n"+
						"s_sectionID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
					    "cl_title VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
					    "cl_year INT GENERATED ALWAYS AS IDENTITY,\n"+
					    "cl_quarter VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
						"CONSTRAINT pk_cr_offer_cl_group\n"+
							"PRIMARY KEY(s_sectionID, cl_year, cl_quarter, fc_name)\n"+
						"CONSTRAINT fk_cr_offer_cl_from_Course\n"+
						"	FOREIGN KEY(s_sectionID) \n"+
						"		REFERENCES Course(s_sectionID)\n"+
						"CONSTRAINT fk_cr_offer_cl_from_ClassTitle\n"+
						"	FOREIGN KEY(cl_title) \n"+
						"		REFERENCES Class(cl_title)\n"+
						"CONSTRAINT fk_cr_offer_cl_from_ClassYear\n"+
						"	FOREIGN KEY(cl_year) \n"+
						"		REFERENCES Class(cl_year)\n"+
						"CONSTRAINT fk_cr_offer_cl_from_ClassQuarter\n"+
						"	FOREIGN KEY(cl_quarter) \n"+
						"		REFERENCES Class(cl_quarter)\n"+
					")\n";
				
				String CREATE_fc_belong_dp_QUERY = 
					"CREATE TABLE fc_belong_dp (\n"+
					    "fc_name VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
						"dp_departmentID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
						"CONSTRAINT pk_fc_belong_dp_group\n"+
							"PRIMARY KEY(fc_name, dp_departmentID)\n"+
						"CONSTRAINT fk_fc_belong_dp_from_Faculty\n"+
						"	FOREIGN KEY(fc_name) \n"+
						"		REFERENCES Faculty(fc_name)\n"+
						"CONSTRAINT fk_fc_belong_dp_from_Department\n"+
						"	FOREIGN KEY(dp_departmentID) \n"+
						"		REFERENCES Department(dp_departmentID)\n"+
					")\n";

				String CREATE_qualify_QUERY = 
					"CREATE TABLE qualify (\n"+
					    "cl_title VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
					    "cl_year INT GENERATED ALWAYS AS IDENTITY,\n"+
					    "cl_quarter VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
					    "fc_name VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
						"CONSTRAINT pk_qualify_group\n"+
							"PRIMARY KEY(cl_title, cl_year, cl_quarter, fc_name)\n"+
						"CONSTRAINT fk_qualify_from_ClassTitle\n"+
						"	FOREIGN KEY(cl_title) \n"+
						"		REFERENCES Class(cl_title)\n"+
						"CONSTRAINT fk_qualify_from_ClassYear\n"+
						"	FOREIGN KEY(cl_year) \n"+
						"		REFERENCES Class(cl_year)\n"+
						"CONSTRAINT fk_qualify_from_ClassQuarter\n"+
						"	FOREIGN KEY(cl_quarter) \n"+
						"		REFERENCES Class(cl_quarter)\n"+
						"CONSTRAINT fk_qualify_from_Faculty\n"+
						"	FOREIGN KEY(fc_name) \n"+
						"		REFERENCES Faculty(fc_name)\n"+
					")\n";
				
				String CREATE_teach_QUERY = 
					"CREATE TABLE teach (\n"+
						"s_sectionID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
					    "fc_name VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
						"CONSTRAINT pk_teach_group\n"+
							"PRIMARY KEY(s_sectionID, fc_name)\n"+
						"CONSTRAINT fk_teach_from_Section\n"+
						"	FOREIGN KEY(s_sectionID) \n"+
						"		REFERENCES Section(s_sectionID)\n"+
						"CONSTRAINT fk_teach_from_Faculty\n"+
						"	FOREIGN KEY(fc_name) \n"+
						"		REFERENCES Faculty(fc_name)\n"+
					")\n";

				String CREATE_split_QUERY = 
					"CREATE TABLE split (\n"+
						"s_sectionID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
					    "cl_title VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
					    "cl_year INT GENERATED ALWAYS AS IDENTITY,\n"+
					    "cl_quarter VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
						"CONSTRAINT pk_split_group\n"+
							"PRIMARY KEY(s_sectionID, cl_title, cl_year, cl_quarter)\n"+
						"CONSTRAINT fk_split_from_Class\n"+
						"	FOREIGN KEY(s_sectionID) \n"+
						"		REFERENCES Section(s_sectionID)\n"+
						"CONSTRAINT fk_split_from_ClassTitle\n"+
						"	FOREIGN KEY(cl_title) \n"+
						"		REFERENCES Class(cl_title)\n"+
						"CONSTRAINT fk_split_from_ClassYear\n"+
						"	FOREIGN KEY(cl_year) \n"+
						"		REFERENCES Class(cl_year)\n"+
						"CONSTRAINT fk_split_from_ClassQuarter\n"+
						"	FOREIGN KEY(cl_quarter) \n"+
						"		REFERENCES Class(cl_quarter)\n"+
					")\n";
				
				String CREATE_academicHistory_QUERY = 
					"CREATE TABLE academicHistory (\n"+
						"st_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
					    "cl_title VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
					    "cl_year INT GENERATED ALWAYS AS IDENTITY,\n"+
					    "cl_quarter VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
					    "past_current  VARCHAR(255),\n"+
					    "grade VARCHAR(255),\n"+
						"CONSTRAINT pk_academicHistory_group\n"+
							"PRIMARY KEY(st_ID, cl_title, cl_year, cl_quarter)\n"+
						"CONSTRAINT fk_academicHistory_from_Student\n"+
						"	FOREIGN KEY(st_ID) \n"+
						"		REFERENCES Student(st_ID)\n"+
						"CONSTRAINT fk_academicHistory_from_ClassTitle\n"+
						"	FOREIGN KEY(cl_title) \n"+
						"		REFERENCES Class(cl_title)\n"+
						"CONSTRAINT fk_academicHistory_from_ClassYear\n"+
						"	FOREIGN KEY(cl_year) \n"+
						"		REFERENCES Class(cl_year)\n"+
						"CONSTRAINT fk_academicHistory_from_ClassQuarter\n"+
						"	FOREIGN KEY(cl_quarter) \n"+
						"		REFERENCES Class(cl_quarter)\n"+
					")\n";
				
				String CREATE_program_QUERY = 
					"CREATE TABLE program (\n"+
						"st_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
					    "dg_majorCode VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
						"CONSTRAINT pk_program_group\n"+
							"PRIMARY KEY(st_ID, dg_majorCode)\n"+
						"CONSTRAINT fk_program_from_Student\n"+
						"	FOREIGN KEY(st_ID) \n"+
						"		REFERENCES Student(st_ID)\n"+
						"CONSTRAINT fk_program_from_Degree\n"+
						"	FOREIGN KEY(dg_majorCode) \n"+
						"		REFERENCES Degree(dg_majorCode)\n"+
					")\n";

				String CREATE_dp_require_dg_QUERY = 
					"CREATE TABLE dp_require_dg (\n"+
						"dg_majorCode VARCHAR(255)GENERATED ALWAYS AS IDENTITY,\n"+
					    "dp_departmentID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
					    "totalUnit VARCHAR(255),\n"+
						"CONSTRAINT pk_dp_require_dg_group\n"+
							"PRIMARY KEY(dg_majorCode, dp_departmentID)\n"+
						"CONSTRAINT fk_dp_require_dg_from_Department\n"+
						"	FOREIGN KEY(dp_departmentID) \n"+
						"		REFERENCES Department(dp_departmentID)\n"+
						"CONSTRAINT fk_dp_require_dg_from_Degree\n"+
						"	FOREIGN KEY(dg_majorCode) \n"+
						"		REFERENCES Degree(dg_majorCode)\n"+
					")\n";
				
				String CREATE_gd_belong_dp_QUERY = 
					"CREATE TABLE gd_belong_dp (\n"+
						"gd_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
					    "dp_departmentID VARCHAR(255) ENERATED ALWAYS AS IDENTITY,\n"+
						"CONSTRAINT pk_gd_belong_dp_group\n"+
							"PRIMARY KEY(gd_ID, dp_departmentID)\n"+
						"CONSTRAINT fk_gd_belong_dp_from_Graduate\n"+
						"	FOREIGN KEY(gd_ID) \n"+
						"		REFERENCES Graduate(gd_ID)\n"+
						"CONSTRAINT fk_gd_belong_dp_from_Department\n"+
						"	FOREIGN KEY(dp_departmentID) \n"+
						"		REFERENCES Department(dp_departmentID)\n"+
					")\n";

				String CREATE_advise_QUERY = 
					"CREATE TABLE advise (\n"+
						"cd_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
					    "tc_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
						"CONSTRAINT pk_advise_group\n"+
							"PRIMARY KEY(cd_ID, tc_ID)\n"+
						"CONSTRAINT fk_advise_from_ThesisCommittee\n"+
						"	FOREIGN KEY(tc_ID) \n"+
						"		REFERENCES ThesisCommittee(tc_ID)\n"+
						"CONSTRAINT fk_advise_from_Candidate\n"+
						"	FOREIGN KEY(cd_ID) \n"+
						"		REFERENCES Candidate(cd_ID)\n"+
					")\n";
				
				String CREATE_consist_QUERY = 
					"CREATE TABLE consist (\n"+
						"tc_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
					    "fc_name VARCHAR(255) GENERATED ALWAYS AS IDENTITY,\n"+
						"CONSTRAINT pk_consist_group\n"+
							"PRIMARY KEY(tc_ID, fc_name)\n"+
						"CONSTRAINT fk_consist_from_ThesisCommittee\n"+
						"	FOREIGN KEY(tc_ID) \n"+
						"		REFERENCES ThesisCommittee(tc_ID)\n"+
						"CONSTRAINT fk_consist_from_Faculty\n"+
						"	FOREIGN KEY(fc_name) \n"+
						"		REFERENCES Faculty(fc_name)\n"+
					")\n";

				
				// Make a connection to the driver
				Connection connection = DriverManager.getConnection
				("jdbc:postgresql:tritonlink?user=postgres&password=helloworld");
				
				Statement stmt = connection.createStatement();

				stmt.executeQuery(CREATE_Student_QUERY);
				stmt.executeQuery(CREATE_st_AttendancePeriod_QUERY);
				stmt.executeQuery(CREATE_st_Degree_QUERY);
				stmt.executeQuery(CREATE_st_Probation_QUERY);
				stmt.executeQuery(CREATE_Undergraduate_QUERY);
				stmt.executeQuery(CREATE_Graduate_QUERY);
				stmt.executeQuery(CREATE_MS_QUERY);
				stmt.executeQuery(CREATE_BSMS_QUERY);
				stmt.executeQuery(CREATE_PhD_QUERY);
				stmt.executeQuery(CREATE_Pre_candidate_QUERY);
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
				stmt.executeQuery(CREATE_cr_pastCourseNumber_QUERY);
				stmt.executeQuery(CREATE_cr_gradeOption_QUERY);
				stmt.executeQuery(CREATE_Department_QUERY);
				stmt.executeQuery(CREATE_ThesisCommittee_QUERY);
				stmt.executeQuery(CREATE_st_take_s_QUERY);
				stmt.executeQuery(CREATE_s_require_bk_QUERY);
				stmt.executeQuery(CREATE_s_hold_wk_QUERY);
				stmt.executeQuery(CREATE_s_hold_rv_QUERY);
				stmt.executeQuery(CREATE_requestConsent_QUERY);
				stmt.executeQuery(CREATE_prerequisite_QUERY);
				stmt.executeQuery(CREATE_dp_offer_cr_QUERY);
				stmt.executeQuery(CREATE_cr_offer_cl_QUERY);
				stmt.executeQuery(CREATE_fc_belong_dp_QUERY);
				stmt.executeQuery(CREATE_qualify_QUERY);
				stmt.executeQuery(CREATE_teach_QUERY);
				stmt.executeQuery(CREATE_split_QUERY);
				stmt.executeQuery(CREATE_academicHistory_QUERY);
				stmt.executeQuery(CREATE_program_QUERY);
				stmt.executeQuery(CREATE_dp_require_dg_QUERY);
				stmt.executeQuery(CREATE_gd_belong_dp_QUERY);
				stmt.executeQuery(CREATE_advise_QUERY);
				stmt.executeQuery(CREATE_consist_QUERY);
				%>

</body>
</html>

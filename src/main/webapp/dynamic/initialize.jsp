[[[[[[[[[[[[[[[[[[student]]]]]]]]]]]]]]]]]]

CREATE TABLE Student (
	st_ID VARCHAR(255) PRIMARY KEY,
	st_SSN VARCHAR(255) UNIQUE NOT NULL,
	st_enrollmentStatus VARCHAR(255) NOT NULL,
	st_residential VARCHAR(255)  NOT NULL,
	st_firstName VARCHAR(255)  NOT NULL,
	st_middleName VARCHAR(255) ,
	st_lastName VARCHAR(255)  NOT NULL
);

CREATE TABLE st_AttendancePeriod (
	st_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
	st_year INT ,
	st_quarter VARCHAR(255),
	PRIMARY KEY(st_ID),
	CONSTRAINT fk_st_AttendancePeriod_from_Student
		FOREIGN KEY(st_ID) 
			REFERENCES Student(st_ID)
);

CREATE TABLE st_Degree (
	st_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
	st_Institution VARCHAR(255),
	st_level VARCHAR(255),
	st_date int,
	PRIMARY KEY(st_ID),
	CONSTRAINT fk_st_Degree_from_Student
		FOREIGN KEY(st_ID) 
			REFERENCES Student(st_ID)
);

CREATE TABLE st_Probation (
	st_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
	st_startDate VARCHAR(255),
	st_endDate VARCHAR(255),
	st_reason VARCHAR(255),
	PRIMARY KEY(st_ID),
	CONSTRAINT fk_st_Probation_from_Student
		FOREIGN KEY(st_ID) 
			REFERENCES Student(st_ID)
);

CREATE TABLE Undergraduate (
	ug_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
	ug_major VARCHAR(255),
	ug_minor VARCHAR(255),
	PRIMARY KEY(ug_ID),
	CONSTRAINT fk_Undergraduate_from_Student
		FOREIGN KEY(st_ID) 
			REFERENCES Student(st_ID)
);

CREATE TABLE Graduate (
	gd_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
	PRIMARY KEY(gd_ID),
	CONSTRAINT fk_Graduate_from_Student
		FOREIGN KEY(st_ID) 
			REFERENCES Student(st_ID)
);

CREATE TABLE MS (
	ms_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
	PRIMARY KEY(ms_ID),
	CONSTRAINT fk_MS_from_Graduate
		FOREIGN KEY(gd_ID) 
			REFERENCES Graduate(gd_ID)
);

CREATE TABLE BSMS (
	bsms_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
	PRIMARY KEY(bsms_ID),
	CONSTRAINT fk_BSMS_from_Undergraduate_MS
		FOREIGN KEY(ug_ID) 
			REFERENCES Undergraduate(ug_ID)
		FOREIGN KEY(ms_ID) 
			REFERENCES MS(ms_ID)
);

CREATE TABLE PhD (
	ph_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
	PRIMARY KEY(ph_ID),
	CONSTRAINT fk_PhD_from_Graduate
		FOREIGN KEY(gd_ID) 
			REFERENCES Graduate(gd_ID)
);

CREATE TABLE Pre-candidate (
	pre_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
	PRIMARY KEY(pre_ID),
	CONSTRAINT fk_Pre-candidate_from_PhD
		FOREIGN KEY(ph_ID) 
			REFERENCES PhD(ph_ID)
);

CREATE TABLE Candidate (
	cd_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
	cd_advisor VARCHAR(255),
	PRIMARY KEY(cd_ID),
	CONSTRAINT fk_Candidate_from_PhD
		FOREIGN KEY(ph_ID) 
			REFERENCES PhD(ph_ID)
);


[[[[[[[[[[[[[[[[[[book]]]]]]]]]]]]]]]]]]


CREATE TABLE Book (
	bk_ISBN INT PRIMARY KEY,
	bk_title VARCHAR(255) NOT NULL,
	bk_edition INT ,
	bk_publisher VARCHAR(255) NOT NULL
);

CREATE TABLE Author (
	au_ISBN INT GENERATED ALWAYS AS IDENTITY,
	au_firstName VARCHAR(255),
	au_lastName VARCHAR(255),
	PRIMARY KEY(au_ISBN),
	CONSTRAINT fk_Author_from_Book
		FOREIGN KEY(bk_ISBN) 
			REFERENCES Book(bk_ISBN)
);


[[[[[[[[[[[[[[[[[[section]]]]]]]]]]]]]]]]]]


CREATE TABLE Section (
	s_sectionID VARCHAR(255) PRIMARY KEY,
	s_limitCapacity INT
);


[[[[[[[[[[[[[[[[[[weekly]]]]]]]]]]]]]]]]]]


CREATE TABLE WeeklyMeeting (
	wk_location VARCHAR(255) ,
	wk_time VARCHAR(255) ,
	wk_meetingType VARCHAR(255) ,
	wk_dayOfWeek VARCHAR(255) ,
	wk_attendanceType VARCHAR(255)
	CONSTRAINT pk_WeeklyMeeting_group
		PRIMARY KEY(wk_location, wk_time, wk_meetingType, wk_dayOfWeek)
);


[[[[[[[[[[[[[[[[[[review]]]]]]]]]]]]]]]]]]


CREATE TABLE ReviewSession (
	rv_location VARCHAR(255) ,
	rv_time VARCHAR(255) ,
	rv_date VARCHAR(255)
	CONSTRAINT pk_ReviewSession_group
		PRIMARY KEY(rv_location, rv_time, rv_date)
);


[[[[[[[[[[[[[[[[[[faculty]]]]]]]]]]]]]]]]]]


CREATE TABLE Faculty (
	fc_name VARCHAR(255) PRIMARY KEY
);

CREATE TABLE Professor (
	fc_pf_name VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
	PRIMARY KEY(fc_pf_name),
	CONSTRAINT fk_Professor_from_Faculty
		FOREIGN KEY(fc_name) 
			REFERENCES Faculty(fc_name)
);

CREATE TABLE Lecturer (
	fc_lc_name VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
	PRIMARY KEY(fc_lc_name),
	CONSTRAINT fk_Lecturer_from_Faculty
		FOREIGN KEY(fc_name) 
			REFERENCES Faculty(fc_name)
);

CREATE TABLE Associate (
	fc_asc_name VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
	PRIMARY KEY(fc_asc_name),
	CONSTRAINT fk_Associate_from_Faculty
		FOREIGN KEY(fc_name) 
			REFERENCES Faculty(fc_name)
);

CREATE TABLE Assistant (
	fc_ast_name VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
	PRIMARY KEY(fc_ast_name),
	CONSTRAINT fk_Assistant_from_Faculty
		FOREIGN KEY(fc_name) 
			REFERENCES Faculty(fc_name)
);


[[[[[[[[[[[[[[[[[[course]]]]]]]]]]]]]]]]]]


CREATE TABLE Course (
	cr_courseNumber INT PRIMARY KEY,
	cr_lab VARCHAR(255)
);

CREATE TABLE RangedUnitCourse (
	cr_ru_courseNumber INT GENERATED ALWAYS AS IDENTITY,
	cr_ru_minUnit INT,
	cr_ru_maxUnit INT,
	PRIMARY KEY(cr_ru_courseNumber),
	CONSTRAINT fk_RangedUnitCourse_from_Course
		FOREIGN KEY(cr_courseNumber) 
			REFERENCES Course(cr_courseNumber)
);

CREATE TABLE FixedUnitCourse (
	cr_fu_courseNumber INT GENERATED ALWAYS AS IDENTITY,
	cr_fu_Unit INT,
	PRIMARY KEY(cr_fu_courseNumber),
	CONSTRAINT fk_FixedUnitCourse_from_Course
		FOREIGN KEY(cr_courseNumber) 
			REFERENCES Course(cr_courseNumber)
);

CREATE TABLE cr_pastCourseNumber (
	cr_pc_courseNumber INT GENERATED ALWAYS AS IDENTITY,
	cr_pc_changedYear INT,
	PRIMARY KEY(cr_pc_courseNumber),
	CONSTRAINT fk_cr_pastCourseNumber_from_Course
		FOREIGN KEY(cr_courseNumber) 
			REFERENCES Course(cr_courseNumber)
);

CREATE TABLE cr_gradeOption (
	cr_go_courseNumber INT GENERATED ALWAYS AS IDENTITY,
	cr_go_option VARCHAR(255),
	PRIMARY KEY(cr_go_courseNumber),
	CONSTRAINT fk_cr_gradeOption_from_Course
		FOREIGN KEY(cr_courseNumber) 
			REFERENCES Course(cr_courseNumber)
);


[[[[[[[[[[[[[[[[[[department]]]]]]]]]]]]]]]]]]


CREATE TABLE Department (
	dp_departmentID VARCHAR(255) PRIMARY KEY
);


[[[[[[[[[[[[[[[[[[commitee]]]]]]]]]]]]]]]]]]


CREATE TABLE ThesisCommittee (
	tc_ID VARCHAR(255) PRIMARY KEY,
	fc_name1_same VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
	fc_name2_same VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
	fc_name3_same VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
	fc_name1_diff VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
	CONSTRAINT fk_ThesisCommittee_from_Faculty_same1
		FOREIGN KEY(fc_name) 
			REFERENCES Faculty(fc_name)
	CONSTRAINT fk_ThesisCommittee_from_Faculty_same2
		FOREIGN KEY(fc_name) 
			REFERENCES Faculty(fc_name)
	CONSTRAINT fk_ThesisCommittee_from_Faculty_same3
		FOREIGN KEY(fc_name) 
			REFERENCES Faculty(fc_name)
	CONSTRAINT fk_ThesisCommittee_from_Faculty_diff
		FOREIGN KEY(fc_name) 
			REFERENCES Faculty(fc_name)
);


[[[[[[[[[[[[[[[[[[st_take_s]]]]]]]]]]]]]]]]]]
[[[[[[[[[[[[[[[[[[Student - Section]]]]]]]]]]]]]]]]]]
CREATE TABLE st_take_s (
	st_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
    s_sectionID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
    take_enrollmentStatus VARCHAR(255),
    take_gradingOption VARCHAR(255)
	CONSTRAINT pk_st_take_s_group
		PRIMARY KEY(st_ID, s_sectionID)
	CONSTRAINT fk_st_take_s_from_Student
		FOREIGN KEY(st_ID) 
			REFERENCES Student(st_ID)		
	CONSTRAINT fk_st_take_s_from_Section
		FOREIGN KEY(s_sectionID) 
			REFERENCES Section(s_sectionID)
);


[[[[[[[[[[[[[[[[[[s_require_bk]]]]]]]]]]]]]]]]]]
[[[[[[[[[[[[[[[[[[Section - Book]]]]]]]]]]]]]]]]]]
CREATE TABLE s_require_bk (
	s_sectionID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
    bk_ISBN VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
	CONSTRAINT pk_s_require_bk_group
		PRIMARY KEY(s_sectionID, bk_ISBN)
	CONSTRAINT fk_s_require_bk_from_Section
		FOREIGN KEY(s_sectionID) 
			REFERENCES Course(s_sectionID)		
	CONSTRAINT fk_s_require_bk_from_Book
		FOREIGN KEY(bk_ISBN) 
			REFERENCES Book(bk_ISBN)
);


[[[[[[[[[[[[[[[[[[s_hold_wk]]]]]]]]]]]]]]]]]]
[[[[[[[[[[[[[[[[[[Section - WeeklyMeeting]]]]]]]]]]]]]]]]]]
CREATE TABLE s_hold_wk (
	s_sectionID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
    wk_location VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
    wk_time VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
    wk_meetingType VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
    wk_dayOfWeek VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
	CONSTRAINT pk_s_hold_wk_group
		PRIMARY KEY(s_sectionID, wk_location, wk_time, wk_meetingType, wk_dayOfWeek)
	CONSTRAINT fk_s_hold_wk_from_Section
		FOREIGN KEY(s_sectionID) 
			REFERENCES Course(s_sectionID)		
	CONSTRAINT fk_s_hold_wk_from_WeeklyMeeting_location
		FOREIGN KEY(wk_location) 
			REFERENCES WeeklyMeeting(wk_location)
	CONSTRAINT fk_s_hold_wk_from_WeeklyMeeting_time
		FOREIGN KEY(wk_time) 
			REFERENCES WeeklyMeeting(wk_time)
	CONSTRAINT fk_s_hold_wk_from_WeeklyMeeting_meetingType
		FOREIGN KEY(wk_meetingType) 
			REFERENCES WeeklyMeeting(wk_meetingType)
	CONSTRAINT fk_s_hold_wk_from_WeeklyMeeting_weekOfWeek
		FOREIGN KEY(wk_dayOfWeek) 
			REFERENCES WeeklyMeeting(wk_dayOfWeek)
);


[[[[[[[[[[[[[[[[[[s_hold_rv]]]]]]]]]]]]]]]]]]
[[[[[[[[[[[[[[[[[[Section - ReviewSession]]]]]]]]]]]]]]]]]]
CREATE TABLE s_hold_rv (
	s_sectionID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
    rv_location VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
    rv_time VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
    rv_date VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
	CONSTRAINT pk_s_hold_rv_group
		PRIMARY KEY(s_sectionID, rv_location, rv_time, )
	CONSTRAINT fk_s_hold_rv_from_Section
		FOREIGN KEY(s_sectionID) 
			REFERENCES Course(s_sectionID)		
	CONSTRAINT fk_s_hold_rv_from_ReviewSession_location
		FOREIGN KEY(rv_location) 
			REFERENCES ReviewSession(rv_location)
	CONSTRAINT fk_s_hold_rv_from_ReviewSession_time
		FOREIGN KEY(rv_time) 
			REFERENCES ReviewSession(rv_time)
	CONSTRAINT fk_s_hold_rv_from_ReviewSession_date
		FOREIGN KEY(rv_date) 
			REFERENCES ReviewSession(rv_date)
);


[[[[[[[[[[[[[[[[[[requestConsent]]]]]]]]]]]]]]]]]]
[[[[[[[[[[[[[[[[[[Course - Faculty - Student]]]]]]]]]]]]]]]]]]
CREATE TABLE requestConsent (
	s_sectionID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
    fc_name VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
    st_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
    rc_result VARCHAR(255),
	CONSTRAINT pk_requestConsent_group
		PRIMARY KEY(s_sectionID, fc_name, st_ID)
	CONSTRAINT fk_requestConsent_from_Course
		FOREIGN KEY(s_sectionID) 
			REFERENCES Course(s_sectionID)	
	CONSTRAINT fk_requestConsent_from_Faculty
		FOREIGN KEY(fc_name) 
			REFERENCES Faculty(fc_name)
	CONSTRAINT fk_requestConsent_from_Student
		FOREIGN KEY(st_ID) 
			REFERENCES Student(st_ID)
);


[[[[[[[[[[[[[[[[[[prerequisite]]]]]]]]]]]]]]]]]]
[[[[[[[[[[[[[[[[[[Course - Course]]]]]]]]]]]]]]]]]]
CREATE TABLE prerequisite (
	s_sectionID_main VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
    s_sectionID_preq VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
	CONSTRAINT pk_prerequisite_group
		PRIMARY KEY(s_sectionID_main, s_sectionID_preq)
	CONSTRAINT fk_prerequisite_from_Course_main
		FOREIGN KEY(s_sectionID) 
			REFERENCES Course(s_sectionID)		
	CONSTRAINT fk_prerequisite_from_Course_preq
		FOREIGN KEY(s_sectionID) 
			REFERENCES Course(s_sectionID)	
);


[[[[[[[[[[[[[[[[[[dp_offer_cr]]]]]]]]]]]]]]]]]]
[[[[[[[[[[[[[[[[[[Course - Department]]]]]]]]]]]]]]]]]]
CREATE TABLE dp_offer_cr (
	s_sectionID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
	dp_departmentID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
	CONSTRAINT pk_dp_offer_cr_group
		PRIMARY KEY(s_sectionID, dp_departmentID)
	CONSTRAINT fk_dp_offer_cr_from_Course
		FOREIGN KEY(s_sectionID) 
			REFERENCES Course(s_sectionID)		
	CONSTRAINT fk_fc_belong_dp_from_Department
		FOREIGN KEY(dp_departmentID) 
			REFERENCES Department(dp_departmentID)
);


[[[[[[[[[[[[[[[[[[cr_offer_cl]]]]]]]]]]]]]]]]]]
[[[[[[[[[[[[[[[[[[Course - Class]]]]]]]]]]]]]]]]]]
CREATE TABLE cr_offer_cl (
	s_sectionID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
    cl_title VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
    cl_year INT GENERATED ALWAYS AS IDENTITY,
    cl_quarter VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
	CONSTRAINT pk_cr_offer_cl_group
		PRIMARY KEY(s_sectionID, cl_year, cl_quarter, fc_name)
	CONSTRAINT fk_cr_offer_cl_from_Course
		FOREIGN KEY(s_sectionID) 
			REFERENCES Course(s_sectionID)		
	CONSTRAINT fk_cr_offer_cl_from_ClassTitle
		FOREIGN KEY(cl_title) 
			REFERENCES Class(cl_title)
	CONSTRAINT fk_cr_offer_cl_from_ClassYear
		FOREIGN KEY(cl_year) 
			REFERENCES Class(cl_year)
	CONSTRAINT fk_cr_offer_cl_from_ClassQuarter
		FOREIGN KEY(cl_quarter) 
			REFERENCES Class(cl_quarter)
);


[[[[[[[[[[[[[[[[[[fc_belong_dp]]]]]]]]]]]]]]]]]]
[[[[[[[[[[[[[[[[[[Faculty - Department]]]]]]]]]]]]]]]]]]
CREATE TABLE fc_belong_dp (
    fc_name VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
	dp_departmentID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
	CONSTRAINT pk_fc_belong_dp_group
		PRIMARY KEY(fc_name, dp_departmentID)
	CONSTRAINT fk_fc_belong_dp_from_Faculty
		FOREIGN KEY(fc_name) 
			REFERENCES Faculty(fc_name)
	CONSTRAINT fk_fc_belong_dp_from_Department
		FOREIGN KEY(dp_departmentID) 
			REFERENCES Department(dp_departmentID)
);


[[[[[[[[[[[[[[[[[[qualify]]]]]]]]]]]]]]]]]]
[[[[[[[[[[[[[[[[[[Class - Faculty]]]]]]]]]]]]]]]]]]
CREATE TABLE qualify (
    cl_title VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
    cl_year INT GENERATED ALWAYS AS IDENTITY,
    cl_quarter VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
    fc_name VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
	CONSTRAINT pk_qualify_group
		PRIMARY KEY(cl_title, cl_year, cl_quarter, fc_name)
	CONSTRAINT fk_qualify_from_ClassTitle
		FOREIGN KEY(cl_title) 
			REFERENCES Class(cl_title)
	CONSTRAINT fk_qualify_from_ClassYear
		FOREIGN KEY(cl_year) 
			REFERENCES Class(cl_year)
	CONSTRAINT fk_qualify_from_ClassQuarter
		FOREIGN KEY(cl_quarter) 
			REFERENCES Class(cl_quarter)
	CONSTRAINT fk_qualify_from_Faculty
		FOREIGN KEY(fc_name) 
			REFERENCES Faculty(fc_name)
);


[[[[[[[[[[[[[[[[[[teach]]]]]]]]]]]]]]]]]]
[[[[[[[[[[[[[[[[[[Faculty - Section]]]]]]]]]]]]]]]]]]
CREATE TABLE teach (
	s_sectionID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
    fc_name VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
	CONSTRAINT pk_teach_group
		PRIMARY KEY(s_sectionID, fc_name)
	CONSTRAINT fk_teach_from_Section
		FOREIGN KEY(s_sectionID) 
			REFERENCES Section(s_sectionID)		
	CONSTRAINT fk_teach_from_Faculty
		FOREIGN KEY(fc_name) 
			REFERENCES Faculty(fc_name)
);


[[[[[[[[[[[[[[[[[[split]]]]]]]]]]]]]]]]]]
[[[[[[[[[[[[[[[[[[Class - Section]]]]]]]]]]]]]]]]]]
CREATE TABLE split (
	s_sectionID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
    cl_title VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
    cl_year INT GENERATED ALWAYS AS IDENTITY,
    cl_quarter VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
	CONSTRAINT pk_split_group
		PRIMARY KEY(s_sectionID, cl_title, cl_year, cl_quarter)
	CONSTRAINT fk_split_from_Class
		FOREIGN KEY(s_sectionID) 
			REFERENCES Section(s_sectionID)		
	CONSTRAINT fk_split_from_ClassTitle
		FOREIGN KEY(cl_title) 
			REFERENCES Class(cl_title)
	CONSTRAINT fk_split_from_ClassYear
		FOREIGN KEY(cl_year) 
			REFERENCES Class(cl_year)
	CONSTRAINT fk_split_from_ClassQuarter
		FOREIGN KEY(cl_quarter) 
			REFERENCES Class(cl_quarter)
);


[[[[[[[[[[[[[[[[[[academicHistory]]]]]]]]]]]]]]]]]]
[[[[[[[[[[[[[[[[[[Student - Class]]]]]]]]]]]]]]]]]]
CREATE TABLE academicHistory (
	st_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
    cl_title VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
    cl_year INT GENERATED ALWAYS AS IDENTITY,
    cl_quarter VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
    past_current  VARCHAR(255),
    grade VARCHAR(255),
	CONSTRAINT pk_academicHistory_group
		PRIMARY KEY(st_ID, cl_title, cl_year, cl_quarter)
	CONSTRAINT fk_academicHistory_from_Student
		FOREIGN KEY(st_ID) 
			REFERENCES Student(st_ID)		
	CONSTRAINT fk_academicHistory_from_ClassTitle
		FOREIGN KEY(cl_title) 
			REFERENCES Class(cl_title)
	CONSTRAINT fk_academicHistory_from_ClassYear
		FOREIGN KEY(cl_year) 
			REFERENCES Class(cl_year)
	CONSTRAINT fk_academicHistory_from_ClassQuarter
		FOREIGN KEY(cl_quarter) 
			REFERENCES Class(cl_quarter)
);


[[[[[[[[[[[[[[[[[[program]]]]]]]]]]]]]]]]]]
[[[[[[[[[[[[[[[[[[Student - Degree]]]]]]]]]]]]]]]]]]
CREATE TABLE program (
	st_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
    dg_majorCode VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
	CONSTRAINT pk_program_group
		PRIMARY KEY(st_ID, dg_majorCode)
	CONSTRAINT fk_program_from_Student
		FOREIGN KEY(st_ID) 
			REFERENCES Student(st_ID)		
	CONSTRAINT fk_program_from_Degree
		FOREIGN KEY(dg_majorCode) 
			REFERENCES Degree(dg_majorCode)
);


[[[[[[[[[[[[[[[[[[dp_require_dg]]]]]]]]]]]]]]]]]]
[[[[[[[[[[[[[[[[[[Department - Degree]]]]]]]]]]]]]]]]]]
CREATE TABLE dp_require_dg (
	dg_majorCode VARCHAR(255)GENERATED ALWAYS AS IDENTITY,
    dp_departmentID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
    totalUnit VARCHAR(255),
	CONSTRAINT pk_dp_require_dg_group
		PRIMARY KEY(dg_majorCode, dp_departmentID)
	CONSTRAINT fk_dp_require_dg_from_Department
		FOREIGN KEY(dp_departmentID) 
			REFERENCES Department(dp_departmentID)		
	CONSTRAINT fk_dp_require_dg_from_Degree
		FOREIGN KEY(dg_majorCode) 
			REFERENCES Degree(dg_majorCode)
);


[[[[[[[[[[[[[[[[[[gd_belong_dp]]]]]]]]]]]]]]]]]]
[[[[[[[[[[[[[[[[[[Graduate - Department]]]]]]]]]]]]]]]]]]
CREATE TABLE gd_belong_dp (
	gd_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
    dp_departmentID VARCHAR(255) ENERATED ALWAYS AS IDENTITY,
	CONSTRAINT pk_gd_belong_dp_group
		PRIMARY KEY(gd_ID, dp_departmentID)
	CONSTRAINT fk_gd_belong_dp_from_Graduate
		FOREIGN KEY(gd_ID) 
			REFERENCES Graduate(gd_ID)		
	CONSTRAINT fk_gd_belong_dp_from_Department
		FOREIGN KEY(dp_departmentID) 
			REFERENCES Department(dp_departmentID)
);


[[[[[[[[[[[[[[[[[[advise]]]]]]]]]]]]]]]]]]
[[[[[[[[[[[[[[[[[[ThesisCommittee - Candidate]]]]]]]]]]]]]]]]]]
CREATE TABLE advise (
	cd_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
    tc_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
	CONSTRAINT pk_advise_group
		PRIMARY KEY(cd_ID, tc_ID)
	CONSTRAINT fk_advise_from_ThesisCommittee
		FOREIGN KEY(tc_ID) 
			REFERENCES ThesisCommittee(tc_ID)		
	CONSTRAINT fk_advise_from_Candidate
		FOREIGN KEY(cd_ID) 
			REFERENCES Candidate(cd_ID)
);


[[[[[[[[[[[[[[[[[[consist]]]]]]]]]]]]]]]]]]
[[[[[[[[[[[[[[[[[[ThesisCommittee - Faculty]]]]]]]]]]]]]]]]]]
CREATE TABLE consist (
	tc_ID VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
    fc_name VARCHAR(255) GENERATED ALWAYS AS IDENTITY,
	CONSTRAINT pk_consist_group
		PRIMARY KEY(tc_ID, fc_name)
	CONSTRAINT fk_consist_from_ThesisCommittee
		FOREIGN KEY(tc_ID) 
			REFERENCES ThesisCommittee(tc_ID)		
	CONSTRAINT fk_consist_from_Faculty
		FOREIGN KEY(fc_name) 
			REFERENCES Faculty(fc_name)
);

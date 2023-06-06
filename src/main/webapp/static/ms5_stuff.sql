-- Milestone 5 Tables and Stuff

-- MAKING THE MATERIALIZED VIEWS
-- Materialized views implemented with tables

-- Creating the table for CPQG using existing data in the database

CREATE TABLE CPQG AS (
	SELECT p.cr_courseNumber AS course_number, t.fc_name AS professor, 
	   	   p.cl_quarter AS quarter, p.cl_year AS year,
	   	   COUNT(CASE WHEN p.pasttake_grade IN ('A+', 'A', 'A-') THEN 1 END) AS grades_A,
	   	   COUNT(CASE WHEN p.pasttake_grade IN ('B+', 'B', 'B-') THEN 1 END) AS grades_B,
		   COUNT(CASE WHEN p.pasttake_grade IN ('C+', 'C', 'C-') THEN 1 END) AS grades_C,
		   COUNT(CASE WHEN p.pasttake_grade = 'D' THEN 1 END) AS grades_D, 
		   COUNT(CASE WHEN p.pasttake_grade IN ('IN', 'S', 'U', 'F') THEN 1 END) AS grades_other
	FROM pasttake p, teaches t
	WHERE p.s_sectionID = t.s_sectionID
	GROUP BY p.cr_courseNumber, t.fc_name, p.cl_quarter, p.cl_year
	ORDER BY cl_year, 
		CASE cl_quarter 
			WHEN 'WINTER' THEN 1 
			WHEN 'SPRING' THEN 2 
			WHEN 'FALL' THEN 3 
			ELSE 4 END
);

-- Adding foreign key constraints to the CPQG table in case a course or professor is deleted from the database

ALTER TABLE CPQG
ADD CONSTRAINT fk_CPQG_course_number FOREIGN KEY (course_number) REFERENCES course(cr_courseNumber) ON DELETE CASCADE;

ALTER TABLE CPQG
ADD CONSTRAINT fk_CPQG_professor FOREIGN KEY (professor) REFERENCES faculty(fc_name) ON DELETE CASCADE;



-- Creating the table for CPG using existing data in the database

CREATE TABLE CPG AS (
	SELECT p.cr_courseNumber AS course_number, t.fc_name AS professor, 
		   COUNT(CASE WHEN p.pasttake_grade IN ('A+', 'A', 'A-') THEN 1 END) AS grades_A,
	   	   COUNT(CASE WHEN p.pasttake_grade IN ('B+', 'B', 'B-') THEN 1 END) AS grades_B,
		   COUNT(CASE WHEN p.pasttake_grade IN ('C+', 'C', 'C-') THEN 1 END) AS grades_C,
		   COUNT(CASE WHEN p.pasttake_grade = 'D' THEN 1 END) AS grades_D, 
		   COUNT(CASE WHEN p.pasttake_grade IN ('IN', 'S', 'U', 'F') THEN 1 END) AS grades_other
	FROM pasttake p, teaches t
	WHERE p.s_sectionID = t.s_sectionID
	GROUP BY p.cr_courseNumber, t.fc_name
	ORDER BY p.cr_courseNumber, t.fc_name
);

-- Adding foreign key constraints to the CPG table in case a course or professor is deleted from the database

ALTER TABLE CPG
ADD CONSTRAINT fk_CPG_course_number FOREIGN KEY (course_number) REFERENCES course(cr_courseNumber) ON DELETE CASCADE;

ALTER TABLE CPG
ADD CONSTRAINT fk_CPG_professor FOREIGN KEY (professor) REFERENCES faculty(fc_name) ON DELETE CASCADE;


-- TRIGGERS FOR THE MATERIALIZED VIEWS








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

-- Build a trigger that upon entry of a grade in a section by a student, update CPQG and CPG

CREATE OR REPLACE FUNCTION update_cpqg_cpg()
RETURNS TRIGGER AS $$
DECLARE
    professor_name VARCHAR(255);
BEGIN
    -- Get the professor who teaches the section
    SELECT fc_name INTO professor_name
    FROM teaches
    WHERE s_sectionID = NEW.s_sectionID;

    -- Incrementally update CPQG table
    UPDATE CPQG
    SET grades_A = CASE
                      WHEN NEW.pasttake_grade IN ('A+', 'A', 'A-') THEN CPQG.grades_A + 1
                      WHEN OLD.pasttake_grade IN ('A+', 'A', 'A-') THEN CPQG.grades_A - 1
                      ELSE CPQG.grades_A
                   END,
        grades_B = CASE
                      WHEN NEW.pasttake_grade IN ('B+', 'B', 'B-') THEN CPQG.grades_B + 1
                      WHEN OLD.pasttake_grade IN ('B+', 'B', 'B-') THEN CPQG.grades_B - 1
                      ELSE CPQG.grades_B
                   END,
        grades_C = CASE
                      WHEN NEW.pasttake_grade IN ('C+', 'C', 'C-') THEN CPQG.grades_C + 1
                      WHEN OLD.pasttake_grade IN ('C+', 'C', 'C-') THEN CPQG.grades_C - 1
                      ELSE CPQG.grades_C
                   END,
        grades_D = CASE
                      WHEN NEW.pasttake_grade = 'D' THEN CPQG.grades_D + 1
                      WHEN OLD.pasttake_grade = 'D' THEN CPQG.grades_D - 1
                      ELSE CPQG.grades_D
                   END,
        grades_other = CASE
                           WHEN NEW.pasttake_grade IN ('IN', 'S', 'U', 'F') THEN CPQG.grades_other + 1
                           WHEN OLD.pasttake_grade IN ('IN', 'S', 'U', 'F') THEN CPQG.grades_other - 1
                           ELSE CPQG.grades_other
                       END
    WHERE course_number = NEW.cr_courseNumber 
      AND professor = professor_name
      AND quarter = NEW.cl_quarter
      AND year = NEW.cl_year;

    -- Check if no tuple exists in CPQG table for the given combination
    IF NOT FOUND THEN
        INSERT INTO CPQG (course_number, professor, quarter, year, grades_A, grades_B, grades_C, grades_D, grades_other)
        VALUES (NEW.cr_courseNumber, professor_name, NEW.cl_quarter, NEW.cl_year, 
                CASE WHEN NEW.pasttake_grade IN ('A+', 'A', 'A-') THEN 1 ELSE 0 END,
                CASE WHEN NEW.pasttake_grade IN ('B+', 'B', 'B-') THEN 1 ELSE 0 END,
                CASE WHEN NEW.pasttake_grade IN ('C+', 'C', 'C-') THEN 1 ELSE 0 END,
                CASE WHEN NEW.pasttake_grade = 'D' THEN 1 ELSE 0 END,
                CASE WHEN NEW.pasttake_grade IN ('IN', 'S', 'U', 'F') THEN 1 ELSE 0 END);
    END IF;

    -- Incrementally update CPG table
    UPDATE CPG
    SET grades_A = CASE
                      WHEN NEW.pasttake_grade IN ('A+', 'A', 'A-') THEN CPG.grades_A + 1
                      WHEN OLD.pasttake_grade IN ('A+', 'A', 'A-') THEN CPG.grades_A - 1
                      ELSE CPG.grades_A
                   END,
        grades_B = CASE
                      WHEN NEW.pasttake_grade IN ('B+', 'B', 'B-') THEN CPG.grades_B + 1
                      WHEN OLD.pasttake_grade IN ('B+', 'B', 'B-') THEN CPG.grades_B - 1
                      ELSE CPG.grades_B
                   END,
        grades_C = CASE
                      WHEN NEW.pasttake_grade IN ('C+', 'C', 'C-') THEN CPG.grades_C + 1
                      WHEN OLD.pasttake_grade IN ('C+', 'C', 'C-') THEN CPG.grades_C - 1
                      ELSE CPG.grades_C
                   END,
        grades_D = CASE
                      WHEN NEW.pasttake_grade = 'D' THEN CPG.grades_D + 1
                      WHEN OLD.pasttake_grade = 'D' THEN CPG.grades_D - 1
                      ELSE CPG.grades_D
                   END,
        grades_other = CASE
                           WHEN NEW.pasttake_grade IN ('IN', 'S', 'U', 'F') THEN CPG.grades_other + 1
                           WHEN OLD.pasttake_grade IN ('IN', 'S', 'U', 'F') THEN CPG.grades_other - 1
                           ELSE CPG.grades_other
                       END
    WHERE course_number = NEW.cr_courseNumber
      AND professor = professor_name;

    -- Check if no tuple exists in CPG table for the given combination
    IF NOT FOUND THEN
        INSERT INTO CPG (course_number, professor, grades_A, grades_B, grades_C, grades_D, grades_other)
        VALUES (NEW.cr_courseNumber, professor_name,
                CASE WHEN NEW.pasttake_grade IN ('A+', 'A', 'A-') THEN 1 ELSE 0 END,
                CASE WHEN NEW.pasttake_grade IN ('B+', 'B', 'B-') THEN 1 ELSE 0 END,
                CASE WHEN NEW.pasttake_grade IN ('C+', 'C', 'C-') THEN 1 ELSE 0 END,
                CASE WHEN NEW.pasttake_grade = 'D' THEN 1 ELSE 0 END,
                CASE WHEN NEW.pasttake_grade IN ('IN', 'S', 'U', 'F') THEN 1 ELSE 0 END);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger on the pasttake table, so that inserts or updates 
-- will correctly be represented in CPQG and CPG
CREATE TRIGGER update_cpqg_cpg_trigger
AFTER INSERT OR UPDATE ON pasttake
FOR EACH ROW
EXECUTE FUNCTION update_cpqg_cpg();


-- Build a trigger that upon deletion of a grade in a section by a student, update CPQG and CPG

CREATE OR REPLACE FUNCTION update_when_delete_cpqg_cpg()
RETURNS TRIGGER AS $$
DECLARE
    professor_name VARCHAR(255);
BEGIN
    -- Get the professor who teaches the section
    SELECT fc_name INTO professor_name
    FROM teaches
    WHERE s_sectionID = OLD.s_sectionID;

    -- Decrementally update CPQG table
    UPDATE CPQG
    SET grades_A = CASE
                      WHEN OLD.pasttake_grade IN ('A+', 'A', 'A-') THEN CPQG.grades_A - 1
                      ELSE CPQG.grades_A
                   END,
        grades_B = CASE
                      WHEN OLD.pasttake_grade IN ('B+', 'B', 'B-') THEN CPQG.grades_B - 1
                      ELSE CPQG.grades_B
                   END,
        grades_C = CASE
                      WHEN OLD.pasttake_grade IN ('C+', 'C', 'C-') THEN CPQG.grades_C - 1
                      ELSE CPQG.grades_C
                   END,
        grades_D = CASE
                      WHEN OLD.pasttake_grade = 'D' THEN CPQG.grades_D - 1
                      ELSE CPQG.grades_D
                   END,
        grades_other = CASE
                           WHEN OLD.pasttake_grade IN ('IN', 'S', 'U', 'F') THEN CPQG.grades_other - 1
                           ELSE CPQG.grades_other
                       END
    WHERE course_number = OLD.cr_courseNumber 
      AND professor = professor_name
      AND quarter = OLD.cl_quarter
      AND year = OLD.cl_year;

    -- Decrementally update CPG table
    UPDATE CPG
    SET grades_A = CASE
                      WHEN OLD.pasttake_grade IN ('A+', 'A', 'A-') THEN CPG.grades_A - 1
                      ELSE CPG.grades_A
                   END,
        grades_B = CASE
                      WHEN OLD.pasttake_grade IN ('B+', 'B', 'B-') THEN CPG.grades_B - 1
                      ELSE CPG.grades_B
                   END,
        grades_C = CASE
                      WHEN OLD.pasttake_grade IN ('C+', 'C', 'C-') THEN CPG.grades_C - 1
                      ELSE CPG.grades_C
                   END,
        grades_D = CASE
                      WHEN OLD.pasttake_grade = 'D' THEN CPG.grades_D - 1
                      ELSE CPG.grades_D
                   END,
        grades_other = CASE
                           WHEN OLD.pasttake_grade IN ('IN', 'S', 'U', 'F') THEN CPG.grades_other - 1
                           ELSE CPG.grades_other
                       END
    WHERE course_number = OLD.cr_courseNumber
      AND professor = professor_name;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger on the pasttake table, so that deletions 
-- will correctly decrement the grade counts in CPQG and CPG
CREATE TRIGGER update_when_delete_cpqg_cpg_trigger
AFTER DELETE ON pasttake
FOR EACH ROW
EXECUTE FUNCTION update_when_delete_cpqg_cpg();

-- DROP CODE: Code to drop the above
-- DROP TRIGGER IF EXISTS update_cpqg_cpg_trigger ON pasttake;
-- DROP FUNCTION IF EXISTS update_cpqg_cpg();
-- DROP TRIGGER IF EXISTS update_when_delete_cpqg_cpg_trigger ON pasttake;
-- DROP FUNCTION IF EXISTS update_when_delete_cpqg_cpg();



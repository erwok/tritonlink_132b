-- Milestone 4 Triggers -- 

-- PART 2: the enrollment limit then additional should be rejected.

-- CREATE OR REPLACE FUNCTION limit_instances()
-- RETURNS TRIGGER AS $$
-- BEGIN
--     -- Check how many instances of the section 
--     Capacity := SELECT COUNT(*) FROM take 
--     WHERE cr_courseNumber = ? AND cl_title = ? AND cl_year = ? AND cl_quarter = ? AND s_sectionID = ? AND st_id = ?;
    
--     -- if the count is greater than the limit, then raise an exception
--     IF ( SELECT COUNT(*) FROM take 
--          WHERE cr_courseNumber :: VARCHAR(255) = NEW.cr_courseNumber :: VARCHAR(255)
--            AND cl_title :: VARCHAR(255) = NEW.cl_title :: VARCHAR(255)
--            AND cl_year :: INT = NEW.cl_year :: INT
--            AND cl_quarter :: VARCHAR(255) = NEW.cl_quarter :: VARCHAR(255)
--            AND s_sectionID :: VARCHAR(255) = NEW.s_sectionID :: VARCHAR(255)
--         ) > 50 THEN
--         RAISE EXCEPTION 'Error: Cannot update. Maximum capacity exceeded';
--     END IF;
  
--     RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;

-- CREATE TRIGGER trigger_limit_instances
-- BEFORE INSERT OR UPDATE ON take
-- FOR EACH ROW
-- EXECUTE FUNCTION limit_instances();




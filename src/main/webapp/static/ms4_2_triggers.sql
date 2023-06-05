-- Milestone 4 Triggers -- 

-- PART 2: the enrollment limit then additional should be rejected.

-- CREATE OR REPLACE FUNCTION limit_instances()
-- RETURNS TRIGGER AS $$
-- DECLARE
--     count Capacity;
-- BEGIN
--     -- Check how many instances of the section 
--     SELECT COUNT(*) INTO Capacity FROM take 
--     WHERE cr_courseNumber = ? AND cl_title = ? AND cl_year = ? AND cl_quarter = ? AND s_sectionID = ? AND st_id = ?;
    
--     -- if the count is greater than the limit, then raise an exception
--     IF Capacity > 50 THEN
--         RAISE EXCEPTION 'Cannot update. Maximum capacity exceeded';
--     END IF;
  
--     RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;

-- CREATE TRIGGER trigger_limit_instances
-- BEFORE INSERT OR UPDATE ON take
-- FOR EACH ROW
-- EXECUTE FUNCTION limit_instances();




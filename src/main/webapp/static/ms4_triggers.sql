-- Milestone 4 Triggers -- 

-- PART 1:  Section 'LE', 'DI', and 'LAB' separation

CREATE OR REPLACE FUNCTION check_for_overlapping_meetings()
RETURNS TRIGGER AS $$
DECLARE
    new_daysOfWeek text[];
    existing_daysOfWeek text[];
BEGIN
    -- Convert the daysofweek strings to arrays for comparison
    new_daysOfWeek := string_to_array(NEW.daysofweek, ',');
    
    -- Check for overlapping meetings with the same section (s_sectionID)
    IF EXISTS (
        SELECT 1
        FROM weeklymeetings
        WHERE s_sectionid = NEW.s_sectionid
          AND (string_to_array(daysofweek, ',') && new_daysOfWeek)
          AND ((starttime :: time, endtime :: time) OVERLAPS (NEW.starttime :: time, NEW.endtime :: time))
    ) THEN
        RAISE EXCEPTION 'Error: Booked Section % For the Same Time', NEW.s_sectionid;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_for_overlapping_meetings
BEFORE INSERT OR UPDATE ON weeklymeetings
FOR EACH ROW
EXECUTE FUNCTION check_for_overlapping_meetings();


-- PART 2: the enrollment limit then additional should be rejected.

CREATE OR REPLACE FUNCTION limit_instances()
RETURNS TRIGGER AS $$
BEGIN
    -- if the count is greater than the limit, then raise an exception
    IF ( SELECT COUNT(*) FROM take
         WHERE cr_courseNumber = NEW.cr_courseNumber
           AND cl_title = NEW.cl_title
           AND cl_year = NEW.cl_year
           AND cl_quarter = NEW.cl_quarter
           AND s_sectionID = NEW.s_sectionID
        ) >= ( SELECT s_capacity FROM section WHERE s_sectionID = NEW.s_sectionID ) THEN
        RAISE EXCEPTION 'Error: Cannot update. Maximum capacity exceeded';
    END IF;
  
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_limit_instances
BEFORE INSERT ON take
FOR EACH ROW
EXECUTE FUNCTION limit_instances();



-- PART 3: A professor should not have multiple sections at the same time.

CREATE OR REPLACE FUNCTION check_meeting_overlap_for_professor()
  RETURNS TRIGGER AS $$
DECLARE
    new_daysOfWeek text[];
    existing_daysOfWeek text[];
    professor VARCHAR(255);
BEGIN
    -- Convert the daysofweek strings to arrays for comparison
    new_daysOfWeek := string_to_array(NEW.daysofweek, ',');
    
    -- Bring in the professor's name
    SELECT fc_name INTO professor
    FROM teaches t, weeklymeetings w
    WHERE t.s_sectionID = w.s_sectionID;

    -- Check for overlapping meetings with the same section (s_sectionID)
  IF EXISTS (
    SELECT 1
    FROM weeklymeetings w
    JOIN teaches t ON w.s_sectionID = t.s_sectionID
    WHERE t.fc_name = professor
      AND (string_to_array(daysofweek, ',') && new_daysOfWeek)
      AND ((starttime :: time, endtime :: time) OVERLAPS (NEW.starttime :: time, NEW.endtime :: time))
  ) THEN
    RAISE EXCEPTION 'Error: Overlapping meeting time for instructor %', professor;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_meeting_overlap
BEFORE INSERT ON weeklymeetings
FOR EACH ROW
EXECUTE FUNCTION check_meeting_overlap_for_professor();





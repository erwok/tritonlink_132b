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




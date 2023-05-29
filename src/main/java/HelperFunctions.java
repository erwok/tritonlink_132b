import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

public class HelperFunctions {
    
    public static boolean isTimeOverlap(String startTime1, String endTime1, String startTime2, String endTime2) {
        
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("h:mma");

        LocalTime start1 = LocalTime.parse(startTime1.toLowerCase(), formatter);
        LocalTime end1 = LocalTime.parse(endTime1.toLowerCase(), formatter);
        LocalTime start2 = LocalTime.parse(startTime2.toLowerCase(), formatter);
        LocalTime end2 = LocalTime.parse(endTime2.toLowerCase(), formatter);

        // Check for overlap
        return !(end1.isBefore(start2) || start1.isAfter(end2));
    }
    
}

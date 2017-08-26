# utf8 -- By Kyle Smith

This is the utf8 module by Kyle Smith.
The code is for 99% in its original form, the only adaptions done are
-- -- in stead of -- at the start file. This is because the pre-processor in my LoveBuilder will otherwise be very angry as "-- *" is the tag for its own commands.

And I added a "return true" statement at the end. This to prevent multiple calls when called multiple times. The "return true" statements makes sure only one call will be made (when called with "-- *import" that is).

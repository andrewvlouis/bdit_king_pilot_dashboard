﻿DROP VIEW IF EXISTS king_pilot.dash_baseline;

CREATE VIEW king_pilot.dash_baseline AS
SELECT Z.street_name as street, Z.direction, X.day_type, X.period_name AS period, SUM(X.tt)/60.0 AS tt
FROM
( 	SELECT A.bt_id, A.day_type, B.period_name, AVG(A.tt) AS tt
	FROM king_pilot.baselines A
	INNER JOIN king_pilot.periods B USING (day_type)
	INNER JOIN king_pilot.bt_segments C USING (bt_id)
	WHERE A.time_bin <@ B.period_range
	GROUP BY A.bt_id, A.day_type, B.period_name
	) AS X
INNER JOIN king_pilot.bt_corridor_segments Y USING (bt_id)
INNER JOIN king_pilot.bt_corridors Z USING (corridor_id)
WHERE Z.corridor_id NOT IN (6)
GROUP BY Z.corridor_id, Z.corridor_name, X.day_type, X.period_name, Z.segments, Z.street_name, Z.direction
HAVING COUNT(X.*) = Z.segments
ORDER BY Z.corridor_id;
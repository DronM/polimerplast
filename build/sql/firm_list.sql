-- View: firm_list

--DROP VIEW firm_list;

CREATE OR REPLACE VIEW firm_list AS 
	SELECT 
		id,
		name,
		(ext_id IS NOT NULL AND ext_id<>'') match_1c
	FROM firms
	ORDER BY name;
ALTER TABLE firm_list OWNER TO polimerplast;


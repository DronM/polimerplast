/*
DROP function doc_order_calc_quant(
		product_id integer,
		measure_unit_id integer,
		mes_l integer,
		mes_w integer,
		mes_h integer,
		quant numeric		
);
*/
/*
Пересчитывает базовое количество в количество 
в любой единице
*/
CREATE or REPLACE function doc_order_calc_quant(
		product_id integer,
		measure_unit_id integer,
		mes_l integer,
		mes_w integer,
		mes_h integer,
		quant numeric
)
	RETURNS numeric
AS $body$
	WITH q AS (
		SELECT COALESCE(
			eval(
				eval_params(
					(SELECT pmu.calc_formula
					FROM product_measure_units pmu
					WHERE pmu.product_id=$1
					AND pmu.measure_unit_id=$2)
					,$3,$4,$5
				)
			)
		,0) AS v	
	)
	SELECT
		CASE
			WHEN (SELECT q.v FROM q)=0 THEN 0
			ELSE ROUND($6/(SELECT q.v FROM q),4)
		END AS quant
	;
$body$
language sql;
ALTER function doc_order_calc_quant(
		product_id integer,
		measure_unit_id integer,
		mes_l integer,
		mes_w integer,
		mes_h integer,
		quant numeric
) OWNER TO polimerplast;
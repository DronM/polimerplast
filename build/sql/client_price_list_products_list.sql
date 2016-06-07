-- Function: client_price_list_products_list(integer,integer)DROP FUNCTION client_price_list_products_list(integer,integer);CREATE OR REPLACE FUNCTION client_price_list_products_list(	IN in_price_list_id integer,	IN in_product_id integer)  RETURNS TABLE(	price_list_id int,	product_id int,	product_descr text,	measure_unit_id int,	measure_unit_descr text,	price numeric,	price_descr numeric,	discount_volume numeric,	discount_total numeric,	pack_price numeric,	pack_price_descr text	) AS$BODY$	SELECT		$1 AS price_list_id,		p.id AS product_id,		p.name::text AS product_descr,		mu.id AS measure_unit_id,		mu.name::text AS measure_unit_descr,		ROUND(pr.price,2) AS price,		ROUND(pr.price,2) AS price_descr,		ROUND(pr.discount_volume::numeric,0) AS discount_volume,		ROUND(pr.discount_total::numeric,0) AS discount_total,		ROUND(pr.pack_price,2) AS pack_price,		format_money(pr.pack_price) AS pack_price_descr			FROM products AS p	LEFT JOIN measure_units AS mu ON mu.id=p.base_measure_unit_id	LEFT JOIN client_price_list_products AS pr ON pr.price_list_id=$1 AND pr.product_id=p.id	WHERE ($2=0) OR ($2>0 AND $2=p.id)	ORDER BY p.name;$BODY$  LANGUAGE sql VOLATILE  COST 100 ROWS 1000;ALTER FUNCTION client_price_list_products_list(integer,integer) OWNER TO polimerplast;
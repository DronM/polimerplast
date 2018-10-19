-- Function: public.doc_order_totals(integer, integer, integer, integer, integer, integer, numeric, integer, boolean, boolean, boolean, boolean, numeric)

-- DROP FUNCTION public.doc_order_totals(integer, integer, integer, integer, integer, integer, numeric, integer, boolean, boolean, boolean, boolean, numeric);

CREATE OR REPLACE FUNCTION public.doc_order_totals(
    warehouse_id integer,
    client_id integer,
    product_id integer,
    mes_l integer,
    mes_w integer,
    mes_h integer,
    quant numeric,
    measure_unit_id integer,
    pack boolean,
    pack_in_price boolean,
    to_third_party_only boolean,
    price_edit boolean,
    price numeric)
  RETURNS record AS
$BODY$
	WITH
		product_params AS (
		SELECT
			coalesce(p.base_measure_unit_vol_m,0) AS base_measure_unit_vol_m,
			coalesce(p.base_measure_unit_weight_t,0) AS base_measure_unit_weight_t,
			
			eval(
				eval_params(
					pmu.calc_formula,
					$4,
					$5,
					$6
				)
			) AS base_quant,
			--настандартные размеры
			CASE
				WHEN $12=TRUE THEN $13 --цена вручную
				WHEN product_extra_pay_for_abnormal_size(p,$4,$5)
					/*
					p.extra_pay_for_abnormal_size=TRUE
					AND (
							p.extra_pay_for_abn_size_always=TRUE
							OR (
								p.mes_length_def_val<>$4
								OR
								p.mes_width_def_val<>$5
							)
						)
					*/
				THEN
					
					COALESCE(
						(SELECT csp.price
						FROM product_custom_size_prices AS csp
						WHERE csp.product_id=$3
							AND csp.quant<=
							eval(eval_params(
								p.extra_pay_calc_formula,
								$4,
								$5,
								$6
							))							
						ORDER BY csp.quant DESC LIMIT 1
						)
					,0)
					
				ELSE 0
			END AS extra_price
		FROM products p
		LEFT JOIN product_measure_units AS pmu
			ON pmu.product_id=p.id AND pmu.measure_unit_id=$8
		WHERE p.id=$3
		),
		
		price_list AS (
			SELECT *
			FROM product_price(
				$2,				
				(SELECT w.production_city_id
					FROM warehouses w WHERE w.id=$1
				),
				$11,
				$3,
				(SELECT t.base_quant
				FROM product_params t)
				)				
			AS (price numeric,price_pack numeric,discount_total numeric)
		),
		
		price AS (
			SELECT
				--Цена на продукцию + доп.цена за нестандартные размеры + упаковка
				(SELECT t.price FROM price_list t) +
				(SELECT t.extra_price FROM product_params t) +
				CASE
					WHEN $9 AND $10 THEN
						(SELECT t.price_pack FROM price_list t)
					ELSE 0
				END AS val
		)
		
	SELECT			
		--БАЗОВОЕ КОЛИЧЕСТВО
		round(
		(SELECT t.base_quant FROM product_params t)*
			$7
		,6) AS base_quant,
		
		--ОБЪЕМ
		round(
		(SELECT t.base_measure_unit_vol_m FROM product_params t)*
		(SELECT t.base_quant FROM product_params t)*
		$7
		,2) AS volume_m,

		--МАССА
		round(
		(SELECT t.base_measure_unit_weight_t FROM product_params t)*
		(SELECT t.base_quant FROM product_params t)*
		$7
		,3) AS weight_t,
		
		--ЦЕНА БЕЗ ТР - чистая		
		CASE
		WHEN $12 THEN $13
		ELSE
			round( (SELECT price.val FROM price) ,2)
		END,
		
		--СУММА
		round(
			CASE
			WHEN $12 THEN $13
			ELSE (SELECT price.val FROM price)
			END
			--Количество
			* (SELECT t.base_quant FROM product_params t)
			* $7
			--Скидка за объем
			- (SELECT coalesce(t.discount_total,0) FROM price_list t)
		,2)
		AS total,
		
		CASE
			WHEN $9 AND $10=FALSE THEN
				(SELECT t.price_pack FROM price_list t)
				--Количество
				* (SELECT t.base_quant FROM product_params t)*$7				
			ELSE 0
		END AS total_pack
		
	;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION public.doc_order_totals(integer, integer, integer, integer, integer, integer, numeric, integer, boolean, boolean, boolean, boolean, numeric)
  OWNER TO polimerplast;


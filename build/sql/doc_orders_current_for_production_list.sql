-- View: doc_orders_current_for_production_list

--DROP VIEW doc_orders_current_for_production_list;

CREATE OR REPLACE VIEW doc_orders_current_for_production_list AS 
	SELECT
		d.id,
		d.number,
		d.date_time,
		d.date_time_descr,
		
		d.delivery_plan_date,
		d.delivery_plan_date_descr,
		d.behind_plan,
		
		d.address_descr,		
		d.client_id,
		d.client_descr,		
		d.warehouse_id,
		d.warehouse_descr,		
		d.products_descr,		
		d.product_ids,
		d.total,
		d.total_descr,		
		d.total_quant,
		d.total_volume,		
		d.state,		
		d.state_descr,
	
		d.ext_ship_num,
		d.ext_order_num,
		d.delivery_fact_date,
		d.delivery_fact_date_descr,
		d.client_number,
		COALESCE(d.printed,FALSE) AS printed,
		d.cust_surv_date_time,
		d.cust_surv_date_time_descr,
		d.submit_user_descr,
		d.paid
	
	FROM doc_orders_list AS d
	WHERE
		d.state='producing'::order_states
		OR d.state='produced'::order_states
		OR d.state='loading'::order_states
		OR d.state='on_way'::order_states
		OR d.state='unloading'::order_states
	;
ALTER TABLE doc_orders_current_for_production_list OWNER TO polimerplast;


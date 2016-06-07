-- View: doc_orders_current_list

-- DROP VIEW doc_orders_current_list;

CREATE OR REPLACE VIEW doc_orders_current_list AS 
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
		d.printed,
		d.cust_surv_date_time,
		d.cust_surv_date_time_descr,
		d.submit_user_descr,
		d.paid
	
	FROM doc_orders_list AS d
	WHERE
		(d.pay_type='cash' AND d.paid=FALSE)
		OR
		(
		d.state<>'new'::order_states
		AND d.state<>'closed'::order_states
		AND d.state<>'canceled'::order_states
		AND d.state<>'canceled_by_sales_manager'::order_states	
		AND d.state<>'canceled_by_client'::order_states	
		AND d.state<>'waiting_for_client'::order_states
		AND d.state<>'waiting_for_us'::order_states
		)
	;
ALTER TABLE doc_orders_current_list OWNER TO polimerplast;


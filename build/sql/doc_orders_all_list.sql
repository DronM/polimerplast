-- View: doc_orders_all_list

-- DROP VIEW doc_orders_all_list;

CREATE OR REPLACE VIEW doc_orders_all_list AS 
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
		d.paid,
		d.paid_by_bank,
	
		(
			( d.pay_type='cash' AND coalesce(d.paid,FALSE)=FALSE AND coalesce(d.paid_by_bank,FALSE)=FALSE)
			OR
			(
			d.state NOT IN ('new',
				'waiting_for_client',
				'waiting_for_us',
				'shipped',
				'loading',
				'on_way',
				'unloading',
				'closed',
				'canceled_by_sales_manager',
				'canceled_by_client'					
				)
			)
		) AS is_current
	
	FROM doc_orders_list AS d
	;
ALTER TABLE doc_orders_all_list OWNER TO polimerplast;


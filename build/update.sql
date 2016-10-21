
					ALTER TYPE role_types ADD VALUE 'representative';
					
	CREATE OR REPLACE FUNCTION enum_role_types_descr(role_types)
	RETURNS varchar AS $$
		SELECT
		CASE $1
			
			WHEN 'admin'::role_types THEN 'Администратор'
			
			WHEN 'client'::role_types THEN 'Клиент'
			
			WHEN 'sales_manager'::role_types THEN 'Отдел продаж'
			
			WHEN 'production'::role_types THEN 'Производственный отдел'
			
			WHEN 'marketing'::role_types THEN 'Маркетолог'
			
			WHEN 'boss'::role_types THEN 'Руководитель'
			
			WHEN 'representative'::role_types THEN 'Представитель'
			
			ELSE '---'
		END;		
	$$ LANGUAGE sql;	
	ALTER FUNCTION enum_role_types_descr(role_types) OWNER TO polimerplast;
	
	--list view
	CREATE OR REPLACE VIEW enum_list_role_types AS
	
		SELECT 'admin'::role_types AS id, enum_role_types_descr('admin'::role_types) AS descr
	
		UNION ALL
		
		SELECT 'client'::role_types AS id, enum_role_types_descr('client'::role_types) AS descr
	
		UNION ALL
		
		SELECT 'sales_manager'::role_types AS id, enum_role_types_descr('sales_manager'::role_types) AS descr
	
		UNION ALL
		
		SELECT 'production'::role_types AS id, enum_role_types_descr('production'::role_types) AS descr
	
		UNION ALL
		
		SELECT 'marketing'::role_types AS id, enum_role_types_descr('marketing'::role_types) AS descr
	
		UNION ALL
		
		SELECT 'boss'::role_types AS id, enum_role_types_descr('boss'::role_types) AS descr
	
		UNION ALL
		
		SELECT 'representative'::role_types AS id, enum_role_types_descr('representative'::role_types) AS descr
	;
	ALTER VIEW enum_list_role_types OWNER TO polimerplast;




-- ******************* update 19/10/2016 14:32:19 ******************

			
				
			
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
		
			
			
			
			
			
			
		
			
			
			
			
		
			
			
			
			
		
			
				
			
			
			
			
		
			
				
			
			
			
			
			
		
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
		
						
			
			
			
			
			
			
						
			
			
			
			
			
			
			
		
						
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
		
						
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
		
			
		
			
		
			
		
			
			
			
			
			
		
			
			
			
		
			
			
						
			
			
			
			
									
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
			
			
			
		
			
		
			
		
			
			
		
			
			
		
			
		
			
			
		
			
			
		
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
		
			
			
		
			
			
			
			
			
		
			
			
			
			
			
		
			
			
			
			
		
			
			
			
					
			
			
			
			
		
			
			
			
			
			
			
			
		
			
			
			
			
						
			
			
			
			
			
		
			
			
			
						
			
			
			
		
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
							
		
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
		
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
		


-- ******************* update 19/10/2016 14:51:30 ******************

			
				
			
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
		
			
			
			
			
			
			
		
			
			
			
			
		
			
			
			
			
		
			
				
			
			
			
			
		
			
				
			
			
			
			
			
		
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
		
						
			
			
			
			
			
			
						
			
			
			
			
			
			
			
		
						
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
		
						
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
		
			
		
			
		
			
		
			
			
			
			
			
		
			
			
			
		
			
			
						
			
			
			
			
									
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
			
			
			
		
			
		
			
		
			
			
		
			
			
		
			
		
			
			
		
			
			
		
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
		
			
			
		
			
			
			
			
			
		
			
			
			
			
			
		
			
			
			
			
		
			
			
			
					
			
			
			
			
		
			
			
			
			
			
			
			
		
			
			
			
			
						
			
			
			
			
			
		
			
			
			
						
			
			
			
		
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
							
		
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
		
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
		


-- ******************* update 19/10/2016 15:02:53 ******************

			
				
			
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
		
			
			
			
			
			
			
		
			
			
			
			
		
			
			
			
			
		
			
				
			
			
			
			
		
			
				
			
			
			
			
			
		
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
		
						
			
			
			
			
			
			
						
			
			
			
			
			
			
			
		
						
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
		
						
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
		
			
		
			
		
			
		
			
			
			
			
			
		
			
			
			
		
			
			
						
			
			
			
			
									
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
			
			
			
		
			
		
			
		
			
			
		
			
			
		
			
		
			
			
		
			
			
		
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
		
			
			
		
			
			
			
			
			
		
			
			
			
			
			
		
			
			
			
			
		
			
			
			
					
			
			
			
			
		
			
			
			
			
			
			
			
		
			
			
			
			
						
			
			
			
			
			
		
			
			
			
						
			
			
			
		
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
							
		
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
		
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
		


-- ******************* update 19/10/2016 15:33:42 ******************

			
				
			
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
		
			
			
			
			
			
			
		
			
			
			
			
		
			
			
			
			
		
			
				
			
			
			
			
		
			
				
			
			
			
			
			
		
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
		
						
			
			
			
			
			
			
						
			
			
			
			
			
			
			
		
						
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
		
						
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
		
			
		
			
		
			
		
			
			
			
			
			
		
			
			
			
		
			
			
						
			
			
			
			
									
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
			
			
			
		
			
		
			
		
			
			
		
			
			
		
			
		
			
			
		
			
			
		
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
		
			
			
		
			
			
			
			
			
		
			
			
			
			
			
		
			
			
			
			
		
			
			
			
					
			
			
			
			
		
			
			
			
			
			
			
			
		
			
			
			
			
						
			
			
			
			
			
		
			
			
			
						
			
			
			
		
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
							
		
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
		
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
		


-- ******************* update 19/10/2016 23:09:06 ******************

			
				
			
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
		
			
			
			
			
			
			
		
			
			
			
			
		
			
			
			
			
		
			
				
			
			
			
			
		
			
				
			
			
			
			
			
		
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
		
						
			
			
			
			
			
			
						
			
			
			
			
			
			
			
		
						
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
		
						
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
		
			
		
			
		
			
		
			
			
			
			
			
		
			
			
			
		
			
			
						
			
			
			
			
									
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
			
			
			
		
			
		
			
		
			
			
		
			
			
		
			
		
			
			
		
			
			
		
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
		
			
			
		
			
			
			
			
			
		
			
			
			
			
			
		
			
			
			
			
		
			
			
			
					
			
			
			
			
		
			
			
			
			
			
			
			
		
			
			
			
			
						
			
			
			
			
			
		
			
			
			
						
			
			
			
		
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
							
		
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
		
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
		


-- ******************* update 20/10/2016 00:02:19 ******************

			
				
			
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
		
			
			
			
			
			
			
		
			
			
			
			
		
			
			
			
			
		
			
				
			
			
			
			
		
			
				
			
			
			
			
			
		
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
		
						
			
			
			
			
			
			
						
			
			
			
			
			
			
			
		
						
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
		
						
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
		
			
		
			
		
			
		
			
			
			
			
			
		
			
			
			
		
			
			
						
			
			
			
			
									
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
			
			
			
		
			
		
			
		
			
			
		
			
			
		
			
		
			
			
		
			
			
		
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
		
			
			
		
			
			
			
			
			
		
			
			
			
			
			
		
			
			
			
			
		
			
			
			
					
			
			
			
			
		
			
			
			
			
			
			
			
		
			
			
			
			
						
			
			
			
			
			
		
			
			
			
						
			
			
			
		
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
							
		
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
		
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
		


-- ******************* update 20/10/2016 11:17:06 ******************

			
				
			
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
		
			
			
			
			
			
			
		
			
			
			
			
		
			
			
			
			
		
			
				
			
			
			
			
		
			
				
			
			
			
			
			
		
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
		
						
			
			
			
			
			
			
						
			
			
			
			
			
			
			
		
						
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
		
						
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
		
			
		
			
		
			
		
			
			
			
			
			
		
			
			
			
		
			
			
						
			
			
			
			
									
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
			
			
			
		
			
		
			
		
			
			
		
			
			
		
			
		
			
			
		
			
			
		
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
		
			
			
		
			
			
			
			
			
		
			
			
			
			
			
		
			
			
			
			
		
			
			
			
					
			
			
			
			
		
			
			
			
			
			
			
			
		
			
			
			
			
						
			
			
			
			
			
		
			
			
			
						
			
			
			
		
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
							
		
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
		
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
		


-- ******************* update 20/10/2016 16:55:40 ******************

			
				
			
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
		
			
			
			
			
			
			
		
			
			
			
			
		
			
			
			
			
		
			
				
			
			
			
			
		
			
				
			
			
			
			
			
		
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
		
						
			
			
			
			
			
			
						
			
			
			
			
			
			
			
		
						
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
		
						
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
		
			
		
			
		
			
		
			
			
			
			
			
		
			
			
			
		
			
			
						
			
			
			
			
									
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
			
			
			
		
			
		
			
		
			
			
		
			
			
		
			
		
			
			
		
			
			
		
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
		
			
			
		
			
			
			
			
			
		
			
			
			
			
			
		
			
			
			
			
		
			
			
			
					
			
			
			
			
		
			
			
			
			
			
			
			
		
			
			
			
			
						
			
			
			
			
			
		
			
			
			
						
			
			
			
		
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
							
		
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
		
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
		


-- ******************* update 21/10/2016 08:58:58 ******************

			
				
			
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
		
			
			
			
			
			
			
		
			
			
			
			
		
			
			
			
			
		
			
				
			
			
			
			
		
			
				
			
			
			
			
			
		
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
		
						
			
			
			
			
			
			
						
			
			
			
			
			
			
			
		
						
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
		
						
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
		
			
		
			
		
			
		
			
			
			
			
			
		
			
			
			
		
			
			
						
			
			
			
			
									
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
			
			
			
		
			
		
			
		
			
			
		
			
			
		
			
		
			
			
		
			
			
		
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
		
			
			
		
			
			
			
			
			
		
			
			
			
			
			
		
			
			
			
			
		
			
			
			
					
			
			
			
			
		
			
			
			
			
			
			
			
		
			
			
			
			
						
			
			
			
			
			
		
			
			
			
						
			
			
			
		
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
							
		
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
		
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
		


-- ******************* update 21/10/2016 14:05:29 ******************

			
				
			
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
		
			
			
			
			
			
			
		
			
			
			
			
		
			
			
			
			
		
			
				
			
			
			
			
		
			
				
			
			
			
			
			
		
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
		
						
			
			
			
			
			
			
						
			
			
			
			
			
			
			
		
						
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
		
						
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
		
			
		
			
		
			
		
			
			
			
			
			
		
			
			
			
		
			
			
						
			
			
			
			
									
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
			
			
			
		
			
		
			
		
			
			
		
			
			
		
			
		
			
			
		
			
			
		
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
		
			
			
		
			
			
			
			
			
		
			
			
			
			
			
		
			
			
			
			
		
			
			
			
					
			
			
			
			
		
			
			
			
			
			
			
			
		
			
			
			
			
						
			
			
			
			
			
		
			
			
			
						
			
			
			
		
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
							
		
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
		
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
		


-- ******************* update 21/10/2016 23:26:59 ******************

			
				
			
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
		
			
			
			
			
			
			
		
			
			
			
			
		
			
			
			
			
		
			
				
			
			
			
			
		
			
				
			
			
			
			
			
		
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
		
						
			
			
			
			
			
			
						
			
			
			
			
			
			
			
		
						
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
		
						
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
		
			
		
			
		
			
		
			
			
			
			
			
		
			
			
			
		
			
			
						
			
			
			
			
									
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
			
			
			
		
			
		
			
		
			
			
		
			
			
		
			
		
			
			
		
			
			
		
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
		
			
			
		
			
			
			
			
			
		
			
			
			
			
			
		
			
			
			
			
		
			
			
			
					
			
			
			
			
		
			
			
			
			
			
			
			
		
			
			
			
			
						
			
			
			
			
			
		
			
			
			
						
			
			
			
		
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
							
		
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
		
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
		


-- ******************* update 22/10/2016 00:58:31 ******************

			
				
			
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
		
			
			
			
			
			
			
		
			
			
			
			
		
			
			
			
			
		
			
				
			
			
			
			
		
			
				
			
			
			
			
			
		
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
		
						
			
			
			
			
			
			
						
			
			
			
			
			
			
			
		
						
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
		
						
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
		
			
		
			
		
			
		
			
			
			
			
			
		
			
			
			
		
			
			
						
			
			
			
			
									
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
			
			
			
		
			
		
			
		
			
			
		
			
			
		
			
		
			
			
		
			
			
		
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
		
			
			
		
			
			
			
			
			
		
			
			
			
			
			
		
			
			
			
			
		
			
			
			
					
			
			
			
			
		
			
			
			
			
			
			
			
		
			
			
			
			
						
			
			
			
			
			
		
			
			
			
						
			
			
			
		
			
			
			
			
		
			
			
			
		
			
			
			
			
			
			
							
		
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
		
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
		
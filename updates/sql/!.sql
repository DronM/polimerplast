/*
INSERT INTO email_templates (email_type,template,mes_subject,comment_text,fields) VALUES ('order','�� ����������� [client] ��������� ����.','���� �� ������','',array['client','user']);
INSERT INTO email_templates (email_type,template,mes_subject,comment_text,fields) VALUES ('reset_pwd','������������ [user] ������� ������. ����� ������ [pwd]','����� ������','',array['user','pwd'])
INSERT INTO email_templates (email_type,template,mes_subject,comment_text,fields) VALUES ('new_account','������� ����� ������� ������ ��� ������� [client]. ��������� ������� ������: �����: [user] ������: [pwd]','����� ������� ������','',array['user','pwd','client'])
INSERT INTO email_templates (email_type,template,mes_subject,comment_text,fields) VALUES ('order_changed','������� ����� �[number] ������� [client]. ��������� ������� ������: �����: [user] ������: [pwd]','����� ������� ������','',array['number','client'])
INSERT INTO email_templates (email_type,template,mes_subject,comment_text,fields) VALUES ('shipment','�������� ����� �[number] ������� [client].','��������','',array['number','client'])
INSERT INTO email_templates (email_type,template,mes_subject,comment_text,fields) VALUES ('balance_to_client','��� ������ ��� �������: [client].','��� ������','',array['client'])
*/

--select Find_SRID('public','client_destinations','zone_center')

/*
DROP view client_destinations_dialog;
ALTER TABLE client_destinations
 ALTER COLUMN zone_center TYPE geometry(Point,4326) 
  USING ST_SetSRID(zone_center,4326);
  */
  
  
					ALTER TYPE role_types ADD VALUE 'representative';
					
	CREATE OR REPLACE FUNCTION enum_role_types_descr(role_types)
	RETURNS varchar AS $$
		SELECT
		CASE $1
			
			WHEN 'admin'::role_types THEN '�������������'
			
			WHEN 'client'::role_types THEN '������'
			
			WHEN 'sales_manager'::role_types THEN '����� ������'
			
			WHEN 'production'::role_types THEN '���������������� �����'
			
			WHEN 'marketing'::role_types THEN '����������'
			
			WHEN 'boss'::role_types THEN '������������'
			
			WHEN 'representative'::role_types THEN '�������������'
			
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
	


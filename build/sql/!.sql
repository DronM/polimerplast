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
  
  
DROP VIEW doc_orders_data_for_ext;
DROP VIEW vehicles_dialog;
DROP VIEW doc_orders_ttn;
DROP VIEW sms_client_remind;
DROP VIEW sms_client_change_time;
DROP VIEW sms_client_on_deliv;
DROP VIEW sms_client_on_leave_prod;
DROP VIEW sms_driver_first_deliv;
DROP VIEW email_text_order_remind;
DROP VIEW deliv_assigned_orders_for_client;

ALTER TABLE public.vehicles ALTER COLUMN plate TYPE character varying(11);


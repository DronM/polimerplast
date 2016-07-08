INSERT INTO email_templates (email_type,template,mes_subject,comment_text,fields) VALUES ('order','�� ����������� [client] ��������� ����.','���� �� ������','',array['client','user']);
INSERT INTO email_templates (email_type,template,mes_subject,comment_text,fields) VALUES ('reset_pwd','������������ [user] ������� ������. ����� ������ [pwd]','����� ������','',array['user','pwd'])
INSERT INTO email_templates (email_type,template,mes_subject,comment_text,fields) VALUES ('new_account','������� ����� ������� ������ ��� ������� [client]. ��������� ������� ������: �����: [user] ������: [pwd]','����� ������� ������','',array['user','pwd','client'])
INSERT INTO email_templates (email_type,template,mes_subject,comment_text,fields) VALUES ('order_changed','������� ����� �[number] ������� [client]. ��������� ������� ������: �����: [user] ������: [pwd]','����� ������� ������','',array['number','client'])
INSERT INTO email_templates (email_type,template,mes_subject,comment_text,fields) VALUES ('shipment','�������� ����� �[number] ������� [client].','��������','',array['number','client'])
INSERT INTO email_templates (email_type,template,mes_subject,comment_text,fields) VALUES ('balance_to_client','��� ������ ��� �������: [client].','��� ������','',array['client'])


select Find_SRID('public','client_destinations','zone_center')
/*
DROP view client_destinations_dialog;
ALTER TABLE client_destinations
 ALTER COLUMN zone_center TYPE geometry(Point,4326) 
  USING ST_SetSRID(zone_center,4326);
  */

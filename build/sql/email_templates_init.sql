INSERT INTO email_templates (email_type,template,mes_subject,comment_text,fields) VALUES ('order','�� ����������� [client] ��������� ����.','���� �� ������','',array['client','user']);
INSERT INTO email_templates (email_type,template,mes_subject,comment_text,fields) VALUES ('reset_pwd','������������ [user] ������� ������. ����� ������ [pwd]','����� ������','',array['user','pwd']);
INSERT INTO email_templates (email_type,template,mes_subject,comment_text,fields) VALUES ('new_account','������� ����� ������� ������ ��� ������� [client]. ��������� ������� ������: �����: [user] ������: [pwd]','����� ������� ������','',array['user','pwd','client']);
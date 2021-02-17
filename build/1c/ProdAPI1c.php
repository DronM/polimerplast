<?php
	require_once('downloader.php');
	require_once('prod_functions.php');
	
	define('COMMAND', 'cmd');
	
	//********* ������� *************
	set_time_limit(300);
	/**
	 * ���������� ������ ��������� ��� 1�: �������������������������������
	 * ���������: docs ��������������� ������ ����������
	 * �������: ������
	 */
	define('CMD_PASS_MATERIAL_TO_PRODUCTION', 'pass_material_to_prodution');	

	/**
	 * ���������� ������ �� �������� ������������ ��������������, ��� 1�: ���������������
	 * ���������: docs ��������������� ������ ����������
	 * �������: ������
	 */
	define('CMD_FORM_PRODUCTION', 'form_production');	
	
	
	//********* ������� *************

	
	
	//***** ��������� ������ ************
	define('PAR_DOCS', 'docs');
	//***** ��������� ������ ************

	//***** �������� �� ��������� ************
	//***** �������� �� ��������� ************
	
	define('COM_OBJ_NAME', 'v8Server.Connection');
	define('API_EPF', dirname(__FILE__).'\API1C.epf');

	$xml_status = 'true';
	$xml_body = '';
	$SENT_FILE = FALSE;
	try{		
		if (!isset($_REQUEST[COMMAND])){
			//error
			throw new Exception('No command');
		}
		$com = $_REQUEST[COMMAND];
		if ($com==CMD_PASS_MATERIAL_TO_PRODUCTION){
			$docs_s = $_REQUEST[PAR_DOCS];
			if (!$docs_s){
				throw new Exception("�� ������ ���������!");
			}
			
			$docs = unserialize(stripslashes($docs_s));
			$v8 = new COM(COM_OBJ_NAME);
			$xml_body = passMaterialToProduction($v8,$docs);
		}
		else if ($com==CMD_FORM_PRODUCTION){
			$docs_s = $_REQUEST[PAR_DOCS];
			if (!$docs_s){
				throw new Exception("�� ������ ���������!");
			}
			
			$docs = unserialize(stripslashes($docs_s));
			$v8 = new COM(COM_OBJ_NAME);
			$xml_body = formProdunction($v8,$docs);
		}
		
	}	
	catch (Exception $e){
		//error
		$xml_status = 'false';		
		$xml_body.='<error><![CDATA['.cyr_str_encode($e->getMessage()).']]></error>';		
		//$xml_body.='<error>'.cyr_str_encode($e->getMessage()).'</error>';		
	}
	if (!$SENT_FILE){
		$res_xml = '<?xml version="1.0" encoding="UTF-8"?>';
		$res_xml .= '<response status="'.$xml_status.'">';
		$res_xml .= $xml_body.'</response>';
		
		echo $res_xml;
	}
?>
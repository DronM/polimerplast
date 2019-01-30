<?php
	require_once('downloader.php');
	require_once('functions.php');
	define('COMMAND', 'cmd');
	
	//********* ������� *************
	set_time_limit(300);
	/*
	���������� ������ ������� �� ���
	���������: inn
	�������: ������
	*/
	define('CMD_GET_CLIENT_ON_INN', 'get_client_on_inn');	

	/*
	���������� �������� ������� �� �����
	���������: name
	�������: �������� �����������
	*/
	define('CMD_GET_CLIENT_ATTRS', 'get_client_attrs_on_name');	
	
	/*
	���������� ������ �� ����������� �� �����
	���������: name
	�������: ������
	*/	
	define('CMD_GET_FIRM_ON_NAME', 'get_firm_on_name');

	/*
	���������� ������ �� �������������� ������ �� �����
	���������: name
	�������: ������
	*/	
	define('CMD_GET_PRODUCT_GROUP_ON_NAME', 'get_product_group_on_name');
	
	/*
	���������� ������ �� ��� ���� �� �����
	���������: name
	�������: ������
	*/	
	define('CMD_GET_PERSON_ON_NAME', 'get_person_on_name');

		/*
	���������� ������ �� ��� ���� �� ����� ���� ���� ��� ������� ������
	���������: params array
	�������: ������
	*/	
	define('CMD_GET_PERSON_CREATE', 'get_person_create');

/*
	���������� �������� �� ��������
	���������: ref
	�������: ����� ���������
	*/	
	define('CMD_GET_DRIVER_ATTRS', 'get_driver_attrs');
	
	/*
	���������� ������ �� ������������ �� �����
	���������: name
	�������: ������
	*/	
	define('CMD_GET_USER_ON_NAME', 'get_user_on_name');
	
	/*
	���������� ������ �� ��� ������������
	���������: name
	�������: ������
	*/	
	define('CMD_GET_CLIENT_ACTIVITY_ON_NAME', 'get_client_activity_on_name');
	
	/*
	���������� ������ ������ �� �����
	���������: name
	�������: ������
	*/	
	define('CMD_GET_WAREHOUSE_ON_NAME', 'get_warehouse_on_name');

	/*
	���������� ������ ������� ��������� �� �����
	���������: name
	�������: ������
	*/	
	define('CMD_GET_MEASURE_ON_NAME', 'get_measure_on_name');
	
	/*
	��������� ������ �������
	���������: ��� ���������
	�������:
	*/		
	define('CMD_ADD_CLIENT', 'add_client');

	/*
	���������� ������ ������������ �� �����
	���������: templ
	�������: ������
	*/			
	define('CMD_COMPLETE_CLIENT', 'complete_client');

	/*
	���������� ������ ������������� �� �����
	���������: templ
	�������: ������
	*/			
	define('CMD_COMPLETE_USER', 'complete_user');
	
	/*
	���������� ������ � ������ ����������� �����
	���������: firm_ref
	�������: ������
	*/			
	define('CMD_FIRM_DATA', 'firm_data');
	
	/*
	������� ����� �������
	���������:
		head serialized ������,			
		items - serialized ������
		
	�������: �������� �� 1�
	*/			
	define('CMD_SALE', 'sale');

	/*
	�������� ����
	���������:
		doc_ref ������,			
		stamp - 1/0 �� ������������, �� ��������� 0
	�������: �������� ����� PDF
	*/			
	define('CMD_PRINT_ORDER', 'print_order');
	
	/*
	������� ����� ����
	���������:
		head serialized ������,			
		items - serialized ������
		
	�������: �������� �� 1�
	*/			
	define('CMD_ORDER', 'order');
	
	/*
	���������:
		doc_ref ������ �������� ����������
		stamp - 1/0 �� ������������, �� ��������� 0
	�������: �������� �����
	*/			
	define('CMD_TORG12', 'print_torg12');

	/*
	���������:
		doc_ref ������ �������� ���
	�������: �������� �����
	*/			
	define('CMD_INVOICE', 'print_invoice');

	/*
	������� ��� ������
	���������
		from date
		to date
		client_ref
		firm_ref
	������� �������� �����
	*/
	define('CMD_BALANCE','print_balance');
	
	/*
	���������:
		doc_ref ������ �������� ����������
		stamp - 1/0 �� ������������, �� ��������� 0
	�������: �������� ����� ���
	*/			
	define('CMD_UPD', 'print_upd');

	/*
	���������:
		doc_ref ������ �������� ����������
		stamp - 1/0 �� ������������, �� ��������� 0
	�������: �������� ����� ���+���
	*/			
	define('CMD_SHIP', 'print_shipment');
	
	/*
	���������:
		doc_ref ������ �������� ����������
		stamp - 1/0 �� ������������, �� ��������� 0
		head - ��������������� ������
	�������: �������� ����� ���
	*/			
	define('CMD_TTN', 'print_ttn');
	
	/*
	���������:
		head serialized ������,			
		pkoType (cash/bank)
	*/	
	define('CMD_PAID_TO_ACC', 'paid_to_acc');
	
	/*
	���������� ������ ������ ��������
	*/		
	define('CMD_GET_DEBT_LIST', 'get_debt_list');

	/*
	������� ���������
	���������:
		ext_order_id,ext_ship_id
	*/		
	define('CMD_DEL_DOCS', 'del_docs');

	/*
	������� ���������
	���������:
		head [ext_ship_id,deliv_expenses]
	*/		
	define('CMD_DELIV_EXPENSES', 'set_deliv_expenses');
	
	//********* ������� *************

	
	
	//***** ��������� ������ ************
	define('PAR_ID', 'id');
	define('PAR_NAME', 'name');
	define('PAR_INN', 'inn');
	define('PAR_TEMPL', 'templ');
	define('PAR_COUNT', 'count');
	define('PAR_DAYS', 'days');
	define('PAR_DATE', 'date');
	define('PAR_FIRM', 'firm_ref');
	define('PAR_DRIVER', 'driver_ref');
	define('PAR_CLIENT', 'client_ref');
	define('PAR_WAREHOUSE', 'warehouse_ref');
	define('PAR_DOC', 'doc_ref');
	define('PAR_HEAD', 'head');
	define('PAR_ITEMS', 'items');
	define('PAR_FROM', 'from');
	define('PAR_TO', 'to');
	define('PAR_STAMP', 'stamp');
	define('PAR_PARAMS', 'params');	
	//***** ��������� ������ ************

	//***** �������� �� ��������� ************
	define('PAR_DEF_COUNT', '5');	
	define('PAR_DEF_DAYS', '0');
	define('PAR_DEF_STAMP', '0');
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
		if ($com==CMD_ADD_CLIENT){
			$v8 = new COM(COM_OBJ_NAME);
			$xml_body = sprintf('<ref>%s</ref>',client($v8,$_REQUEST));
		}
		else if ($com==CMD_GET_CLIENT_ON_INN){
			if (!strlen($_REQUEST[PAR_INN])){
				throw new Exception("�� ����� ���");
			}	
			$v8 = new COM(COM_OBJ_NAME);			
			$xml_body = get_client_on_inn($v8,$_REQUEST[PAR_INN]);
		}
		else if ($com==CMD_GET_CLIENT_ATTRS){
			
			if (!isset($_REQUEST[PAR_NAME])){
				throw new Exception("�� ������ ������������");
			}
			$name = cyr_str_decode($_REQUEST[PAR_NAME]);
			$name = str_replace('\"','""',$name);
			
			$v8 = new COM(COM_OBJ_NAME);
			$xml_body = get_client_attrs($v8,$name);
		}
		
		else if ($com==CMD_COMPLETE_CLIENT){
			$xml_body = completeSprOnDescr('�����������');
		}
		else if ($com==CMD_COMPLETE_USER){
			$xml_body = completeSprOnDescr('������������');
		}		
		else if ($com==CMD_GET_FIRM_ON_NAME){
			$xml_body = getSprRefOnDescr('�����������');
		}		
		else if ($com==CMD_GET_PRODUCT_GROUP_ON_NAME){
			$xml_body = getSprRefOnDescr('��������������������');
		}		
		else if ($com==CMD_GET_PERSON_ON_NAME){
			$xml_body = getPersonRefOnDescr();
		}		
		else if ($com==CMD_GET_PERSON_CREATE){
			$params = unserialize(stripslashes($_REQUEST[PAR_PARAMS]));
			$xml_body = getPersonRefCreate($params);
		}		
		
		else if ($com==CMD_GET_DRIVER_ATTRS){
			$xml_body = getPersonAttrs();
		}		
		
		else if ($com==CMD_GET_USER_ON_NAME){
			$xml_body = getSprRefOnDescr('������������');
		}		
		
		else if ($com==CMD_GET_CLIENT_ACTIVITY_ON_NAME){
			//$xml_body = getSprRefOnDescr('����������������������������');
		}		
		
		else if ($com==CMD_GET_WAREHOUSE_ON_NAME){
			$xml_body = getSprRefOnDescr('������');
		}
		else if ($com==CMD_GET_MEASURE_ON_NAME){
			if (!isset($_REQUEST[PAR_NAME])){
				throw new Exception("�� ������ ������������");
			}
			$par = stripslashes(cyr_str_decode($_REQUEST[PAR_NAME]));
			$par = str_replace('\"','""',$par);
			$v8 = new COM(COM_OBJ_NAME);
			$q_obj = $v8->NewObject('������');
			$q_obj->����� ='������� ������,������������������
			�� ����������.������������������������
			��� ��� <> """" � ������������="'.$par.'" � �� ��������������� � ����������������=��������(����������.������������������������.������������)';
			$sel = $q_obj->���������()->�������();
			if ($sel->���������()){
				$xml_body = sprintf('<ref>%s</ref><name_full>%s</name_full>',
					$v8->String($sel->������->�����������������������()),
					$v8->String(cyr_str_encode($sel->������������������))
					);
			}
		}						
		else if ($com==CMD_GET_DEBT_LIST){
			$par_date = date("Y,m,d,23,59,59");
			$v8 = new COM(COM_OBJ_NAME);
			$q_obj = $v8->NewObject('������');
			$q_obj->����� ="
			�������
			������.����������� AS firmRef,
			������.��������1 AS clientRef,
			��������(�����(����NULL(������.��������������,0)) ��� �����(15,2)) AS �����
			�� ������������������.������������.�������(
			���������(".$par_date."),
			���� � �������� (&�������),��������(����������������������.������������������������.�����������)) ��� ������
			��� ������.��������������<>0
			������������� �� ������.�����������,������.��������1";
			$spis = $v8->NewObject('��������������');
			$spis->��������($v8->�����������->������������->���������������������������������);
			$spis->��������($v8->�����������->������������->��������������������������������);
			$q_obj->������������������('�������',$spis);
			$q_obj->������������������('�������',$spis);
			$sel = $q_obj->���������()->�������();
			while ($sel->���������()){
				$sm = str_replace(' ','',$sel->�����);
				$sm = str_replace(',','.',$sm);
				$sm = floatval($sm);
				//$v8->String($sel->�����)
				if ($sm<>0){
					$xml_body.='<rec>'.
						sprintf('<firmRef>%s</firmRef>',
							$v8->String($sel->firmRef->�����������������������())
						).
						sprintf('<clientRef>%s</clientRef>',
							$v8->String($sel->clientRef->�����������������������())
						).					
						sprintf('<debt>%f</debt>',
							$sm
						).
						'</rec>';
				}
			}						
		}
		/* �� ������� �����*/
		/*
		else if ($com==CMD_GET_CLIENT_DEBT){
			if (!isset($_REQUEST[PAR_ID])){
				throw new Exception("�� ����� ������������� �������");
			}
			//$par_date = date("Y,m,d,23,59,59");
			//���������(".$par_date.")
			$par_date = date("Y,m,d,23,59,59");
			
			$v8 = new COM(COM_OBJ_NAME);
			$q_obj = $v8->NewObject('������');
			$q_obj->����� ="
			�������
			�������.����������� AS ref,
			�����(����NULL(�������.��������������������������,0)) ��� �����
			��
			    �����������������.���������������������������.�������(
			        ���������(".$par_date."), ����������=&����������) ��� �������
			������������� �� �������.�����������
			";
			$uid = $v8->NewObject('�����������������������',$_REQUEST[PAR_ID]);
			$q_obj->������������������('����������',
				$v8->�����������->�����������->��������������($uid));
			$sel = $q_obj->���������()->�������();
			while ($sel->���������()){
				$xml_body.='<org>'.sprintf('<ref>%s</ref>',
					$v8->String($sel->ref->�����������������������())
					).
					sprintf('<debt>%s</debt>',
						$v8->String($sel->�����)
					).
					'</org>';
			}			
		}
		*/
		else if ($com==CMD_SALE){
			$head = unserialize(stripslashes($_REQUEST[PAR_HEAD]));
			$items = unserialize(stripslashes($_REQUEST[PAR_ITEMS]));
			$v8 = new COM(COM_OBJ_NAME);
			$xml_body = sale($v8,$head,$items);
		}		
		else if ($com==CMD_ORDER){
			$head = unserialize(stripslashes($_REQUEST[PAR_HEAD]));
			$items = unserialize(stripslashes($_REQUEST[PAR_ITEMS]));
			$v8 = new COM(COM_OBJ_NAME);
			$xml_body = order($v8,$head,$items);
		}		
		else if ($com==CMD_PRINT_ORDER){
			$doc_ref = $_REQUEST[PAR_DOC];
			if (!$doc_ref){
				throw new Exception("�� ����� ������������� ���������!");
			}
			
			$stamp = ($_REQUEST[PAR_STAMP])? intval($_REQUEST[PAR_STAMP]):PAR_DEF_STAMP;
			$user_ref = ($_REQUEST['user_ref'])? $_REQUEST['user_ref']:'';
			$v8 = new COM(COM_OBJ_NAME);
			$obr = get_ext_obr($v8);
			//$stamp = 0;
			$file = $obr->����������������($doc_ref,$user_ref,$stamp);			
			downloadfile($file);
			unlink($file);
			$SENT_FILE = TRUE;
		}		
		
		else if ($com==CMD_SHIP){
			$doc_ref = $_REQUEST[PAR_DOC];
			if (!$doc_ref){
				throw new Exception("�� ����� ������������� ���������!");
			}
			$stamp = ($_REQUEST[PAR_STAMP])? intval($_REQUEST[PAR_STAMP]):PAR_DEF_STAMP;
			
			$head = unserialize(stripslashes($_REQUEST[PAR_HEAD]));
			$ttn_exists = ($head['deliv_type'] && $head['deliv_type']=='by_supplier');
			
			$v8 = new COM(COM_OBJ_NAME);
			
			$obr = get_ext_obr($v8);
			
			$file1 = $obr->��������������($doc_ref,$stamp);			
			
			$zip = new ZipArchive();
			$file_for_download = dirname(__FILE__).'/'.md5(uniqid()).'.zip';
			if ($zip->open($file_for_download, ZIPARCHIVE::CREATE)!==TRUE) {
				throw new Exception("cannot open <$file_for_download>\n");
			}			
			$zip->addFile($file1,'upd.pdf');
			
			if ($ttn_exists){
				//2 files
				$file2 = $obr->��������������($doc_ref,$stamp);
				$zip->addFile($file2,'ttn.pdf');
			}
			$zip->close();
			
			ob_clean();
			downloadfile($file_for_download);
			unlink($file_for_download);
			
			$SENT_FILE = TRUE;
		}						
		else if ($com==CMD_UPD || $com==CMD_INVOICE || $com==CMD_TORG12){
			$doc_ref = $_REQUEST[PAR_DOC];
			if (!$doc_ref){
				throw new Exception("�� ����� ������������� ���������!");
			}
			$stamp = ($_REQUEST[PAR_STAMP])? intval($_REQUEST[PAR_STAMP]):PAR_DEF_STAMP;
			//$user_ref = ($_REQUEST['user_ref'])? $_REQUEST['user_ref']:'';
			$v8 = new COM(COM_OBJ_NAME);
			$obr = get_ext_obr($v8);
			$file = $obr->��������������($doc_ref,$stamp);
			downloadfile($file);
			unlink($file);
			$SENT_FILE = TRUE;
		}				
		else if ($com==CMD_TTN){
			$doc_ref = $_REQUEST[PAR_DOC];
			if (!$doc_ref){
				throw new Exception("�� ����� ������������� ���������!");
			}
			$stamp = ($_REQUEST[PAR_STAMP])? intval($_REQUEST[PAR_STAMP]):PAR_DEF_STAMP;
			$head = unserialize(stripslashes($_REQUEST[PAR_HEAD]));
			
			$v8 = new COM(COM_OBJ_NAME);			
			
			$obr = get_ext_obr($v8);
			$file = $obr->��������������($doc_ref,$stamp);
			ob_clean();
			downloadfile($file);
			unlink($file);
			$SENT_FILE = TRUE;
		}				
		
		else if	($com==CMD_BALANCE){
			if (!isset($_REQUEST[PAR_CLIENT])){
				throw new Exception("�� ����� ������������� �������!");
			}						
			if (!isset($_REQUEST[PAR_FIRM])){
				throw new Exception("�� ����� ������������� �����!");
			}									
			if (!isset($_REQUEST[PAR_FROM])){
				throw new Exception("�� ������ ����!");
			}												
			if (!isset($_REQUEST[PAR_TO])){
				throw new Exception("�� ������ ����!");
			}
			//throw new Exception('PAR_FIRM='.$_REQUEST[PAR_FIRM]);
			$from = date('Ymd',$_REQUEST[PAR_FROM]);
			$to = date('Ymd',$_REQUEST[PAR_TO]);
			$v8 = new COM(COM_OBJ_NAME);
			$obr = get_ext_obr($v8);
			$user_ref = ($_REQUEST['user_ref'])? $_REQUEST['user_ref']:'';
			$file_type = ($_REQUEST['file_type'])? $_REQUEST['file_type']:'pdf';
			
			$file = $obr->�������������������������������(
				$_REQUEST[PAR_FIRM],
				$_REQUEST[PAR_CLIENT],
				$from,
				$to,
				$user_ref,
				$file_type
				);
			downloadfile($file);
			unlink($file);
			$SENT_FILE = TRUE;
			
		}
		else if ($com==CMD_FIRM_DATA){
			if (!isset($_REQUEST[PAR_FIRM])){
				throw new Exception("�� ����� ������������� �����������!");
			}				
			$v8 = new COM(COM_OBJ_NAME);
			$obr = get_ext_obr($v8);
			$str = cyr_str_encode($obr->����������($_REQUEST[PAR_FIRM]));
			$xml_body.='<org_data>'.$str.'</org_data>';			
		}
		else if ($com==CMD_PAID_TO_ACC){
			$head = unserialize(stripslashes($_REQUEST[PAR_HEAD]));
			$pay_type_cash = ($_REQUEST['pkoType'] && $_REQUEST['pkoType']=='bank');
			$v8 = new COM(COM_OBJ_NAME);
			pko($v8,$head,$pay_type_cash);
		}
		else if ($com==CMD_DEL_DOCS){
			$v8 = new COM(COM_OBJ_NAME);
			del_docs($v8,$_REQUEST['ext_order_id'],$_REQUEST['ext_ship_id']);
		}
		
		else if ($com==CMD_DELIV_EXPENSES){
			$v8 = new COM(COM_OBJ_NAME);
			$head = unserialize(stripslashes($_REQUEST[PAR_HEAD]));
			set_deliv_expenses($v8,$head['ext_ship_id'],floatval($head['deliv_expenses']));
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
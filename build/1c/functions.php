<?php
	/**
	 * ���������, ������ ���� � ��� ����!!!
	 */
	/* ���������� ������������������������ */
	define("CONST_1C_MU_MM",'�');
	
	/* ���������� ������������ */
	define("CONST_1C_ITEM_GROUP_NAME",'���������');
	
	/* ���������� ���������������� */
	define("CONST_1C_ITEM_KIND",'��������� (�/�)');
	
	/* ���������� ���������������������������������� */
	define("CONST_1C_FIN_GRP",'���������');
	
	/* ���������� ������������������������������ */
	define("CONST_1C_OBR_NAME",'Web CRM Functions');
	
	/* ���������� ������������ */
	define("CONST_1C_ITEM_NAME_PACK",'��������');
	define("CONST_1C_ITEM_NAME_DELIV",'��������');
		
	/* ���������� ���������� */
	define("CONST_1C_PRIORITY",'�������');
	
	/* ���������� �������������������� */
	define("CONST_1C_DEP",'��������');

	/* �������������� �������� ���������� */
	define('CONST_1C_ACC_ATTR','���������');

	/* �������������� �������� ���������� */
	define('CONST_1C_DOC_ATTR','����� CRM');
	
	/* ������������ ��� ���������� */
	define('CONST_1C_ACCORD_NAME','������� ���������� � ��������');
	
	
//******************************************************************************	
	function cyr_str_decode($str){
		return iconv('UTF-8','Windows-1251',$str);
	}
	
	function cyr_str_encode($str){
		//����� ���������� � ANSI
		return $str;//iconv('Windows-1251','UTF-8',$str);
	}
	
	function removeLeadingZero($nStr){
		if (strlen($nStr)==2 && substr($nStr,0,1)=='0'){
			return intval(substr($nStr,1,1));
		}
		else{
			return intval($nStr);
		}
	}
	
	function get_1c_date($d,$h=0,$m=0,$s=0){
		$parts = explode('-',str_replace("\'",'',$d));
		//var_dump($parts);
		if (count($parts)>=3){
			$_d = mktime($h,$m,$s,$parts[1],$parts[2],$parts[0]);
			if ($h==0&&$m==0&&$s==0){
				$format = 'Ymd';
			}
			else{
				$format = 'YmdHis';
			}
		return date($format,$_d);
		}
	}

	/*
	 * ���� ����������!!!
	 * ���������� ����� ������� ���!!!
	 */
	function fill_struc_for_ttn($v8,$head){
		$attrs = $v8->NewObject('���������');
		$attrs->��������("������������",cyr_str_decode($head["deliv_time"]));
		$attrs->��������("���������������",cyr_str_decode($head["vh_model"]));
		$attrs->��������("������������",cyr_str_decode($head["vh_trailer_model"]));
		$attrs->��������("������������������",cyr_str_decode($head["vh_plate"]));
		$attrs->��������("���������������",cyr_str_decode($head["vh_trailer_plate"]));
		
		$attrs->��������("�������������",cyr_str_decode($head["wareh_descr"]));
		$attrs->��������("��������������",cyr_str_decode($head["dest_descr"]));
		
		$driver_ref = 0;
		if ($head["driver_ref"]){
			$driver_id = $v8->NewObject('�����������������������',$head['driver_ref']);
			$driver_ref = $v8->�����������->��������������->��������������($driver_id);			
		}
		$attrs->��������("����������",$driver_ref);

		$carrier_ref = 0;
		if ($head["carrier_ref"]){
			$carrier_id = $v8->NewObject('�����������������������',$head['carrier_ref']);
			$carrier_ref = $v8->�����������->�����������->��������������($carrier_id);			
		}
		$attrs->��������("����������",$carrier_ref);

		$attrs->��������("������������",cyr_str_decode($head["deliv_kind"]));
		$attrs->��������("��������������������",FALSE);
		$attrs->��������("�������������������������",cyr_str_decode($head["drive_perm"]));
		return $attrs;
	}
	
	function get_client_on_inn($v8,$inn){		
		$q_obj = $v8->NewObject('������');
		$q_obj->����� ='������� ������ 1 ������.������ ��� ref �� ����������.����������� ��� ������ ��� ������.���="'.$inn.'"';
		$sel = $q_obj->���������()->�������();
		if ($sel->���������()){
				return $v8->String($sel->ref->�����������������������());			
		}	
	}

	function get_client_ref_on_inn($v8,$inn){		
		$q_obj = $v8->NewObject('������');
		$q_obj->����� ='������� ������ 1 ������.������ ��� ref �� ����������.����������� ��� ������ ��� ������.���="'.$inn.'"';
		$sel = $q_obj->���������()->�������();
		if ($sel->���������()){
				return $sel->ref;			
		}	
	}

	function get_client_attrs($v8,$name){		
		$q_obj = $v8->NewObject('������');
		$q_obj->����� ='
		������� ������ 1
			������.������ ��� ref,
			������.������������������ ��� name_full,
			������.��� ��� inn,
			������.��� ��� kpp,
			������.��������� ��� okpo,
			����NULL(���������.�������������,"""") ��� telephones,
			����NULL(����������.�������������,"""") ��� addr_reg,
			����NULL(�����������.�������������,"""") ��� addr_mail,
			��.���������� ��� acc,
			����.������������ ��� bank_name,
			����.��� ��� bank_code,
			����.�������� ��� bank_acc
		
		�� ����������.����������� ��� ������
		
		����� ���������� ����������.�����������.�������������������� ��� ���������
		�� ���������.������=������.������ � ���������.���=��������(������������.������������������������.�������)
		� ���������.���=��������(����������.������������������������.������������������)
		
		����� ���������� ����������.�����������.�������������������� ��� ����������
		�� ����������.������=������.������ � ����������.���=��������(������������.������������������������.�����)
		� ����������.���=��������(����������.������������������������.������������������)
		
		����� ���������� ����������.�����������.�������������������� ��� �����������
		�� �����������.������=������.������ � �����������.���=��������(������������.������������������������.�����)
		� �����������.��� =��������(����������.������������������������.��������������������)
		
		����� ���������� ����������.��������������������������� ��� ��
		�� �� ��.������ � ��.��������=������.������
		
		����� ���������� ����������.������������������� ��� �����
		�� �����.������=��.����
		
		��� ������.������������="'.$name.'"		
		';
		
		$sel = $q_obj->���������()->�������();
	
		if ($sel->���������()){
			$xml_body = sprintf('<ref>%s</ref>',
				$v8->String($sel->ref->�����������������������()));
			$xml_body.= '<attrs>';
			$xml_body.= sprintf('<name_full>%s</name_full>',
				cyr_str_encode($sel->name_full));
			$xml_body.= sprintf('<inn>%s</inn>',$sel->inn);
			$xml_body.= sprintf('<kpp>%s</kpp>',$sel->kpp);
			$xml_body.= sprintf('<okpo>%s</okpo>',$sel->okpo);
			$xml_body.= sprintf('<telephones>%s</telephones>',
				cyr_str_encode($sel->telephones));
			$xml_body.= sprintf('<addr_reg>%s</addr_reg>',
				cyr_str_encode($sel->addr_reg));
			$xml_body.= sprintf('<addr_mail>%s</addr_mail>',
				cyr_str_encode($sel->addr_mail));
			$xml_body.= sprintf('<acc>%s</acc>',$sel->acc);
			$xml_body.= sprintf('<bank_name>%s</bank_name>',
				cyr_str_encode($sel->bank_name));
			$xml_body.= sprintf('<bank_code>%s</bank_code>',$sel->bank_code);
			$xml_body.= sprintf('<bank_acc>%s</bank_acc>',$sel->bank_acc);
			$xml_body.= '</attrs>';
			
			return $xml_body;
		}	
	}

	function completeSprOnDescr($sprKind){
		if (!isset($_REQUEST[PAR_TEMPL])){
			throw new Exception("�� ����� ������");
		}
		$count = (isset($_REQUEST[PAR_COUNT]))? $_REQUEST[PAR_COUNT]:PAR_DEF_COUNT;
		$par = str_replace('\"','""',$_REQUEST[PAR_TEMPL]);
		$v8 = new COM(COM_OBJ_NAME);
		$q_obj = $v8->NewObject('������');
		$q_obj->����� ='������� ������ '.$count.' 
			���.������ ��� ref,
			���.������������ ��� name
			�� ����������.'.$sprKind.' ��� ���
			��� ���.������������ ������� "'.cyr_str_decode($par).'%"';
		$sel = $q_obj->���������()->�������();
		$xml = '';
		while ($sel->���������()){
			$xml.= sprintf("<ref name='%s'>%s</ref>",
				cyr_str_encode($sel->name),
				$v8->String($sel->ref->�����������������������()));
		}
		return $xml;
	}	
	
	function getSprRefOnDescr($sprKind){
		$descr = $_REQUEST[PAR_NAME];
		if (!isset($descr)){
			throw new Exception("�� ������ ������������");
		}
		$v8 = new COM(COM_OBJ_NAME);
		$par = cyr_str_decode($descr);
		$par = str_replace('"','""',$par);
		$q_obj = $v8->NewObject('������');
		$q_obj->����� ='������� ������ 1 ���.������ ��� ref
		�� ����������.'.$sprKind.' ��� ���
		��� ���.������������="'.$par.'"';
		//throw new Exception($q_obj->�����);
		$sel = $q_obj->���������()->�������();
		if ($sel->���������()){
			return sprintf('<ref>%s</ref>',
				$v8->String($sel->ref->�����������������������()));
		}	
	}
	
	function getPersonRefOnDescr(){
		$descr = $_REQUEST[PAR_NAME];
		if (!isset($descr)){
			throw new Exception("�� ������ ������������");
		}
		$v8 = new COM(COM_OBJ_NAME);
		$par = cyr_str_decode($descr);
		$par = str_replace('"','""',$par);
		
		$q_obj = $v8->NewObject('������');
		$q_obj->����� ='������� ������ 1
		���.������ ��� ref,
		������.�������� ��� drive_perm
		�� ����������.�������������� ��� ���
		����� ���������� ����������.��������������.����������������������� ��� ������
		�� ������.������=���.������	� ������.�������� � (
					������� ������ 1 ������
					�� ����������������������.��������������������������������
					��� ������������ = ��������(����������.���������������������������������������.����������_��������������)
					� ���������="������������ �������������"		
		)	
		��� ���.������������="'.$par.'"';
		
		$sel = $q_obj->���������()->�������();
		if ($sel->���������()){
			return sprintf('<ref>%s</ref><drive_perm>%s</drive_perm>',
				$v8->String($sel->ref->�����������������������()),
				$v8->String($sel->drive_perm)
			);
		}	
	}
	
	function getPersonAttrs(){	
		$ref = $_REQUEST[PAR_DRIVER];
		if (!isset($ref)){
			throw new Exception("�� ����� ��������");
		}
		$v8 = new COM(COM_OBJ_NAME);
		$q_obj = $v8->NewObject('������');
		$q_obj->����� ='������� ������ 1
		����_plate.�������� ��� plate,
		"" ��� trailer_plate,
		"" ��� trailer_model,
		����_carrier.�������� ��� carrier_descr
		
		�� ����������.�������������� ��� ���
		
		����� ���������� ���������������.���������������������� ��� ����_plate
		�� ����_plate.������ = ���.������ � ����_plate.�������� � (
				������� ������ 1 ������
				�� ����������������������.��������������������������������
				��� ������������ = ��������(����������.���������������������������������������.����������_��������������)
				� ���������="��� ����� ����������"		
		)		

		����� ���������� ���������������.����������������������� ��� ����_carrier
		�� ����_carrier.������ = ���.������ � ����_carrier.�������� � (
				������� ������ 1 ������
				�� ����������������������.��������������������������������
				��� ������������ = ��������(����������.���������������������������������������.����������_��������������)
				� ���������="��. ���� ����������"		
		)		
		
		��� ���.������=&��������';
		
		$driver_id = $v8->NewObject('�����������������������',$ref);
		$driver_ref = $v8->�����������->��������������->��������������($driver_id);
		$q_obj->������������������('��������',$driver_ref);
		
		$sel = $q_obj->���������()->�������();
		if ($sel->���������()){
			return sprintf('<plate>%s</plate><trailer_plate>%s</trailer_plate><trailer_model>%s</trailer_model><carrier_descr>%s</carrier_descr>',
				$v8->String($sel->plate),
				$v8->String($sel->trailer_plate),
				$v8->String($sel->trailer_model),
				$v8->String($sel->carrier_descr)				
			);
		}	
	}
	
	function get_item_mu($v8,$item,$item_ref){		
		$mu_id = $v8->NewObject('�����������������������',$item['measure_unit_ref']);
		$mu_ref = $v8->�����������->������������������������->��������������($mu_id);
		//throw new Exception('MU='.$mu_ref->������������.' len='.$item['mes_length']);
		$q = '������� ������ �� ����������.������������������������
		��� �������� = &������������ � ���������������� = &����������������';
		$q_obj = $v8->NewObject('������',$q);
		$q_obj->������������������('������������',$item_ref);
		$q_obj->������������������('����������������',$mu_ref);		
		$sel = $q_obj->���������()->�������();
		if ($sel->���������()){
			return $sel->������;
		}
		
		$k = floatval($item['measure_unit_k']);
		$k = ($k>0)? $k:1;
		
		//���������� ��� �/�/�
		$mu_ref_mm = $v8->�����������->������������������������->�������������������(CONST_1C_MU_MM,TRUE);
		
		$new_item_mu = $v8->�����������->������������������������->��������������();
		$new_item_mu->������������				= sprintf('%s (%f %s)',trim($mu_ref->������������),$k,trim($item_ref->����������������->������������));
		$new_item_mu->��������					= $item_ref;
		$new_item_mu->����������������			= $mu_ref;
		$new_item_mu->���������������������		= $v8->������������->���������������������->��������;				
		$new_item_mu->�����������				= $v8->������������->������������������������->��������;
		$new_item_mu->���������					= $k;
		$new_item_mu->�������					= $item['mes_length'];
		$new_item_mu->�����������������������	= (isset($item['mes_length']))? $mu_ref_mm : NULL;
		$new_item_mu->������					= $item['mes_width'];
		$new_item_mu->����������������������	= (isset($item['mes_length']))? $mu_ref_mm : NULL;
		$new_item_mu->������					= $item['mes_height'];
		$new_item_mu->����������������������	= (isset($item['mes_height']))? $mu_ref_mm : NULL;
		$new_item_mu->��������();
		return $new_item_mu->������;
	}
	
	function get_item($v8,$item){
		$name = cyr_str_decode($item['product_name']);
		//.' '.$item['mes_length'].'x'.$item['mes_width'].'x'.$item['mes_height'];
		$item_ref = $v8->�����������->������������->�������������������($name,TRUE);		
		if ($item_ref->������()){
			$group1_ref = $v8->�����������->������������->�������������������(CONST_1C_ITEM_GROUP_NAME,TRUE);
			if ($group1_ref->������()){
				//����� ������
				$new_grp = $v8->�����������->������������->�������������();
				$new_grp->������������ = $ITEM_GROUP_NAME;
				$new_grp->��������();
				$group1_ref = $new_grp->������;			
			}

			$group_name = cyr_str_decode($item['group_name']);
			$group2_ref = $v8->�����������->������������->�������������������($group_name,TRUE,$group1_ref);
			if ($group2_ref->������()){
				//����� ������
				$new_grp = $v8->�����������->������������->�������������();
				$new_grp->������������ = $group_name;
				$new_grp->�������� = $group1_ref;
				$new_grp->��������();
				$group2_ref = $new_grp->������;
			}
			
			
			//������� ������� web
			$bmu_id = $v8->NewObject('�����������������������',$item['base_measure_unit_ref']);
			$bmu_ref = $v8->�����������->������������������������->��������������($bmu_id);
			$item_kind_ref = $v8->�����������->����������������->�������������������(CONST_1C_ITEM_KIND,TRUE);
			if ($item_kind_ref->������()){
				throw new Exception('�� ������ ��� ������������ "'.CONST_1C_ITEM_KIND.'"!');
				/*
				$item_kind						= $v8->�����������->����������������->��������������();
				$item_kind->������������		= '��������� (�/�)';
				$item_kind->���������������		= $v8->������������->����������������->�����;
				$item_kind_ref = $item_kind->������;
				*/
			}
		
			$item_fin_grp_ref = $v8->�����������->����������������������������������->�������������������(CONST_1C_FIN_GRP,TRUE);
			if ($item_fin_grp_ref->������()){
				throw new Exception('�� ������� ������ ���.�������� ������������ "'.CONST_1C_FIN_GRP.'"!');
			}
			//����� ������������
			$new_item = $v8->�����������->������������->��������������();
			$new_item->������������������������			= $v8->������������->�������������������������->����������������������;
			$new_item->������������						= $name;
			$new_item->������������������				= $name;
			$new_item->����������������������			= $item_fin_grp_ref;
			$new_item->��������							= $v8->������������->����������������->����������������;				
			$new_item->�������������					= $v8->�����������->��������������->�����������������������������;
			//$new_item->�������������					= $v8->�����������->�������������������������->;
			$new_item->����������������					= $bmu_ref;
			$new_item->��������������������������		= $v8->������������->����������������������������������������������->��������������;				
			$new_item->��������������������				= TRUE;
			$new_item->���������						= $v8->������������->���������->���18;				
			$new_item->���������������					= $v8->������������->����������������->�����;
			$new_item->���������������					= $item_kind_ref;
			$new_item->��������							= $group2_ref;
			$new_item->��������();			
			
			$item_ref = $new_item->������;
		}
		return $item_ref;
	}

	function get_currency($v8){
		return $v8->�����������->������->�����������('643');
	}
	
	function get_nds($v8,$calcNDS){
		return $calcNDS? $v8->������������->���������->���18 : $v8->������������->���������->������;
	}
	
	function get_nds_percent($calcNDS){
		return $calcNDS? 18 : 0;
	}
	
	function get_ext_obr($v8){
		$ext_form = $v8->�����������->������������������������������->�������������������(CONST_1C_OBR_NAME,TRUE);
		if ($ext_form->������()){
			throw new Exception('�� ������� ������� ��������� "'.CONST_1C_OBR_NAME.'"');
		}
		$f = $v8->��������������������������();
		$d = $ext_form->������������������->��������();
		$d->��������($f);
		return $v8->����������������->�������($f,FALSE);
	}

	function get_doc_comment($head){
		$COMMENT = '';
		if (isset($head['client_comment'])){
			$COMMENT = cyr_str_decode($head['client_comment']);
		}
		if (isset($head['sales_manager_comment'])){
			$COMMENT.= ($COMMENT=='')? '':' ';
			$COMMENT.= cyr_str_decode($head['sales_manager_comment']);
		}
		return $COMMENT;
	}
	
	function get_client_sogl($v8,$client_ref,$firm_ref,$attrs){
		$q_obj = $v8->NewObject('������');
		$q_obj->����� ='������� ������ 1 ������ �� ����������.��������������������
		��� ������ = ��������(������������.���������������������������.���������)';
		//�����������=&firm � ����������=&client � �������';		
		//$q_obj->������������������('firm',$firm_ref);
		//$q_obj->������������������('client',$client_ref);
		$sel = $q_obj->���������()->�������();
		if ($sel->���������()){
			return $sel->������;
		}
		throw new Exception("�� ������� ���������� � ��������!");
		//����� ����������
		$dog = $v8->�����������->��������������������->��������������();		
		$dog->������������							= CONST_1C_ACCORD_NAME;			
		//$dog->����������							= $client_ref;
		$dog->�������								= $client_ref->�������;
		$dog->�����������							= $firm_ref;
		$dog->������								= get_currency($v8);
		$dog->�������								= TRUE;
		$dog->������								= $v8->������������->���������������������������->���������;
		$dog->���������������������					= $v8->������������->���������������������->�����������������;
		$dog->�����������							= 'web';
		/*
		if (isset($attrs['contract_number'])){
			$dog->�����								= $attrs['contract_number'];
		}
		*/
		$dog->��������();
		return $dog->������;
	}
	
	function create_client_dog($v8,$clientRef,$firm_ref,$attrs){
		//����� �������
		$dog = $v8->�����������->��������������������->��������������();		
		$dog->������������							= '�������� �������';
		$dog->��������������������					= get_currency($v8);		
		$dog->�����������							= $firm_ref;
		$dog->����������							= $clientRef;		
		$dog->�������								= $clientRef->�������;
		$dog->�������������							= $v8->������������->��������������������������->���������������������������;
		$dog->���������������						= $v8->������������->���������������->�����������������������;//�����������
		$dog->������								= $v8->������������->����������������������������->���������;
		$dog->���������������������					= $v8->������������->���������������������->�����������������;
		$dog->�����������							= $v8->������������->�������������->������������;		
		$dog->�����������							= 'web';
		//$dog->�����������������������				= $v8->;
		//$dog->���������������������					= $v8->������������->����������������������->������������;
		
		if ($attrs){
			if ($attrs['pay_debt_sum']){
				$dog->����������������������������			= floatval($attrs['pay_debt_sum']);
			}
			if ($attrs['pay_delay_days']){
				//$dog->��������������������������������		= intval($attrs['pay_delay_days']);			
			}
			if ($attrs['pay_ban_on_debt_sum']){
				$dog->������������������������������������		= ($attrs['pay_ban_on_debt_sum']=='t');
			}
			if ($attrs['pay_ban_on_debt_days']){
				//$dog->������������������������������������	= ($attrs['pay_ban_on_debt_days']=='t');
			}
			if (isset($attrs['contract_date_from'])){
				$dog->����									= $attrs['contract_date_from'];
				$dog->������������������					= $attrs['contract_date_from'];
			}
			if (isset($attrs['contract_number'])){
				$dog->�����									= $attrs['contract_number'];
			}
			if (isset($attrs['contract_date_to'])){
				$dog->���������������������							= $attrs['contract_date_to'];
			}
		}
		
		$dog->��������();		
		return $dog->������;
	}
	
	function get_client_dog($v8,$client_ref,$firm_ref,$attrs){			
		$q_obj = $v8->NewObject('������');
		$q_obj->����� ='������� ������ 1 ������ �� ����������.��������������������
		��� ����������=&client � �����������=&firm � �����������=��������(������������.�������������.������������)';
		$q_obj->������������������('client',$client_ref);
		$q_obj->������������������('firm',$firm_ref);		
		$sel = $q_obj->���������()->�������();
		$dog_ref = NULL;
		if ($sel->���������()){
			return $sel->������;
		}
		
		return create_client_dog($v8,$client_ref,$firm_ref,$attrs);
	}
	
	function get_item_pack($v8){
		return $v8->�����������->������������->�������������������(CONST_1C_ITEM_NAME_PACK,TRUE);
	}
	function get_item_deliv($v8){
		return $v8->�����������->������������->�������������������(CONST_1C_ITEM_NAME_DELIV,TRUE);
	}
	
	function get_kassa($v8,$firm_ref){		
		$q_obj = $v8->NewObject('������');
		$q_obj->����� ='������� ������ 1
		������
		�� ����������.�����
		��� ��������=&�����������
		';
		$q_obj->������������������('�����������',$firm_ref);
		
		$sel = $q_obj->���������()->�������();
		$kassa_ref = NULL;
		if ($sel->���������()){
			$kassa_ref = $sel->������;
		}
		
		if (is_null($kassa_ref)){
			$kassa_ob = $v8->�����������->�����->��������������();
			$kassa_ob->��������					= $firm_ref;
			$kassa_ob->������������				= '�������� �����';
			$kassa_ob->���������������������	= get_currency($v8);
			$kassa_ob->��������();
			$kassa_ref = $kassa_ob->������;
		}
		
		return $kassa_ref;
	}
	
	function fill_otvetstv($v8,$firm_ref,$head_user_ref,$otvType,&$user_ref,&$otv_ref,&$otv_post){
		$user_id = $v8->NewObject('�����������������������',$head_user_ref);			
		$user_ref = $v8->�����������->������������->��������������($user_id);
		
		if (!$user_ref->��������������->������()){
			$par_date = date("Y,m,d,23,59,59");
			$q_obj = $v8->NewObject('������');
			$q_obj->����� ='������� ������ 1
			���.������ ��� �������,
			���.��������� ��� ���������
			�� ����������.���������������������������� ��� ���
			���			
			(���.��������=&�����������)
			� (���.��������������=&��������������)
			� (���.������������� = ���������(1,1,1,0,0,0)
			��� ( (���.������������� <> ���������(1,1,1,0,0,0))
				� (���.������������� < ���������('.date('Y,m,d,23,59,59').'))
				)
			)
			� (���.�����������������=&�����������������)
			';
			$q_obj->������������������('�����������',$firm_ref);
			$q_obj->������������������('��������������',$user_ref->��������������);
			$q_obj->������������������('�����������������',$otvType);
			$sel = $q_obj->���������()->�������();
			if ($sel->���������()){
				$otv_post = $sel->���������;
				$otv_ref = $sel->�������;
			}				
		}
	}
	
	function get_org_acc($v8,$firmRef){
		$acc_ref = NULL;
		$q_obj = $v8->NewObject('������');
		$q_obj->����� ='������� ������ 1 ����.������ �� ����������.�������������������������� ��� ����
		����� ���������� ����������.��������������������������.����������������������� ��� ���
		�� ���.������=����.������ � ���.�������� � (
			������� ������ 1 ������
			�� ����������������������.��������������������������������
			��� ������������ = ��������(����������.���������������������������������������.����������_��������������������������)
			� ���������="'.CONST_1C_ACC_ATTR.'"		
		)
		��� ����.�������� = &firm � ���.��������=������';		
		$q_obj->������������������('firm',$firmRef);
		$sel = $q_obj->���������()->�������();
		if ($sel->���������()){
				$acc_ref = $sel->������;
		}		
		return $acc_ref;
	}

	function get_client_acc($v8,$clientRef){
		$acc_ref = NULL;
		$q_obj = $v8->NewObject('������');
		$q_obj->����� ='������� ������ 1 ����.������ �� ����������.��������������������������� ��� ����
		��� ����.�������� = &client � �� ����.������ � �� ����.���������������';		
		$q_obj->������������������('client',$clientRef);
		$sel = $q_obj->���������()->�������();
		if ($sel->���������()){
				$acc_ref = $sel->������;
		}		
		return $acc_ref;
	}

	function get_partner($v8,$attrs,$name,$nameFull){
		$partner_ref = $v8->�����������->��������->�������������������($name,TRUE());
		if ($partner_ref->������()){
			$obj = $v8->�����������->��������->��������������();
			$obj->������				= TRUE;
			$obj->�����������			= 'Web';
			$obj->������������������	= $nameFull;
			$obj->���������				= (strlen($attrs['inn'])==10)? $v8->������������->�������������������->��������:$v8->������������->�������������������->�����������;
			$obj->��������();
			
			$partner_ref = $obj->������;
		}
		return $partner_ref;
	}
	
	function client($v8,$attrs){
		$obj = NULL;
		$client_ref = get_client_ref_on_inn($v8,$attrs['inn']);
		if (is_null($client_ref)){
			$obj = $v8->�����������->�����������->��������������();
			$obj->������������					= stripslashes(cyr_str_decode($attrs['name']));
			$obj->������������������			= stripslashes(cyr_str_decode($attrs['name_full']));
			$obj->���������						= (strlen($attrs['inn'])==10)? $v8->������������->���������->������:$v8->������������->���������->�������;
			$obj->�������������������������		= (strlen($attrs['inn'])==10)? $v8->������������->�������������������������->���������������:$v8->������������->�������������������������->��������������;
			$obj->���							= $attrs['inn'];
			$obj->���������						= $attrs['okpo'];
			$obj->���							= $attrs['kpp'];
			$obj->�������						= get_partner($v8,$attrs,$obj->������������,$obj->������������������);
			$obj->��������();
			
			$client_ref = $obj->������;
		}
		
		$acc = get_client_acc($v8,$client_ref);
		
		if (is_null($acc)){
			$acc = $v8->�����������->���������������������������->��������������();
			$acc->��������				= $client_ref;
			$acc->������������			= '�������� ����';
			$acc->����������			= $attrs['acc'];
			$acc->���������������������	= get_currency($v8);
			$bank_ref = $v8->�����������->�������������������->�����������($attrs['bank_code']);
			if ($bank_ref->������()){
				//��� ������ �����
				throw new Exception('���� ��� '.$attrs['bank_code'].' � 1� �� ������!');
			}
			$acc->���� = $bank_ref;		
			$acc->��������();			
		}
		
		return $v8->String($client_ref->�����������������������());
	}
	
	function order($v8,$head,$items){		
		$COMMENT = 'web '.get_doc_comment($head);
		
		$firm_id = $v8->NewObject('�����������������������',$head['firm_ref']);
		
		$warehouse_id = $v8->NewObject('�����������������������',$head['warehouse_ref']);
		$client_id = $v8->NewObject('�����������������������',$head['client_ref']);
		
		$firm_ref = $v8->�����������->�����������->��������������($firm_id);
		$client_ref = $v8->�����������->�����������->��������������($client_id);
		
		$warehouse_ref = $v8->�����������->������->��������������($warehouse_id);
		
		$deliv_total = floatval($head['deliv_total']);
		$pack_total = floatval($head['pack_total']);
		
		$acc_ref = get_org_acc($v8,$firm_ref);
		
		if (isset($head['ext_order_id'])){
			//����������� ���������
			$order_id = $v8->NewObject('�����������������������',$head['ext_order_id']);
			$order_ref = $v8->���������->������������->��������������($order_id);
			$doc = $order_ref->��������������();
			if ($doc->��������){
				$doc->�������� = FALSE;
			}
			if ($doc->������->����������()>0){
				$doc->������->��������();
			}			
		}
		else{
			$doc = $v8->���������->������������->���������������();	
		}
		
		$calcNDS = ($head['firm_nds']=='t' || $head['firm_nds']=='true');
		
		$attrs = array();
		$attrs['pay_debt_sum'] = 0;
		$attrs['pay_delay_days'] = 0;
		$attrs['pay_ban_on_debt_sum'] = FALSE;
		$attrs['pay_ban_on_debt_days'] = FALSE;			
		
		$doc->����								= $head['date'];
		$doc->�������							= $client_ref->�������;
		$doc->����������						= $client_ref;	
		$doc->�����������						= $firm_ref;
		$doc->����������						= get_client_sogl($v8,$client_ref,$firm_ref,$attrs);
		$doc->������							= get_currency($v8);
		$doc->��������������������				= ($head['delivery_plan_date'])? get_1c_date($head['delivery_plan_date']) : NULL;
		$doc->�����								= $warehouse_ref;
		$doc->���������������					= TRUE;
		$doc->������							= $v8->������������->����������������������->������������; //$v8->������������->����������������������->��������� :
		$doc->����������						= TRUE;
		$doc->����������������					= $doc->����;
		$doc->�����������						= ($head['pay_cash']=='t')?
														$v8->������������->�����������->�������� : 
														$v8->������������->�����������->�����������;
		$doc->��������������					= $acc_ref;
		//$doc->�������������������������
		if ($head['pay_cash']=='t'){
			$doc->����� = get_kassa($v8,$firm_ref);
		}
		//$doc->������������						= $doc->��������������������;
		$doc->�������������						= cyr_str_decode($head['deliv_address']);
		$doc->������������������				= ($calcNDS)?
													$v8->������������->����������������������->�������������������� :
													$v8->������������->����������������������->����������������������;
		$doc->���������������������				= $v8->������������->���������������������->�����������������;
		$doc->�����������						= $COMMENT;
		$doc->�������							= get_client_dog($v8,$client_ref,$firm_ref,$attrs);
		
		$doc->���������������					= $doc->�������->���������������; //$v8->������������->���������������->������������������;
		$doc->��������������					= $v8->������������->���������������->���������;		
		/*
												($deliv_total)?
														$v8->������������->���������������->��������� : 
													$v8->������������->���������������->���������;
		*/
		//$doc->�����������������
		$doc->�������������						= $v8->������������->��������������������������->���������������������������;
		$doc->���������							= $v8->�����������->����������->�������������������(CONST_1C_PRIORITY,TRUE);
		$doc->������������������				= TRUE;
		$doc->������������						= ($head['delivery_plan_date'])? get_1c_date($head['delivery_plan_date']) : $head['date'];
		
		$stavka = get_nds($v8,$calcNDS);
		$nds_percent = get_nds_percent($calcNDS);
		$total = (float) 0.0;
		foreach($items as $item){
			//������������
			$item_ref = get_item($v8,$item);
			
			$line = $doc->������->��������();
			$line->������������ 			= $item_ref;
			$line->������������������ 		= floatval($item['quant']);
			$line->��������					= get_item_mu($v8,$item,$item_ref);
			$line->�����					= floatval($item['total']);
			$line->����						= $line->�����/$line->������������������;
			$line->������������������		= $v8->������������->�������������������->���������; //���������;
			$line->�����					= $doc->�����;
			$line->����������				= $line->������������������ * floatval($item['measure_unit_k']);
			//$line->������������			= 
			
			$line->���������				= $stavka;
			if ($calcNDS){				
				$line->��������				= round(floatval($item['total'])*$nds_percent/(100+$nds_percent),2);
			}
			$line->��������� 				= $line->�����;
			
			$total+= floatval($item['total']);
		}
	
		if ($deliv_total){
			$q = intval($head['deliv_vehicle_count']);
			$q = (!$q)? 1:$q;
			
			$item_ref = get_item_deliv($v8);
			$line = $doc->������->��������();			
			$line->������������ 			= $item_ref;
			$line->������������������ 		= $q;
			$line->��������					= $item_ref->����������������;
			$line->����						= round($deliv_total/floatval($q),2);
			$line->�����					= $deliv_total;
			$line->������������������		= $v8->������������->�������������������->���������; //���������;						
			$line->�����					= $doc->�����;
			$line->����������				= 1;
			
			$line->���������				= $stavka;
			if ($calcNDS){				
				$line->��������				= round($deliv_total*$nds_percent/(100+$nds_percent),2);
			}
			$line->��������� = $line->�����;
			
			$total+= $deliv_total;
		}

		if ($pack_total){
			$item_ref = get_item_pack($v8);
			$line = $doc->������->��������();
			$line->������������������ 		= 1;
			$line->��������					= $item_ref->����������������;//get_item_mu($v8,$item,$item_ref);
			$line->������������ 			= $item_ref;
			$line->����						= $pack_total;
			$line->�����					= $pack_total;
			$line->����������				= 1;
			
			$line->���������				= $stavka;
			if ($calcNDS){				
				$line->��������				= round($pack_total*$nds_percent/(100+$nds_percent),2);
			}
			$line->��������� = $line->�����;
			
			$total+= $pack_total;
		}
		
		/*
		$line = $doc->������������������->��������();
		$line->�������������	= $v8->������������->����������������������->��������������������;
		$line->�����������		= $doc->����;
		$line->��������������	= 100;
		$line->������������		= $total;
		*/
		//�������������������
		//������������������

		//����� ���������
		if ($head['user_ref']){
			$user_ref = $v8->�����������->������������->������������();
			
			$otv1_ref = $v8->�����������->����������������������������->������������();
			$otv1_post = '';
			fill_otvetstv($v8,$firm_ref,$head['user_ref'],$v8->������������->����������������������������->������������,$user_ref,$otv1_ref,$otv1_post);

			$otv2_ref = $v8->�����������->����������������������������->������������();
			$otv2_post = '';
			fill_otvetstv($v8,$firm_ref,$head['user_ref'],$v8->������������->����������������������������->����������������,$user_ref,$otv2_ref,$otv2_post);
			
			$doc->�����				= $user_ref;			
			$doc->��������			= $user_ref;						
			$doc->������������		= $otv1_ref;					
			$doc->����������������	= $otv2_ref;
		}

		$doc->��������������		= $total;
		$doc->��������($v8->��������������������->����������);		
		
		return sprintf(
		'<orderRef>%s</orderRef>
		<orderNum>%s</orderNum>',
		$v8->String($doc->������->�����������������������()),
		cyr_str_encode($doc->�����)
		);
	}

	function pko($v8,$head,$payTypeCash){
		$COMMENT = '#web';
		//$CLIENT_NAME = '���������� ����';
		
		foreach($head as $firm_ar){			
			$sum = floatval($firm_ar['total']);
			if (!$sum) continue;
			
			$firm_ref = $firm_ar['firm_ref'];
			$firm_id = $v8->NewObject('�����������������������',$firm_ref);
			$firm_ref = $v8->�����������->�����������->��������������($firm_id);
			/*
			if ($firm_ref->������������=='�� ������������ �������� �.�'){
				$CLIENT_NAME = '�� �������� �.�. �� ������������';
			}
			else if ($firm_ref->������������=='����������� �������� �.�'){
				$CLIENT_NAME = '�� �������� �.�. �����������';
			}			
			else{
				$CLIENT_NAME = '���������� ����';
			}
			$client_ref = $v8->�����������->�����������->�������������������($CLIENT_NAME);
			*/
			$client_ref = $firm_ar['client_ref'];
			$client_id = $v8->NewObject('�����������������������',$client_ref);			
			$client_ref = $v8->�����������->�����������->��������������($client_id);
			
			//�������
			/*
			$attrs = array();
			$attrs['pay_debt_sum'] = 0;
			$attrs['pay_delay_days'] = 0;
			$attrs['pay_ban_on_debt_sum'] = FALSE;
			$attrs['pay_ban_on_debt_days'] = FALSE;			
			$dog_ref = get_client_dog($v8,$client_ref,$firm_ref,$attrs);
			*/
			
			$doc = $v8->���������->����������������������->���������������();	
			$doc->����							= date('YmdHis');
			$doc->�����							= get_kassa($v8,$firm_ref);
			$doc->�����������					= $firm_ref;
			$doc->��������������				= $sum;			
			$doc->���������������������			= $v8->������������->���������������������->��������������������������;
			$doc->���������						= '��������� ����������';
			$doc->���������						= '';
			$doc->����������					= '';
			$doc->����������					= $client_ref;
			$doc->������						= get_currency($v8);
			$doc->�����������������������������	= $v8->�����������->�����������������������������->��������������������������;
			
			//������
			$line = $doc->������������������->��������();
			$line->�����������������������������	= $doc->�����������������������������;
			$line->�����							= $sum;
			$line->��������������������				= $doc->������;
			$line->�������������������				= $sum;
			$line->���������						= $v8->������������->���������->���18;
			$line->��������							= round($sum*18/118,2);
			
			//����� ���������
			/*
			if ($firm_ar['user_ref']){
				$user_id = $v8->NewObject('�����������������������',$firm_ar['user_ref']);			
				$doc->������������� = $v8->�����������->������������->��������������($user_id);			
			}
			*/
			if ($payTypeCash){
				$pref='����� ';
			}
			else{
				$pref='';
			}
			$doc->����������� = $pref.'������ �����������: '.$firm_ar['numbers'].', ������:'.cyr_str_decode($firm_ar['client_descr']);
			$doc->��������($v8->��������������������->������);
		}
	}
	
	function sale($v8,$head,$items){		
		$q_crm_num = '������� ������ 1 ������
		�� ����������������������.��������������������������������
		��� ������������ = ��������(����������.���������������������������������������.��������_����������������������)
		� ���������="'.CONST_1C_DOC_ATTR.'"';
				
		if ($head['number']){
			//��������� ����� �� ������, ����� �������� ��� ���� � 1�?!
			$q_obj = $v8->NewObject('������');
			$q_obj->����� ='�������
			���.������,
			���.�����,
			���.������ ��� ���������,
			���.����� ��� ��������
			�� ��������.���������������������� ��� ���			
			����� ���������� ��������.������������������� ��� ���
			�� ���.����������������� = ���.������			
			����� ���������� ���������������.���������������������� ��� ������
			�� ������.������ = ���.������ � ������.�������� � ('.$q_crm_num.')
			��� ������.��������=&���������������������CRM
			';
			$q_obj->������������������('���������������������CRM',$head['number']);
			$sel = $q_obj->���������()->�������();
			if ($sel->���������()){
				if ($sel->���������){
					$inv_num = cyr_str_encode($sel->��������);
					$inv_id = $v8->String($sel->���������->�����������������������());
				}
				else{
					$inv_num = '';
					$inv_id = '';
				}
				return sprintf(
					'<naklRef>%s</naklRef>
					<naklNum>%s</naklNum>
					<invRef>%s</invRef>
					<invNum>%s</invNum>',		
					$v8->String($sel->������->�����������������������()),
					cyr_str_encode($sel->�����),
					$inv_id,
					$inv_num
				);
			}
		}
	
		$COMMENT = get_doc_comment($head);
		
		$firm_id = $v8->NewObject('�����������������������',$head['firm_ref']);
		$warehouse_id = $v8->NewObject('�����������������������',$head['warehouse_ref']);
		$client_id = $v8->NewObject('�����������������������',$head['client_ref']);
		
		$firm_ref = $v8->�����������->�����������->��������������($firm_id);
		$client_ref = $v8->�����������->�����������->��������������($client_id);
		$warehouse_ref = $v8->�����������->������->��������������($warehouse_id);		
	
		$deliv_total = floatval($head['deliv_total']);
		$pack_total = floatval($head['pack_total']);
		
		$doc = $v8->���������->����������������������->���������������();	
		
		/* ����������� ����������� � ��������� �����*/
		$order_num = '';
		if (isset($head['ext_order_id'])){
			$order_id = $v8->NewObject('�����������������������',$head['ext_order_id']);
			$order_ref = $v8->���������->������������->��������������($order_id);
			$order_num = '/'.substr($order_ref->�����,strlen($order_ref->�����)-5).' ';
			$doc->������������ = $order_ref;
			
			//$order_obj = $order_ref->��������������();
			//$order_obj->������ = $v8->������������->����������������������->������������;
			//$order_obj->��������();
		}
		
		if ($head['carrier_ref']){
			$carrier_id = $v8->NewObject('�����������������������',$head['carrier_ref']);
			$carrier_ref = $v8->�����������->�����������->��������������($carrier_id);							
		}
		else if ($head['deliv_type']=='by_supplier'){
			//org->>client
			$carrier_ref = get_client_ref_on_inn($v8,$firm_ref->���);	
			if (is_null($carrier_ref)){
				throw new Exception('�� ������� ����������� '.$firm_ref->������������.' � ����������� ������������ �� ��� ��� ���������� � ���!');
			}			
		}
		
		$doc->����						= $head['date'];
		
		$calcNDS = ($head['firm_nds']=='t' || $head['firm_nds']=='true');
		
		$doc->�������������				= cyr_str_decode($head['deliv_address']);
		$doc->������					= get_currency($v8);
		$doc->��������������������		= $doc->������;		
		$doc->�����������				= $firm_ref;
		$doc->����������				= $client_ref;
		$doc->������������������		= ($calcNDS)?
											$v8->������������->����������������������->�������������������� :
											$v8->������������->����������������������->����������������������;
		$doc->�����������				= $doc->����;
		$doc->����������������			= get_1c_date(date('Y-m-d'),date('G'),removeLeadingZero(date('i')),removeLeadingZero(date('s')));
		$doc->�������					= $client_ref->�������;
		$doc->�������������				= $v8->�����������->��������������������->�������������������(CONST_1C_DEP,TRUE);
		$doc->�����						= $warehouse_ref;
		$doc->�����������				= 'web '.
											( ($head['number'])? $head['number'] : '').
											$order_num.$COMMENT;
		$doc->�����������				= ($head['pay_cash']=='t')? $v8->������������->�����������->��������:$v8->������������->�����������->�����������;
		$doc->���������������������		= $v8->������������->���������������������->�����������������;
		$doc->���������������			= $calcNDS;
		$doc->����������������			= FALSE;
		if ($head['pay_cash']=='t'){
			$doc->����� = get_kassa($v8,$firm_ref);
		}
		
		$attrs = array();
		$attrs['pay_debt_sum'] = 0;
		$attrs['pay_delay_days'] = 0;
		$attrs['pay_ban_on_debt_sum'] = FALSE;
		$attrs['pay_ban_on_debt_days'] = FALSE;					
		$doc->�������					= get_client_dog($v8,$client_ref,$firm_ref,$attrs);		
		$doc->���������					= $doc->�������->������������;
		$doc->�������������	 			= $doc->�������->����;
		$doc->��������������			= $doc->�������->�����;
		$doc->����������				= get_client_sogl($v8,$client_ref,$firm_ref,$attrs);
		$doc->������					= $v8->������������->�����������������������������->���������;
		
		$doc->��������������			= $v8->������������->���������������->���������;
											/*($deliv_total)?
												$v8->������������->���������������->��������� : 
												$v8->������������->���������������->���������;
											*/
		if ($head['carrier_ref']){
			$doc->�����������������		= $carrier_ref->�������;
		}		
											
		$doc->���������					= 1;
		$doc->����						= 1;
		$doc->�������������������		= FALSE;
		$doc->���������������			= $doc->�������->���������������; //$v8->������������->���������������->������������������;
		$doc->�������������������������	= FALSE;
		$doc->�������������������������	= FALSE;
		$doc->��������������������		= FALSE;
		$doc->������������������������	= $v8->������������->�������������������������->����������������������;
		$doc->����������������������	= FALSE;
		$doc->�������������				= $v8->������������->��������������������������->���������������������������;
		$doc->���������������������������� = FALSE;		
				
		$stavka = get_nds($v8,$calcNDS);
		$nds_percent = get_nds_percent($calcNDS);
		$total=0;
		
		foreach($items as $item){
			if (!$item['quant']){
				//����� ������� ������ �������� ������ ������������???
				continue;
			}
			//������������
			$item_ref = get_item($v8,$item);
			
			$line = $doc->������->��������();
			$line->������������ 			= $item_ref;
			$line->������������������ 		= $item['quant'];			
			$line->��������					= get_item_mu($v8,$item,$item_ref);
			$line->�����					= $item['total'];
			$line->����						= $line->�����/$line->������������������;
			$line->�����					= $doc->�����;
			$line->����������				= $line->������������������ * floatval($item['measure_unit_k']);
			
			$line->���������				= $stavka;
			if ($calcNDS){				
				$line->��������				= round(floatval($item['total'])*$nds_percent/(100+$nds_percent),2);
			}
			$line->���������				= $line->�����;
			$line->�������������������		= $line->�����;
			
			$total+= floatval($item['total']);
			
		}
	
		if ($deliv_total){
			$q = intval($head['deliv_vehicle_count']);
			$q = (!$q)? 1:$q;
		
			$item_ref = get_item_deliv($v8);
			$line = $doc->������->��������();			
			$line->������������ 			= $item_ref;			
			$line->����						= round($deliv_total/floatval($q),2);
			$line->�����					= $deliv_total;
			$line->����������				= $q;
			$line->������������������ 		= $q;
			
			$line->���������				= $stavka;
			if ($calcNDS){				
				$line->��������				= round($deliv_total*$nds_percent/(100+$nds_percent),2);
			}
			$line->���������				= $line->�����;
			$line->�������������������		= $line->�����;
			
			$total+= $deliv_total;
		}

		if ($pack_total){
			$item_ref = get_item_pack($v8);
			$line = $doc->������->��������();			
			//$line->��������				= $item_ref->����������������;
			$line->������������ 			= $item_ref;
			$line->����						= $pack_total;
			$line->�����					= $pack_total;
			$line->����������				= 1;
			$line->������������������ 		= 1;
			
			$line->���������				= $stavka;
			if ($calcNDS){				
				$line->��������				= round($pack_total*$nds_percent/(100+$nds_percent),2);
			}
			$line->���������				= $line->�����;
			$line->�������������������		= $line->�����;
			
			$total+= $pack_total;
		}
		
		//����� ���������
		if ($head['user_ref']){
			$user_ref = $v8->�����������->������������->������������();
			
			$otv1_post = '';
			fill_otvetstv($v8,$firm_ref,$head['user_ref'],$v8->������������->����������������������������->������������,$user_ref,$otv1_ref,$otv1_post);

			$otv2_ref = $v8->�����������->����������������������������->������������();
			$otv2_post = '';
			fill_otvetstv($v8,$firm_ref,$head['user_ref'],$v8->������������->����������������������������->����������������,$user_ref,$otv2_ref,$otv2_post);
			
			$doc->����� = $user_ref;			
			$doc->�������� = $user_ref;			
			$doc->�������� = $user_ref->��������������;			
			$doc->����������������� = $otv1_post;
			$doc->���������������� = $otv2_ref;
			$doc->������������ = $otv1_ref;					
		}
		
		$doc->�������������� = $total;
		$doc->������������������� = $total;
		$doc->��������($v8->��������������������->����������);//����������
		
		if ($head['number']){
			$q_obj = $v8->NewObject('������');
			$q_obj->����� =$q_crm_num;
			$sel = $q_obj->���������()->�������();
			if (!$sel->���������()){
				throw new Exception('�� ������� ���.�������� ���������� ����� CRM!');
			}
			$rec_set = $v8->����������������->����������������������->�������������������();
			$rec_set->�����->������->����������($doc->������);
			$rec = $rec_set->��������();
			$rec->������ = $doc->������;
			$rec->�������� = $sel->������;
			$rec->�������� = $head['number'];			
			$rec_set->��������();
		}		
		
		//���� �������
		$inv_id = '';
		$inv_num = '';
				
		if ($head['pay_cash']!='t' && $calcNDS){
			$doc_inv = $v8->���������->�������������������->���������������();			
			$doc_inv->���������($doc->������);
			$doc_inv->���� 				= $doc->����;
			$doc_inv->����������� 		= $doc->�����������;
			$doc_inv->����������		= $doc->����������;
			$doc_inv->�����������������	= $doc->������;
			$doc_inv->���������������	= $doc->����;
			$doc_inv->�������������		= $doc->�������������;
			
			$line = $doc_inv->������������������->��������();
			$line->����������������� = $doc->������;
			
			$doc_inv->��������($v8->��������������������->����������);	//������ ����������
			
			$inv_id = $v8->String($doc_inv->������->�����������������������());
			$inv_num = cyr_str_encode($doc_inv->�����);
		}
		
		//TTN
		if ($head['deliv_type']=='by_supplier'){
			/*
			$doc_transp = $v8->���������->������������������->���������������();			
			$doc_transp->���� 									= $doc->����;
			$doc_transp->������									= $v8->������������->�������������������������->���������;
			$doc_transp->�����������							= 'Web';
			$doc_transp->�������������							= ($head['user_ref'])? $user_ref:NULL;
			//$doc_transp->��������������������					= 
			if ($head['driver_ref']){
				$driver_id = $v8->NewObject('�����������������������',$head['driver_ref']);
				$driver_ref = $v8->�����������->��������������->��������������($driver_id);							
				$doc_transp->��������							= $driver_ref;
			}
			$doc_transp->�����									= $doc->�����;
			$doc_transp->���									= $head['total_weight'];
			$doc_transp->�����									= $head['total_volume'];
			$doc_transp->�����������������						= 1;
			//$doc_transp->���������								= 
			$doc_transp->��������								= $v8->������������->������������->��������;
			$doc_transp->����������								= ($head['carrier_ref'])? $carrier_ref->������� : $doc->����������->�������;
			$doc_transp->����������								= $doc->����������;
			$doc_transp->�������������������������			 	= ($head['carrier_ref'])? get_client_acc($v8,$carrier_ref) : get_client_acc($v8,$doc->����������);
			$doc_transp->�����������							= cyr_str_decode($head['driver_name']). (($head['driver_cel_phone'])? ', ���.'.$head['driver_cel_phone']:'');
			$doc_transp->������������������						= cyr_str_decode($head['driver_drive_perm']);
			$doc_transp->������������������������������			= cyr_str_decode($head['vh_plate']);
			$doc_transp->���������������						= '';
			$doc_transp->�������������							= cyr_str_decode($head['vh_model']);
			$doc_transp->��������������������������������������	= $head['vh_vol'];
			$doc_transp->���������������������������������		= $head['vh_load_weight_t'];
			$doc_transp->������									= cyr_str_decode($head['vh_trailer_model']);
			$doc_transp->���������������������������			= cyr_str_decode($head['vh_trailer_plate']);
			//$doc_transp->��������($v8->��������������������->����������);
			*/
			
			$doc_ttn = $v8->���������->���������������������->���������������();			
			$doc_ttn->���������($doc->������);
			$doc_ttn->���� 										= $doc->����;
			$doc_ttn->��������������������������������������	= $head['vh_vol'];//$doc_transp->��������������������������������������;
			$doc_ttn->������������������������������			= cyr_str_decode($head['vh_plate']);//$doc_transp->������������������������������;
			$doc_ttn->���������������������������������			= $head['vh_load_weight_t'];//$doc_transp->���������������������������������;
			$doc_ttn->���������������							= '';//$doc_transp->���������������;
			$doc_ttn->�������������								= cyr_str_decode($head['vh_model']);//$doc_transp->�������������;
			$doc_ttn->�������������								= $doc->�������������;
			$doc_ttn->�������������								= cyr_str_decode($head['warehouse_address']);
			$doc_ttn->��������									= cyr_str_decode($head['driver_name']);//$doc_transp->�����������;
			$doc_ttn->��������������������������������			= get_client_acc($v8,$doc->����������);
			$doc_ttn->�������������������������					= $doc_ttn->��������������������������������;			
			$doc_ttn->���������������������������				= $v8->������������->������������������������������������->��������������;
			$doc_ttn->���������������������������				= cyr_str_decode($head['vh_trailer_plate']);//$doc_transp->���������������������������;
			$doc_ttn->����������������							= $doc->�����������;
			$doc_ttn->���������������							= $doc->����������;
			$doc_ttn->�����������������							= $doc->����������;
			$doc_ttn->�����������								= $head['total_weight']*1000;
			//$doc_ttn->����������								= ;
			$doc_ttn->����������� 								= $doc->�����������;
			if ($head['user_ref']){
				$doc_ttn->��������									= $user_ref->��������������;			
				$doc_ttn->�����������������							= $otv1_post;
				$doc_ttn->����������������							= $otv2_ref;
				$doc_ttn->������������								= $otv1_ref;									
			}
			$doc_ttn->����������								= $doc->����������;
			
			$doc_ttn->����������								= $carrier_ref;
			$doc_ttn->�������������������������					= get_client_acc($v8,$carrier_ref);
			
			$doc_ttn->������									= cyr_str_decode($head['vh_trailer_model']);//$doc_transp->������;
			$doc_ttn->������������������						= cyr_str_decode($head['driver_drive_perm']);//$doc_transp->������������������;
			$doc_ttn->�����������								= 'web '.cyr_str_decode($head['number']);
			//$doc_ttn->������������������						= $doc_transp->������;
			
			$line = $doc_ttn->������������������->��������();
			$line->����������������� = $doc->������;
			$doc_ttn->��������($v8->��������������������->����������);	//������ ����������
		}
		
		
		return sprintf(
			'<naklRef>%s</naklRef>
			<naklNum>%s</naklNum>
			<invRef>%s</invRef>
			<invNum>%s</invNum>',		
			$v8->String($doc->������->�����������������������()),
			cyr_str_encode($doc->�����),
			$inv_id,
			$inv_num
		);
	}
	
	function del_docs($v8,$ext_order_id,$ext_ship_id){
		if ($ext_ship_id){
		}
		$order_id = $v8->NewObject('�����������������������',$ext_order_id);
		$order_ref = $v8->���������->������������->��������������($order_id);	
		if (!$order_ref->������()){
			$ob = $order_ref->��������������();
			$ob->�������();
		}
	}
	
?>
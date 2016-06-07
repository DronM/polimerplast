<?php
	function get_doc_comment($head){
		$COMMENT = 'web';
		if (isset($head['client_comment'])){
			$COMMENT.= ' '.cyr_str_decode($head['client_comment']);
		}
		if (isset($head['sales_manager_comment'])){
			$COMMENT.= ' '.cyr_str_decode($head['sales_manager_comment']);
		}
		return $COMMENT;
	}
	function fill_struc_for_ttn($v8,$head){
		$attrs = $v8->NewObject('���������');
		$attrs->��������("������������",cyr_str_decode($head["deliv_time"]));
		$attrs->��������("���������������",cyr_str_decode($head["veh_model"]));
		$attrs->��������("������������",cyr_str_decode($head["veh_trailer_model"]));
		$attrs->��������("������������������",cyr_str_decode($head["vh_plate"]));
		$attrs->��������("���������������",cyr_str_decode($head["vh_trailer_plate"]));
		$attrs->��������("�������������",cyr_str_decode($head["wareh_descr"]));
		$attrs->��������("��������������",cyr_str_decode($head["dest_descr"]));
		$attrs->��������("��������",cyr_str_decode($head["driver_name"]));
		
		$driver_ref = 0;
		if ($head["driver_ext_id"]){
			$driver_id = $v8->NewObject('�����������������������',$head['driver_ext_id']);
			$driver_ref = $v8->�����������->��������������->��������������($driver_id);			
		}
		$attrs->��������("����������",$driver_ref);
		
		$carrier = cyr_str_decode($head["carrier_descr"]);
		$firm = cyr_str_decode($head["firm_descr"]);
		if ($carrier){
			$attrs->��������("����������",$carrier);
			$attrs->��������("��������",$firm);
		}
		else{
			$attrs->��������("����������",$firm);
			$attrs->��������("��������",$firm);			
		}
		
		
		$attrs->��������("������������",cyr_str_decode($head["deliv_kind"]));
		$attrs->��������("��������������������",FALSE);
		$attrs->��������("�������������������������",cyr_str_decode($head["drive_perm"]));
		return $attrs;
	}
	
	function cyr_str_decode($str){
		return iconv('UTF-8','Windows-1251',$str);
	}
	function cyr_str_encode($str){
		//����� ���������� � ANSI
		return $str;//iconv('Windows-1251','UTF-8',$str);
	}
	function get_1c_date($d,$h=0,$m=0,$s=0){
		$parts = explode('-',str_replace("\'",'',$d));
		var_dump($parts);
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
	function check_client_buyer($v8,$client_ref){
		$q_obj = $v8->NewObject('������');
		$q_obj->����� ='�������
		���.����������,
		���.������������
		�� ����������.����������� ��� ���
		��� ���.������=&������������
		';
		$q_obj->������������������('������������',$client_ref);
		$sel = $q_obj->���������()->�������();
		if ($sel->���������()){
			if (!$sel->����������){
				throw new Exception('���������� '.$sel->������������.' �� ������� ��� ���������� � 1�!');
			}
		}
	
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
		$q_obj->����� ='������� ���.������ ��� ref
		�� ����������.'.$sprKind.' ��� ���
		��� ���.������������="'.$par.'"';
		//throw new Exception($q_obj->�����);
		$sel = $q_obj->���������()->�������();
		if ($sel->���������()){
			return sprintf('<ref>%s</ref>',
				$v8->String($sel->ref->�����������������������()));
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
		while ($sel->���������()){
			$xml_body.= sprintf("<ref name='%s'>%s</ref>",
				cyr_str_encode($sel->name),
				$v8->String($sel->ref->�����������������������()));
		}
	}
	
	function get_currency($v8){
		return $v8->�����������->������->�����������('643');
	}
	function get_nds($v8){
		return $v8->������������->���������->���18;
	}
	function get_nds_percent($v8,$stavka){
		return 18;
	}
	function get_ext_obr($v8){
		$ext_form = $v8->�����������->����������������->�������������������("API1C");
		$f = $v8->��������������������������();
		$d = $ext_form->�������������������������->��������();
		$d->��������($f);
		return $v8->����������������->�������($f,FALSE);
	}
	function create_client_dog($v8,$clientRef,$firm_ref,$attrs){
		//����� �������
		$dog = $v8->�����������->��������������������->��������������();
		$dog->��������								= $clientRef;
		$dog->������������							= '�������� �������';
		$dog->��������������������					= get_currency($v8);		
		$dog->���������������������					= $v8->������������->��������������������������������->����������������;
		$dog->�����������							= $firm_ref;
		$dog->�����������							= 'web';
		$dog->������������������					= $v8->������������->����������������������������������->������������������������;
		$dog->����������� 							= $v8->������������->�������������������������->������������;
		
		if ($attrs){
			if ($attrs['pay_debt_sum']){
				$dog->����������������������������			= floatval($attrs['pay_debt_sum']);
			}
			if ($attrs['pay_delay_days']){
				$dog->��������������������������������		= intval($attrs['pay_delay_days']);			
			}
			if ($attrs['pay_ban_on_debt_sum']){
				$dog->��������������������������������		= ($attrs['pay_ban_on_debt_sum']=='t');
			}
			if ($attrs['pay_ban_on_debt_days']){
				$dog->������������������������������������	= ($attrs['pay_ban_on_debt_days']=='t');
			}
			$dog->�����������	 						= $v8->������������->�������������������������->������������;
			if (isset($attrs['contract_date_from'])){
				$dog->����									= $attrs['contract_date_from'];
			}
			if (isset($attrs['contract_number'])){
				$dog->�����									= $attrs['contract_number'];
			}
			if (isset($attrs['contract_date_to'])){
				$dog->������������							= $attrs['contract_date_to'];
			}
		}
		//�����������������
		$dog->�������������������������������������� = TRUE;
		
		$dog->��������();		
		return $dog->������;
	}
	function get_kassa($v8,$firm_ref){		
		$q_obj = $v8->NewObject('������');
		$q_obj->����� ='������� ������ 1
		�����.������ ��� ref
		�� ����������.����� ��� �����
		��� �����.��������=&�����������
		';
		$q_obj->������������������('�����������',$firm_ref);
		
		$sel = $q_obj->���������()->�������();
		$kassa_ref = NULL;
		if ($sel->���������()){
			$kassa_ref = $sel->ref;
		}
		
		if (is_null($kassa_ref)){
			$kassa_ob = $v8->�����������->�����->��������������();
			$kassa_ob->�������� = $firm_ref;
			$kassa_ob->������������ = '�������� �����';
			$kassa_ob->��������();
			$kassa_ref = $kassa_ob->������;
		}
		
		return $kassa_ref;
	}
	
	function get_client_dog($v8,$client_ref,$firm_ref,$attrs){			
		$q_obj = $v8->NewObject('������');
		$q_obj->����� ='������� ������ 1
		���.������ ��� ref
		�� ����������.�������������������� ��� ���
		��� ���.��������=&������������
			� ���.�����������=&�����������
			� ���.�����������=��������(������������.�������������������������.������������)
			� ���.���������������������=��������(������������.��������������������������������.����������������)
		';
		$q_obj->������������������('������������',$client_ref);
		$q_obj->������������������('�����������',$firm_ref);
		
		$sel = $q_obj->���������()->�������();
		$dog_ref = NULL;
		if ($sel->���������()){
			$dog_ref = $sel->ref;
		}
		
		if (is_null($dog_ref)){
			$dog_ref = create_client_dog($v8,$client_ref,$firm_ref,$attrs);
		}
		
		return $dog_ref;
	}
	
	function get_item_mu($v8,$item,$item_ref){
		$mu_id = $v8->NewObject('�����������������������',$item['measure_unit_ref']);
		$mu_ref = $v8->�����������->����������������������������->��������������($mu_id);
		$item_mu_ref = $v8->�����������->����������������->�������������������($mu_ref->������������,TRUE,0,$item_ref);
		if ($item_mu_ref->������()){
			//����� �������
			$k = floatval($item['measure_unit_k']);
			$k = ($k>0)? $k:1;
			$new_item_mu = $v8->�����������->����������������->��������������();
			$new_item_mu->�������� = $item_ref;
			$new_item_mu->������������ = $mu_ref->������������;
			$new_item_mu->����������������������� = $mu_ref;
			$new_item_mu->����������� = $k;
			$new_item_mu->��������();
			$item_mu_ref = $new_item_mu->������;
		}	
		return $item_mu_ref;
	}
	function get_item($v8,$item){
		$ITEM_GROUP_NAME = '���������';
		$group1_ref = $v8->�����������->������������->�������������������($ITEM_GROUP_NAME);
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
		
		$name = cyr_str_decode($item['product_name']);
		//.' '.$item['mes_length'].'x'.$item['mes_width'].'x'.$item['mes_height'];
		$item_ref = $v8->�����������->������������->�������������������($name,TRUE,$group2_ref);
		
		if ($item_ref->������()){				
			//����� ������������
			$new_item = $v8->�����������->������������->��������������();
			$new_item->������������ = $name;
			$new_item->������������������ = $name;
			$new_item->��������������� = $v8->�����������->����������������->�������������������('���������');
			$new_item->�������� = $group2_ref;
			
			//�������������� ������
			if (isset($item['product_group_ref'])){
				$pg_id = $v8->NewObject('�����������������������',$item['product_group_ref']);
				$pg_ref = $v8->�����������->��������������������->��������������($pg_id);			
				$new_item->�������������������� = $pg_ref;
				$new_item->�������������������������� = $pg_ref;
			}
			
			//������� ������� web
			$bmu_id = $v8->NewObject('�����������������������',$item['base_measure_unit_ref']);
			$bmu_ref = $v8->�����������->����������������������������->��������������($bmu_id);

			//������� ��������� web
			//$dmu_id = $v8->NewObject('�����������������������',$item['measure_unit_ref']);
			//$dmu_ref = $v8->�����������->����������������������������->��������������($dmu_id);
			//$k = floatval($item['measure_unit_k']);
			//$k = ($k>0)? $k:1;			
			
			//������� 1� = ������� ������� �� web
			$new_item->����������������������� = $bmu_ref;				
			$new_item->��������� = $v8->������������->���������->���18;				
			$new_item->��������();			
			
			//����� �������
			$new_item_mu = $v8->�����������->����������������->��������������();			
			$new_item_mu->�������� = $new_item->������;
			$new_item_mu->������������ = $bmu_ref->������������;
			$new_item_mu->����������������������� = $bmu_ref;
			$new_item_mu->����������� = 1;
			$new_item_mu->��������();
			
			$new_item->����������������������� = $new_item_mu->������;
			$new_item->����������������� = $new_item_mu->������;				
			$new_item->��������();
			
			$item_ref = $new_item->������;
		}
		return $item_ref;
	}
	
	function get_item_deliv($v8){
		return $v8->�����������->������������->�������������������('��������',TRUE);
	}

	function get_item_pack($v8){
		return $v8->�����������->������������->�������������������('��������',TRUE);
	}
	
	function get_svoistvo($v8,$svoistvo_type,$svoistvo_val){		
		$q_obj = $v8->NewObject('������');
		$q_obj->����� ='������� ������ 1
		���.������ ��� ref
		�� ����������.����������������������� ��� ���
		��� ���.��������=&�����������
			� ���.������������=&������������
		';
		$q_obj->������������������('�����������',$svoistvo_type);
		$q_obj->������������������('������������',$svoistvo_val);
		$sel = $q_obj->���������()->�������();
		if ($sel->���������()){
			$ref = $sel->ref;
		}
		else{
			//������� ����� ��������
			$obj = $v8->�����������->�����������������������->��������������();
			$obj->�������� = $svoistvo_type;
			$obj->������������ = $svoistvo_val;
			$obj->��������();
			$ref = $obj->������;
		}
		return $ref;
	}
	
	function sale($v8,$head,$items){		
		$COMMENT = get_doc_comment($head);
		
		$firm_id = $v8->NewObject('�����������������������',$head['firm_ref']);
		$warehouse_id = $v8->NewObject('�����������������������',$head['warehouse_ref']);
		$client_id = $v8->NewObject('�����������������������',$head['client_ref']);
		
		$firm_ref = $v8->�����������->�����������->��������������($firm_id);
		$client_ref = $v8->�����������->�����������->��������������($client_id);
		$warehouse_ref = $v8->�����������->������->��������������($warehouse_id);		
	
		$deliv_total = floatval($head['deliv_total']);
		$pack_total = floatval($head['pack_total']);
		
		check_client_buyer($v8,$client_ref);
		
		$doc = $v8->���������->����������������������->���������������();	
		$doc->����						= $head['date'];
		
		$doc->�����������						= $firm_ref;
		$doc->��������������������������� 		= TRUE;
		$doc->�����������������������			= TRUE;
		$doc->����������������������������		= TRUE;
		$doc->�����								= $warehouse_ref;
		$doc->������������						= TRUE;
		$doc->����������������					= TRUE;
		
		$doc->�������������				= cyr_str_decode($head['deliv_address']);
		$doc->���������������			= get_currency($v8);
		$doc->�����������������������	= 1;
		$doc->������������������		= 1;
		$doc->�����������				= $v8->������������->�����������������������������->���������������;
		$doc->�����������				= $v8->������������->�������������������->��������;
		$doc->�����������				= $COMMENT;
		
		//$doc->���������������� = �����������;
		//$doc->��������������� = ������������;		
		$attrs = array();
		$attrs['pay_debt_sum'] = 0;
		$attrs['pay_delay_days'] = 0;
		$attrs['pay_ban_on_debt_sum'] = FALSE;
		$attrs['pay_ban_on_debt_days'] = FALSE;			
		$doc->����������						= $client_ref;
		$doc->������������������				= get_client_dog($v8,$client_ref,$firm_ref,$attrs);
		
		$stavka = get_nds($v8);
		$nds_percent = get_nds_percent($v8,$stavka);
		$total=0;
		foreach($items as $item){
			//������������
			$item_ref = get_item($v8,$item);
			
			$line = $doc->������->��������();
			$line->����������������	= get_item_mu($v8,$item,$item_ref);
			$line->���������� 		= $item['quant'];
			$line->����������� 		= $line->����������������->�����������;
			$line->������������ 	= $item_ref;
			$line->����				= $item['price'];
			$line->�����			= $item['total'];
			$line->���������		= $stavka;
			$line->��������			= round(floatval($item['total'])*$nds_percent/(100+$nds_percent),2);
			
			$line->���������������������������� = $v8->������������->�����������������������������->��������;
			$line->�������������	= $v8->�����������->������������->�����������������������;
			$line->��������������	= $v8->�����������->������������->�����������������������������;
			$line->�����������		= $v8->�����������->������������->����������������;
			//$line->�������������������������� = $v8->������������->��������������������������->��������;
			
			$total+= $item['total'];
		}
	
		if ($deliv_total){
			$q = intval($head['deliv_vehicle_count']);
			$q = (!$q)? 1:$q;
		
			$item_ref = get_item_deliv($v8);
			$line = $doc->������->��������();			
			$line->���������� 		= $q;
			$line->����������		= $item_ref->������������������;
			$line->������������ 	= $item_ref;
			$line->����				= round($deliv_total/$q,2);
			$line->�����			= $deliv_total;
			$line->���������		= $stavka;
			$line->��������			= round($deliv_total*$nds_percent/(100+$nds_percent),2);
			
			$total+= $deliv_total;
		}

		if ($pack_total){
			$item_ref = get_item_pack($v8);
			$line = $doc->������->��������();
			$line->����������		= $item_ref->������������������;
			$line->���������� 		= 1;
			$line->������������ 	= $item_ref;
			$line->����				= $pack_total;
			$line->�����			= $pack_total;
			$line->���������		= $stavka;
			$line->��������			= round($pack_total*$nds_percent/(100+$nds_percent),2);
			
			$total+= $pack_total;
		}
		
		//����� ���������
		if ($head['user_ref']){
			$user_id = $v8->NewObject('�����������������������',$head['user_ref']);			
			$user_ref = $v8->�����������->������������->��������������($user_id);
			$doc->������������� = $user_ref;
			
			$empl_ref = $user_ref->�������;			
			$obr = get_ext_obr($v8);
			$user_order_str = $obr->�����������������������������������($empl_ref,'������');
			
			
			$doc->�������������� = $empl_ref;
			$doc->�������������� = $empl_ref;
			$doc->���������������� = $empl_ref;
			$doc->����������������������������� = $user_order_str;
			$doc->����������������������� = $user_order_str;
		}
		
		$doc->�������������� = $total;
		$doc->��������($v8->��������������������->����������);
		
		//���� �������
		$inv_id = '';
		$inv_num = '';		
		if ($head['pay_cash']!='t'){
			$doc_inv = $v8->���������->�������������������->���������������();
			$doc_inv->���������($doc->������);
			$doc_inv->��������($v8->��������������������->����������);	
			
			//���������� �� �������� �������� ����
			$vh_trailer_model_ref = NULL;
			$vh_trailer_plate_ref = NULL;
			$driver_ref = NULL;
			if ($head['vh_trailer_model']||$head['vh_trailer_plate']||$head['driver_ref']){
				$rec_set = $v8->����������������->�����������������������->�������������������();
			}
			
			if (isset($head['vh_trailer_model'])){
				$svoistvo_vh_trailer_model = $v8->�����������������������->����������������->�����������("00000000003");
				$rec = $rec_set->��������();
				$rec->������ = $doc->������;
				$rec->�������� = $svoistvo_vh_trailer_model;
				$rec->�������� = get_svoistvo($v8,$svoistvo_vh_trailer_model,$head['vh_trailer_model']);
				//$rec->��������();			
			}
			if (isset($head['vh_trailer_plate'])){
				$svoistvo_vh_trailer_plate = $v8->�����������������������->����������������->�����������("00000000009");
				$rec = $rec_set->��������();
				$rec->������ = $doc->������;
				$rec->�������� = $svoistvo_vh_trailer_plate;
				$rec->�������� = get_svoistvo($v8,$svoistvo_vh_trailer_model,$head['vh_trailer_plate']);
				//$rec->��������();						
			}
			if (isset($head['driver_ref'])){
				$driver_id = $v8->NewObject('�����������������������',$head['driver_ref']);
				$rec = $rec_set->��������();
				$rec->������ = $doc->������;
				$rec->�������� = $v8->�����������������������->����������������->�����������("00000000008");
				$rec->�������� = $v8->�����������->��������������->��������������($driver_id);
				//$rec->��������();									
			}
			if (isset($head['vh_trailer_model'])||isset($head['vh_trailer_plate'])||isset($head['driver_ref'])){
				$rec_set->��������();
			}
			$inv_id = $v8->String($doc_inv->������->�����������������������());
			$inv_num = cyr_str_encode($doc_inv->�����);
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
	function order($v8,$head,$items){		
		$COMMENT = get_doc_comment($head);
		
		$firm_id = $v8->NewObject('�����������������������',$head['firm_ref']);
		
		$warehouse_id = $v8->NewObject('�����������������������',$head['warehouse_ref']);
		$client_id = $v8->NewObject('�����������������������',$head['client_ref']);
		
		$firm_ref = $v8->�����������->�����������->��������������($firm_id);
		$client_ref = $v8->�����������->�����������->��������������($client_id);
		check_client_buyer($v8,$client_ref);
		
		$warehouse_ref = $v8->�����������->������->��������������($warehouse_id);
		
		if ($firm_ref->����������������������->������()){
			throw new Exception('�� ����� �������� ���������� ����!');
		}
	
		$deliv_total = floatval($head['deliv_total']);
		$pack_total = floatval($head['pack_total']);
		
		if (isset($head['ext_order_id'])){
			//����������� ���������
			$order_id = $v8->NewObject('�����������������������',$head['ext_order_id']);
			$order_ref = $v8->���������->����������������������->��������������($order_id);
			$doc = $order_ref->��������������();
			if ($doc->��������){
				$doc->�������� = FALSE;
			}
			if ($doc->������->����������()>0){
				$doc->������->��������();
			}			
			if ($doc->������->����������()>0){
				$doc->������->��������();
			}						
		}
		else{
			$doc = $v8->���������->����������������������->���������������();	
		}
		
		$doc->����						= $head['date'];
		
		$doc->�����������				= $firm_ref;
		$doc->������������				= TRUE;
		$doc->����������������			= TRUE;
		
		$doc->�������������				= cyr_str_decode($head['deliv_address']);
		$doc->���������������			= get_currency($v8);
		$doc->�����������������������	= 1;
		$doc->������������������		= 1;
		$doc->�����������				= $COMMENT;
		$doc->������������������		= $firm_ref->����������������������;
		$doc->�����						= $warehouse_ref;		
		
		//$doc->���������������� = �����������;
		//$doc->��������������� = ������������;		
		$attrs = array();
		$attrs['pay_debt_sum'] = 0;
		$attrs['pay_delay_days'] = 0;
		$attrs['pay_ban_on_debt_sum'] = FALSE;
		$attrs['pay_ban_on_debt_days'] = FALSE;			
		$doc->����������						= $client_ref;
		$doc->������������������				= get_client_dog($v8,$client_ref,$firm_ref,$attrs);
		
		$stavka = get_nds($v8);
		$nds_percent = get_nds_percent($v8,$stavka);
		$total = 0;
		foreach($items as $item){
			//������������
			$item_ref = get_item($v8,$item);
			
			$line = $doc->������->��������();
			$line->����������������	= get_item_mu($v8,$item,$item_ref);
			if ($line->����������������->������()){
				throw new Exception("1c server exception ����������������->������()");
			}
			$line->���������� 		= $item['quant'];
			$line->����������� 		= $line->����������������->�����������;
			$line->������������ 	= $item_ref;
			$line->����				= $item['price'];
			$line->�����			= $item['total'];
			$line->���������		= $stavka;
			$line->��������			= round(floatval($item['total'])*$nds_percent/(100+$nds_percent),2);
			
			$total+= $item['total'];
		}
	
		if ($deliv_total){
			$q = intval($head['deliv_vehicle_count']);
			$q = (!$q)? 1:$q;
			
			$item_ref = get_item_deliv($v8);
			
			$line = $doc->������->��������();
			$line->���������� 		= $q;
			$line->����������		= $item_ref->������������������;
			$line->������������ 	= $item_ref;
			$line->�����			= $deliv_total;
			$line->����				= round($deliv_total/$q,2);
			
			$line->���������		= $stavka;
			$line->��������			= round($deliv_total*$nds_percent/(100+$nds_percent),2);
		
			$total+= $deliv_total;
		}

		if ($pack_total){
			$item_ref = get_item_pack($v8);
			
			$line = $doc->������->��������();
			$line->���������� 		= 1;
			$line->����������		= $item_ref->������������������;
			$line->������������ 	= $item_ref;
			$line->����				= $pack_total;
			$line->�����			= $pack_total;			
			$line->���������		= $stavka;
			$line->��������			= round($pack_total*$nds_percent/(100+$nds_percent),2);
		
			$total+= $pack_total;
		}
		
		$doc->�������������� = $total;
		
		//����� ���������
		if ($head['user_ref']){
			$user_id = $v8->NewObject('�����������������������',$head['user_ref']);			
			$doc->������������� = $v8->�����������->������������->��������������($user_id);			
		}
		
		$doc->��������($v8->��������������������->������);
		
		return sprintf(
		'<orderRef>%s</orderRef>
		<orderNum>%s</orderNum>',
		$v8->String($doc->������->�����������������������()),
		cyr_str_encode($doc->�����)
		);
	}
	function get_clienton_on_inn($v8,$inn){
		$q_obj = $v8->NewObject('������');
		$q_obj->����� ='������� ������.������ ��� ref �� ����������.����������� ��� ������
		��� ������.���="'.$inn.'"';
		$sel = $q_obj->���������()->�������();
		if ($sel->���������()){
			return $sel->ref;
		}
	
	}
	function client($v8,$attrs){
		$obj = NULL;
		$client_ref = get_clienton_on_inn($v8,$attrs['inn']);
		if (is_null($client_ref)){
			$obj = $v8->�����������->�����������->��������������();
			$obj->������������					= stripslashes(cyr_str_decode($attrs['name']));
			$obj->������������������			= stripslashes(cyr_str_decode($attrs['name_full']));
			$obj->�����������					= '������ �� web';
			$obj->���������						= (strlen($attrs['inn'])==10)? $v8->������������->���������->������:$v8->������������->���������->�������;
			$obj->���							= $attrs['inn'];
			$obj->���������						= $attrs['okpo'];
			$obj->���							= $attrs['kpp'];
			$obj->����������					= TRUE;
			$obj->��������();
			
			$client_ref = $obj->������;
		}
		
		$write = FALSE;
		
		if ($client_ref->����������������������->������()){
			//����
			$acc = $v8->�����������->���������������->��������������();
			$acc->��������				= $client_ref;
			$acc->������������			= '�������� ����';
			$acc->����������			= $attrs['acc'];
			$acc->���������������������	= get_currency($v8);
			$bank_ref = $v8->�����������->�����->�����������($attrs['bank_code']);
			if ($bank_ref->������()){
				//��� ������ �����
				throw new Exception('���� ��� '.$attrs['bank_code'].' � 1� �� ������!');
			}
			$acc->���� = $bank_ref;		
			$acc->��������();
			
			if (is_null($obj)){
				$obj = $client_ref->��������������();
			}		
			$obj->���������������������� = $acc->������;
			$write = TRUE;			
		}
		
		if (isset($attrs['contract_firm_ext_id'])
		&& $client_ref->��������������������������->������()){
			//���� ������� �����������
			//�������
			$firm_id = $v8->NewObject('�����������������������',$attrs['contract_firm_ext_id']);
			$firm_ref = $v8->�����������->�����������->��������������($firm_id);
			
			$dog = create_client_dog($v8,$client_ref,$firm_ref,$attrs);
			if (is_null($obj)){
				$obj = $client_ref->��������������();
			}
			$obj->�������������������������� = $dog->������;
			$write = TRUE;			
		}
		
		if ($write){
			$obj->��������();
			$client_ref = $obj->������;
		}
		
		return $v8->String($client_ref->�����������������������());
	}
	function pko($v8,$head){
		$COMMENT = '#web';
		//$CLIENT_NAME = '���������� ����';
		
		foreach($head as $firm_ar){			
			$sum = floatval($firm_ar['total']);
			if (!$sum) continue;
			
			$firm_ref = $firm_ar['firm_ref'];
			$firm_id = $v8->NewObject('�����������������������',$firm_ref);
			$firm_ref = $v8->�����������->�����������->��������������($firm_id);
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
			
			//�������
			$attrs = array();
			$attrs['pay_debt_sum'] = 0;
			$attrs['pay_delay_days'] = 0;
			$attrs['pay_ban_on_debt_sum'] = FALSE;
			$attrs['pay_ban_on_debt_days'] = FALSE;			
			$dog_ref = get_client_dog($v8,$client_ref,$firm_ref,$attrs);
			
			$dds_ref = $v8->�����������->�����������������������������->�������������������('������� �� ������� ���������,�������, �����, �����, ����� � ���� ��������� �������');
			
			$doc = $v8->���������->����������������������->���������������();	
			$doc->����						= date('YmdHis');
			$doc->�����						= get_kassa($v8,$firm_ref);
			//$doc->�������������
			$doc->�����������				= $firm_ref;
			$doc->�����������				= $v8->������������->���������������->����������������;
			$doc->����������				= $client_ref;
			$doc->������������������		= $dog_ref;
			$doc->���������������			= get_currency($v8);
			$doc->��������������			= $sum;
			$doc->���������					= '��������� ����������';
			$doc->���������					= '';
			$doc->����������				= '';
			$doc->��������					= TRUE;
			$doc->������������������		= TRUE;
			$doc->�����������				= $COMMENT;
			$doc->����������������������������	= TRUE;
			$doc->���������������������������	= TRUE;
			$doc->�����������������������		= TRUE;
			$doc->������������������������������=$v8->�����������->������������->��������������������;
			$doc->����������1					= $client_ref;
			$doc->����������2					= $dog_ref;
			$doc->�����������������������������	= $dds_ref;
			$doc->���������						= $v8->������������->���������->���18;
			
			//������
			$line = $doc->������������������->��������();
			$line->������������������				= $dog_ref;
			$line->������������������				= 1;
			$line->������������						= $sum;
			$line->�����������������������			= 1;
			$line->�������������������				= $sum;
			$line->��������							= $v8->������������->���������->���18;
			$line->�����������������������������	= $dds_ref;
			$line->������������������������������	= $v8->�����������->������������->��������������������;
			$line->��������������������������		= $v8->�����������->������������->��������������������������;			
			
			//����� ���������
			if ($firm_ar['user_ref']){
				$user_id = $v8->NewObject('�����������������������',$firm_ar['user_ref']);			
				$doc->������������� = $v8->�����������->������������->��������������($user_id);			
			}
			
			$doc->����������� = '������ �����������: '.$firm_ar['numbers'].', ������:'.cyr_str_decode($firm_ar['client_descr']);
			$doc->��������($v8->��������������������->������);
		}
	}
?>
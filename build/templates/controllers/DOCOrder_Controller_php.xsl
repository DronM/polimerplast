<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'DOCOrder'"/>
<!-- -->

<xsl:output method="text" indent="yes"
			doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
			doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
			
<xsl:template match="/">
	<xsl:apply-templates select="metadata/controllers/controller[@id=$CONTROLLER_ID]"/>
</xsl:template>

<xsl:template match="controller"><![CDATA[<?php]]>
<xsl:call-template name="add_requirements"/>
require_once(FRAME_WORK_PATH.'basic_classes/ParamsSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelWhereSQL.php');

require_once('models/DOCOrderCustSurveyDialog_Model.php');
require_once('models/DOCOrderShipmentDialog_Model.php');
require_once('models/DOCOrderDivisDialog_Model.php');
require_once('functions/PPEmailSender.php');
require_once('functions/ExtProg.php');
require_once('common/OSRM.php');
require_once('common/decodePolylineToArray.php');
require_once('common/downloader.php');
require_once('common/PDFReport.php');

require_once('common/barcode.php');
require_once('common/barcodegen.1d-php5.v5.2.1/class/BCGFontFile.php');
require_once('common/barcodegen.1d-php5.v5.2.1/class/BCGColor.php');
require_once('common/barcodegen.1d-php5.v5.2.1/class/BCGDrawing.php');
//require_once('common/barcodegen.1d-php5.v5.2.1/class/BCGean13.barcode.php');
require_once('common/barcodegen.1d-php5.v5.2.1/class/BCGcodabar.barcode.php');

class <xsl:value-of select="@id"/>_Controller extends ControllerSQLDOC{
	public function __construct($dbLinkMaster=NULL){
		parent::__construct($dbLinkMaster);<xsl:apply-templates/>
	}	
	<xsl:call-template name="extra_methods"/>
}
<![CDATA[?>]]>
</xsl:template>

<xsl:template name="extra_methods">
	public function get_new_list($pm){
		$this->setListModelId('DOCOrderNewList_Model');
		parent::get_list($pm);
	}
	public function get_current_list($pm){
		$this->setListModelId('DOCOrderCurrentList_Model');
		parent::get_list($pm);	
	}	
	public function get_current_for_client_list($pm){
		$this->setListModelId('DOCOrderCurrentForClientList_Model');
		parent::get_list($pm);	
	}		
	public function get_current_for_production_list($pm){
		$model = new DOCOrderCurrentForProductionList_Model($this->getDbLink());
		$where = new ModelWhereSQL();
		$field = clone $model->getFieldById('warehouse_id');
		$field->setValue('('.$_SESSION['warehouse_id_list'].')');
		$where->addField($field,'IN',NULL,NULL);
		
		$order = $this->orderFromParams($pm,$model);
		
		$model->select(FALSE,$where,$order,
			NULL,NULL,NULL,NULL,
			FALSE,TRUE);
		//
		$this->addModel($model);
		
	}			
	public function get_closed_list($pm){
		$this->setListModelId('DOCOrderClosedList_Model');
		parent::get_list($pm);		
	}		
	public function insert($pm){
		$pm->setParamValue('user_id',$_SESSION['user_id']);
		if ($_SESSION['role_id']=='client'){
			$pm->setParamValue('client_user_id',$_SESSION['user_id']);
		}
		parent::insert($pm);		
	}	
	private function add_state($doc_id,$state){		
		$this->getDbLinkMaster()->query(sprintf(
		"INSERT INTO doc_orders_states
		(doc_orders_id,
			date_time,
			state,
			user_id)
		VALUES (
			%d,
			now()::timestamp without time zone,
			'%s'::order_states,
			%d)",
		$doc_id,
		$state,
		$_SESSION['user_id'])
		);
	}
	
	private function state_in_list($docId,$state_list){
		$ar = $this->getDbLink()->query_first(sprintf(
		"SELECT
			state IN (".$state_list.") AS check,
			get_order_states_descr(state) AS state_descr
		FROM doc_orders_states
		WHERE doc_orders_id=%d
		ORDER BY date_time DESC
		LIMIT 1",
		$docId)
		);
		return !(!is_array($ar)||count($ar)==0||$ar['check']=='f');
	}
	
	private function check_state($docId,$state_list){
		if (!$this->state_in_list($docId,$state_list)){
			throw new Exception('Заявка в неверном статусе!');
		}	
	}
	
	public function get_products_descr($pm){
		$link = $this->getDbLink();		
		$params = new ParamsSQL($pm,$link);
		$params->setValidated("doc_id",DT_INT);
		$this->addNewModel(
		sprintf("SELECT		
			products_descr(p,t.mes_length,t.mes_width,t.mes_height)
				AS product_descr,
			m.name AS measure_unit_descr,
			bm.name AS base_measure_unit_descr,
			t.quant_base_measure_unit AS base_quant,
			t.quant AS quant,
			t.pack_exists,
			t.pack_in_price,
			vhl.driver_descr,
			vhl.vl_wt AS vehicle_descr
		FROM doc_orders_t_products AS t
		LEFT JOIN products AS p ON t.product_id = p.id
		LEFT JOIN measure_units AS bm ON bm.id = p.base_measure_unit_id
		LEFT JOIN measure_units AS m ON m.id = t.measure_unit_id
		LEFT JOIN deliveries AS dlv ON dlv.doc_order_id = t.doc_id
		LEFT JOIN vehicles_list AS vhl ON vhl.id = dlv.vehicle_id
		WHERE doc_id=%d
		ORDER BY t.line_number",
		$params->getParamById('doc_id'))
		);
	}
	
	public function cancel($pm){		
		$params = new ParamsSQL($pm,$this->getDbLink());
		$params->addAll();
		$doc_id = $params->getParamById('doc_id');
		
		$this->check_state($doc_id,"'canceled_by_client','canceled_by_sales_manager','canceled','closed','unloading','on_way','shipped','loading','produced','producing'");
		$this->add_state(
			$doc_id,
			($_SESSION['role_id']=='client')? 'canceled_by_client':'canceled_by_sales_manager'
		);
	}
	public function pass_to_production($pm){		
		$params = new ParamsSQL($pm,$this->getDbLink());
		$params->addAll();

		$this->check_state(
			$params->getParamById('doc_id'),
			"'new','waiting_for_us','waiting_for_client','waiting_for_payment'"
			);
			
		$this->getDbLinkMaster()->query('BEGIN');
		try{			
			$this->add_state(
				$params->getDbVal('doc_id'),
				'producing'
			);
			
			//скорректируем дату отгрузки
			$ar = $this->getDbLinkMaster()->query_first(sprintf(
			"select * FROM deliv_date_calc(%d,now()::date) AS (new_date date,correct boolean)",
			$params->getDbVal('doc_id')
			));
			if (is_array($ar)&amp;&amp;count($ar)&amp;&amp;$ar['correct']=='f'){
				//обновление даты отгрузки
				$this->getDbLinkMaster()->query(sprintf(
				"UPDATE doc_orders SET delivery_plan_date = '%s'::date
				WHERE id=%d",
				$ar['new_date'],
				$params->getDbVal('doc_id')
				));
			}
			
			$this->getDbLinkMaster()->query('COMMIT');
		}
		catch(Exception $e){
			$this->getDbLinkMaster()->query('ROLLBACK');
			throw $e;
		}		
			
	}	
	public function cancel_last_state($pm){		
		$params = new ParamsSQL($pm,$this->getDbLink());
		$params->addAll();
		
		//проверка числа статусов
		$link = $this->getDbLink();
		$ar = $link->query_first(sprintf(
			"SELECT COUNT(*) AS cnt
			FROM doc_orders_states
			WHERE doc_orders_id=%d",
		$params->getParamById('doc_id'))
		);
	
		if (!is_array($ar)||!count($ar)){
			throw new Exception("У документа нет статусов!");
		}
	
		if ($ar['cnt']==1){
			throw new Exception("Статус документа не может быть отменен!");
		}
	
		$link = $this->getDbLinkMaster();
		$link->query(sprintf(
			"DELETE FROM doc_orders_states
			WHERE id=(SELECT id FROM doc_orders_states
				WHERE doc_orders_id=%d
				ORDER BY date_time DESC
				LIMIT 1
				)",
		$params->getParamById('doc_id'))
		);
	}	
	private function printDoc($docIdForDb){		
		$this->addNewModel(sprintf(
			"SELECT * FROM doc_orders_print_h
			WHERE id=%d",
			$docIdForDb),
			"head"
		);
		
		$this->addNewModel(sprintf(
			"SELECT * FROM doc_orders_print_products
			WHERE doc_id=%d",
			$docIdForDb),
			"products"
		);		
		
		//Отметка о печати если напечатал производство
		if ($_SESSION['role_id']=='production'){
			$this->getDbLinkMaster()->query(sprintf(
				"UPDATE doc_orders SET printed=true
				WHERE id=%d",
				$docIdForDb)
			);
		}	
	}
	public function get_print($pm){		
		$params = new ParamsSQL($pm,$this->getDbLink());
		$params->addAll();
		$this->printDoc($params->getParamById('doc_id'));
	}		
	public function get_print_check($pm){		
		$params = new ParamsSQL($pm,$this->getDbLink());
		$params->addAll();
		$param_doc_id = $params->getParamById('doc_id');
		
		$ar = $this->getDbLink()->query_first(sprintf(
			"SELECT
				h.*,
				d.date_time,
				d.total_weight,
				d.total_volume,
				d.total,
				get_date_str_rus(d.date_time::date) AS date_descr
			FROM doc_orders_print_h AS h
			LEFT JOIN doc_orders d ON d.id=h.id
			WHERE h.id=%d",
			$param_doc_id)
		);
		
		$this->addNewModel(sprintf(
			"SELECT * FROM doc_orders_print_products
			WHERE doc_id=%d",
			$param_doc_id),
			"products"
		);
		
		/*
		Номер документа в баркод всего 13 знаков
		*/
		//$barcode_descr = substr('000000000000',1,12-strlen($ar['number'])).$ar['number'];
		//$barcode_descr = $barcode_descr.EAN_check_sum($barcode_descr,13);
		$barcode_descr = 'A'.$ar['number'].'A';
		
		//**** Генерация баркода ****
		$colorFont = new BCGColor(0, 0, 0);
		$colorBack = new BCGColor(255, 255, 255);		
		
		//$code = new BCGean13(); // Or another class name from the manual
		$code = new BCGcodabar();
		
		$code->setScale(1); // Resolution
		$code->setThickness(30); // Thickness
		$code->setForegroundColor($colorFont); // Color of bars
		$code->setBackgroundColor($colorBack); // Color of spaces
		$code->setFont(0); // Font (or 0) $font
		$code->parse($barcode_descr); // Text
		$drawing = new BCGDrawing('', $colorBack);
		$drawing->setBarcode($code);
		$drawing->draw();
		ob_start();
		$drawing->finish(BCGDrawing::IMG_FORMAT_PNG);
		$contents = ob_get_contents();
		ob_end_clean();
		//**** Генерация баркода ****
		
		//всю шапку в модель		
		$fields = array();
		foreach($ar as $fid=>$fval){
			array_push($fields,new Field($fid,DT_STRING,array('value'=>$fval)));
		}
		
		array_push($fields,new Field('barcode_descr',DT_STRING,array('value'=>$ar['number'])));
		array_push($fields,new Field('barcode_img_mime',DT_STRING,array('value'=>'image/png')));
		array_push($fields,new Field('barcode_img',DT_STRING,array('value'=>base64_encode($contents))));
		
		$this->addModel(new ModelVars(
			array('id'=>'head',
				'values'=>$fields)
			)
		);
		
	}		
	
	public function set_printed($pm){		
		$params = new ParamsSQL($pm,$this->getDbLink());
		$params->addAll();
		$this->getDbLinkMaster()->query(sprintf(
			"UPDATE doc_orders SET printed=true
			WHERE id=%d",
			$params->getParamById('doc_id'))
		);
	}			
	public function get_print_cnt($pm){
		$print_states = "'produced','producing'";
		$this->addNewModel(
		"SELECT COUNT(*) AS cnt
		FROM doc_orders_print_h h
		WHERE (COALESCE(h.printed,FALSE)=FALSE)
			AND (
			SELECT st.state FROM doc_orders_states st
			WHERE st.doc_orders_id=h.id
			ORDER BY st.date_time DESC LIMIT 1
			) IN (".$print_states.")",
		"get_print_cnt");
	}
	public function get_print_all($pm){
		$link = $this->getDbLinkMaster();
		$link->query('BEGIN');
		try{
			$print_states = "'produced','producing'";
			$h_q = "SELECT * FROM doc_orders_print_h h
			WHERE (COALESCE(h.printed,FALSE)=FALSE)
				AND (
				SELECT st.state FROM doc_orders_states st
				WHERE st.doc_orders_id=h.id
				ORDER BY st.date_time DESC LIMIT 1
				) IN (".$print_states.")";
				
			$model = new ModelSQL($link,array('id'=>'head'));
			$model->query($h_q,TRUE);
			$this->addModel($model);			
			
			$q = "SELECT t.*
				FROM doc_orders_print_products t
				LEFT JOIN doc_orders AS h ON h.id=t.doc_id
				WHERE COALESCE(h.printed,FALSE)=FALSE
				AND
				(SELECT st.state FROM doc_orders_states st
				WHERE st.doc_orders_id=h.id
				ORDER BY st.date_time DESC LIMIT 1
				) IN (".$print_states.")";
			$model = new ModelSQL($link,array('id'=>'products'));
			$model->query($q,TRUE);
			$this->addModel($model);			
							
			//Отметка о печати если напечатал производство
			if ($_SESSION['role_id']=='production'){
				$link->query(
				"UPDATE doc_orders SET printed=TRUE
				WHERE id IN (SELECT h.id FROM (".$h_q.") AS h)"
				);
			}
			$link->query('COMMIT');
		}
		catch(Exception $e){
			$link->query('ROLLBACK');
			throw $e;
		}		
	}		
	public function pay_orders_list($pm){
		$model = new PayOrderList_Model($this->getDbLink());
		$where = $this->conditionFromParams($pm,$model);
		$fields = $this->fieldsFromParams($pm);
		$from = null; $count = null;
		$limit = $this->limitFromParams($pm,$from,$count);
		$calc_total = ($count>0);
		if ($from){
			$model->setListFrom($from);
		}
		if ($count){
			$model->setRowsPerPage($count);
		}
		$order = $this->orderFromParams($pm,$model);
		if (!$where){
			$where = new ModelWhereSQL();
		}
		$f = clone $model->getFieldById('client_id');
		$f->setValue($_SESSION['global_client_id']);
		$where->addField($f);
		$model->select(FALSE,
					$where,$order,$limit,$fields,
					NULL,NULL,
					TRUE,TRUE);
		$this->addModel($model);
	}
	public function fill_cust_surv($pm){
		$this->getDbLinkMaster()->query(sprintf(
		"SELECT doc_orders_fill_cust_survey(%d)",$_SESSION['LOGIN_ID']));
	}
	public function get_cust_survey($pm){
		$model = new DOCOrderCustSurveyDialog_Model($this->getDbLink());
		
		$where = new ModelWhereSQL();
		$f = clone $model->getFieldById('id');
		$f->setValue($pm->getParamValue('id'));
		$where->addField($f);
				
		$model->select(FALSE,
					$where,NULL,NULL,NULL,
					NULL,NULL,
					TRUE,TRUE);
		$this->addModel($model);		
	}
	public function get_divis($pm){
		$doc_id = $pm->getParamValue('id');
		
		$model = new DOCOrderDivisDialog_Model($this->getDbLink());
		
		$where = new ModelWhereSQL();
		$f = clone $model->getFieldById('main_doc_id');
		$f->setValue($doc_id);
		$where->addField($f);
				
		$model->select(FALSE,
					$where,NULL,NULL,NULL,
					NULL,NULL,
					TRUE,TRUE);
		$this->addModel($model);		
		
		$this->getDbLinkMaster()->query(sprintf(
		"SELECT doc_orders_before_open(%d,%d)",
		$_SESSION['LOGIN_ID'],$doc_id
		));
		$_SESSION['doc_order_id'] = $doc_id;
	}	
	public function get_shipment($pm){
		$model = new DOCOrderShipmentDialog_Model($this->getDbLink());
		
		$where = new ModelWhereSQL();
		$f = clone $model->getFieldById('id');
		$f->setValue($pm->getParamValue('id'));
		$where->addField($f);
				
		$model->select(FALSE,
					$where,NULL,NULL,NULL,
					NULL,NULL,
					TRUE,TRUE);
		$this->addModel($model);		
	}	
	public function set_ready($pm){	
		$params = new ParamsSQL($pm,$this->getDbLink());
		$params->addAll();
		$doc_id = $params->getParamById('doc_id');
		
		$this->check_state(
			$doc_id,
			"'producing'"
			);
		
		$link = $this->getDbLinkMaster();
		$link->query('BEGIN');
		try{			
			//Добавляем статус
			$this->add_state($doc_id,'produced');	
			
			//Копируем количество в отгруженное		
			$link->query(sprintf(
			"UPDATE doc_orders_t_products
			SET quant_confirmed_base_measure_unit=quant_base_measure_unit
			WHERE doc_id=%d",
			$doc_id));
			
			$ar = $link->query_first(sprintf(
				"SELECT (deliv_type='by_client') AS self_deliv
				FROM doc_orders
				WHERE id=%d",
			$doc_id
			));
			if (is_array($ar)&amp;&amp;count($ar)&amp;&amp;$ar['self_deliv']='t'){
				//SMS для снабженца по самовывозу
				$link->query(sprintf(
				"INSERT INTO sms_for_sending
				(tel,body,sms_type)
					(SELECT
						t.cel_phone,
						t.message,
						'client_on_produced'::sms_types
					FROM sms_client_on_produced t
					WHERE t.doc_order_id=%d
					)",$doc_id));

				//Email для снабженца по самовывозу
				PPEmailSender::addEMail(
					$link,
					sprintf("email_text_order_on_produced(%d)",$doc_id),
					NULL,
					'order_on_produced'
				);
			}
			$link->query('COMMIT');
		}
		catch(Exception $e){
			$link->query('ROLLBACK');
			throw $e;
		}		
	}
	public function set_cancel_cause($pm){	
		$params = new ParamsSQL($pm,$this->getDbLink());
		$params->addAll();
		$doc_id = $params->getParamById('doc_id');
		$link = $this->getDbLinkMaster();
		
		$link->query(sprintf("DELETE FROM doc_orders_cancel_causes
		WHERE doc_id=%d",$doc_id));
		
		$link->query_first(sprintf(
		"INSERT INTO doc_orders_cancel_causes
			(doc_id,cause)
			VALUES (%d,%s)",
		$doc_id,
		$params->getParamById('cause')
		));
		
		$this->add_state($doc_id,
			($_SESSION['role_id']=='client')? 'canceled_by_client':'canceled_by_sales_manager'
		);		
	}
	
	/* расчет количества по количеству в любой единице
	из любой единицы, если measure_unit_id_from=0
	то пересчет из базовой единицы продукции
	*/
	public function calc_quant($pm){
		$params = new ParamsSQL($pm,$this->getDbLink());
		$params->addAll();	
		
		$mu_from = $params->getParamById('measure_unit_id_from');
		$prod_id = $params->getParamById('product_id');
		if (!strlen($mu_from)||$mu_from=='0'){
			$ar = $this->getDbLink()->query_first(sprintf(
			"SELECT p.base_measure_unit_id AS id
			FROM products p WHERE p.id=%d",$prod_id)
			);
			if (is_array($ar)&amp;&amp;count($ar)){
				$mu_from = $ar['id'];
			}					
		}
		if ($mu_from=='0'){
			throw new Exception("Base measure unit not found!");
		}
		
		$ar = $this->getDbLink()->query_first(sprintf(
		"SELECT doc_order_calc_quant_in_mu(%d,%d,%d,%d,%d,%f,%d)
			AS quant",
			$prod_id,
			$params->getParamById('measure_unit_id'),
			$params->getParamById('mes_length'),
			$params->getParamById('mes_width'),
			$params->getParamById('mes_height'),			
			$params->getParamById('quant'),
			$mu_from
		));
		$quant = 0;
		if (is_array($ar)&amp;&amp;count($ar)){
			$quant = $ar['quant'];
		}		
		
		$this->addNewModel(sprintf(
		"SELECT %f AS quant",
		$quant		
		),"calc_quant");
		
		$this->product_measure_units_check(
			$params->getParamById('product_id'),
			$mu_from,
			$params->getParamById('mes_length'),
			$params->getParamById('mes_width'),
			$params->getParamById('mes_height'),		
			$params->getParamById('quant')
		);
		
	}
	
	private function product_measure_units_check(
			$product_id,
			$measure_unit_id,
			$mes_length,
			$mes_width,
			$mes_height,
			$quant
			){	
		$this->addNewModel(sprintf(
		"SELECT * FROM product_measure_units_check(%d,%d,%d,%d,%d,%f)",
			$product_id,
			$mes_length,
			$mes_width,
			$mes_height,
			$measure_unit_id,
			$quant		
		),"product_measure_units_check");	
	}

	public function calc_totals($pm){	
		if ($_SESSION['role_id']=='client'){
			//Установим клиента
			$pm->setParamValue('client_id',$_SESSION['global_client_id']);
		}
		
		$params = new ParamsSQL($pm,$this->getDbLink());
		$params->addAll();
		
		$this->product_measure_units_check(
			$params->getParamById('product_id'),
			$params->getParamById('measure_unit_id'),
			$params->getParamById('mes_length'),
			$params->getParamById('mes_width'),
			$params->getParamById('mes_height'),		
			$params->getParamById('quant')				
		);

		$this->addNewModel(
		sprintf("SELECT * FROM doc_order_totals(
			%d,%d,%d,%d,%d,%d,%f,%d,%s,%s,%s,%s,%f)
		AS (
			base_quant numeric,
			volume_m numeric,
			weight_t numeric,
			price numeric,
			total numeric,
			total_pack numeric)",
		$params->getParamById('warehouse_id'),
		$params->getParamById('client_id'),
		$params->getParamById('product_id'),
		$params->getParamById('mes_length'),
		$params->getParamById('mes_width'),
		$params->getParamById('mes_height'),
		$params->getParamById('quant'),
		$params->getParamById('measure_unit_id'),
		$params->getParamById('pack'),
		$params->getParamById('pack_in_price'),
		$params->getParamById('deliv_to_third_party'),
		$params->getParamById('price_edit'),
		$params->getParamById('price')
		));
	}
	public function calc_deliv_cost($pm){	
		$link = $this->getDbLink();
		$params = new ParamsSQL($pm,$link);
		$params->addAll();
		
		$include_route = ($params->getParamById('include_route')=='1')? 'TRUE':'FALSE';
		
		//Определим склад и категорию ТС
		$const = $link->query_first(sprintf(
		"SELECT
			%d AS deliv_cost_opt_id,
			(SELECT w.production_city_id
			FROM warehouses w
			WHERE w.id=%d) AS production_city_id",
		$params->getParamById('cost_opt_id'),
		$params->getParamById('warehouse_id')
		));
		if (!is_array($const)||!count($const)){
			throw new Exception("Ошибка в запросе.");
		}
		
		//Берем центр зон и если есть то кэш
		$ar = $link->query_first(sprintf(
		"SELECT * FROM doc_order_deliv_cache(%d,%d,%s,%d,%d)",
		$params->getParamById('warehouse_id'),
		$params->getParamById('client_destination_id'),		
		$include_route,
		$const['deliv_cost_opt_id'],
		$const['production_city_id']
		));
		
		/* выходные данные
		берем либо из кэша либо заново
		прокладываем маршрут
		*/
		$out_city_route='NULL';
		$out_city_route_distance=0;
		$out_city_cost=0;
		$out_country_route='NULL';
		$out_country_route_distance=0;
		$out_country_cost=0;
		
		if ($ar['city_route_distance']||$ar['country_route_distance']){
			//!!!cache data!!!
			$out_city_route = $ar['city_route'];
			$out_city_route_distance = $ar['city_route_distance'];
			$out_city_cost = $ar['city_cost'];
			$out_country_route = $ar['country_route'];
			$out_country_route_distance = $ar['country_route_distance'];
			$out_country_cost = $ar['country_cost'];		
		}
		else if (is_array($ar)&amp;&amp;count($ar)){
			if (!$ar['wh_near_road_lon']
			||!$ar['wh_near_road_lat']){
				throw new Exception('Не определена производственная зона!');
			}
			if (!$ar['dest_near_road_lon']
			||!$ar['dest_near_road_lat']){
				throw new Exception('Не определена зона клиента!');
			}
			
			$osrm = new OSRM(OSRM_PROTOCOLE,OSRM_HOST,OSRM_PORT);
				
			//Маршрут от склада до клиента
			$route = json_decode($osrm->getRoute(array(
				$ar['wh_near_road_lat'].','.$ar['wh_near_road_lon'],
				$ar['dest_near_road_lat'].','.$ar['dest_near_road_lon']
				),'json'));
			
			if ($route->status!=0){
				throw new Exception($route->status_message);
			}
			
			/* Собираем точки маршрута в линию*/
			$q_points = '';
			$points = decodePolylineToArray($route->route_geometry);
			foreach($points as $p){
				$q_points.=($q_points=='')? '':',';
				$q_points.=sprintf("ST_PointFromText('POINT(%s %s)',4326)",$p[1],$p[0]);
			}
			
			/* Рсакладываем маршрут на город/не город
			и берем тарифы
			*/
			$ar = $link->query_first(sprintf(
			"WITH
				line AS (
					SELECT ST_MakeLine(ARRAY[%s]) AS v
				),
				costs AS(
					SELECT
						t.deliv_cost_type,						
						t.cost
					FROM deliv_costs t
					WHERE t.production_city_id=%d
						AND t.deliv_cost_opt_id=%d
				)
			SELECT
				--city route
				replace(replace(ST_AsText(ST_Intersection((SELECT t.v FROM line t),pc.zone)),'LINESTRING(',''),')','')
				AS city_route,
				
				--Тариф city
				(SELECT t.cost
				FROM costs t
				WHERE t.deliv_cost_type='city'
				) AS city_cost,

				--country route
				replace(replace(ST_AsText(ST_Difference((SELECT t.v FROM line t),pc.zone)),'LINESTRING(',''),')','')
				AS country_route,
						
				--Тариф country
				(SELECT t.cost
				FROM costs t
				WHERE t.deliv_cost_type='country'
				) AS country_cost
				
			FROM warehouses AS w
			LEFT JOIN production_cities AS pc ON pc.id=w.production_city_id
			WHERE w.id=%d			
			",
			$q_points,
			$const['production_city_id'],
			$const['deliv_cost_opt_id'],			
			$params->getParamById('warehouse_id')
			));
			
			/*Берем маршрут от начала до конца города
			для расчета расстояния
			*/
			if ($ar['city_route']!='GEOMETRYCOLLECTION EMPTY'){
				$ar['city_route'] = str_replace('MULTI(','',$ar['city_route']);
				$ar['city_route'] = str_replace('(','',$ar['city_route']);
			
				$city_route_ar = explode(',',$ar['city_route']);
				$city_route_lonlat_from = explode(' ',$city_route_ar[0]);
				$city_route_lonlat_to = explode(' ',$city_route_ar[count($city_route_ar)-1]);
				$route = json_decode($osrm->getRoute(array(
					$city_route_lonlat_from[1].','.$city_route_lonlat_from[0],
					$city_route_lonlat_to[1].','.$city_route_lonlat_to[0]
					),'json'));			
				if ($route->status!=0){
					throw new Exception($route->status_message);
				}
				$out_city_route	= $ar['city_route'];
				$out_city_route_distance = $route->route_summary->total_distance;			
			}
			/*Берем маршрут от конца города до зоны клиента
			для расчета расстояния
			*/
			if ($ar['country_route']!='GEOMETRYCOLLECTION EMPTY'){
				$ar['country_route'] = str_replace('MULTI(','',$ar['country_route']);
				$ar['country_route'] = str_replace('(','',$ar['country_route']);
				$country_route_ar = explode(',',$ar['country_route']);
				$country_route_lonlat_from = explode(' ',$country_route_ar[0]);
				$country_route_lonlat_to = explode(' ',$country_route_ar[count($country_route_ar)-1]);
				$route = json_decode($osrm->getRoute(array(
					$country_route_lonlat_from[1].','.$country_route_lonlat_from[0],
					$country_route_lonlat_to[1].','.$country_route_lonlat_to[0]
					),'json'));			
				if ($route->status!=0){
					throw new Exception($route->status_message);
				}		
				$out_country_route = $ar['country_route'];
				$out_country_route_distance = $route->route_summary->total_distance;							
			}
			/*Cache
			Возможна коллизия: кто-то уже вставил
			такие-же данные в кэш!!!
			!!!РАБОТАЕТ ПРАВИЛО!!!
			*/
			$this->getDbLinkMaster()->query(sprintf(
			"INSERT INTO deliv_distance_cache
			(warehouse_id,client_destination_id,
			city_route,city_route_distance,
			country_route,country_route_distance)
			VALUES (%d,%d,
				%s,%d,
				%s,%d)
			",
			$params->getParamById('warehouse_id'),
			$params->getParamById('client_destination_id'),
			($out_city_route=='NULL')? $out_city_route:sprintf("St_GeomFromText('LINESTRING(%s)',4326)",$out_city_route),
			$out_city_route_distance,
			($out_country_route=='NULL')? $out_country_route:sprintf("St_GeomFromText('LINESTRING(%s)',4326)",$out_country_route),
			$out_country_route_distance
			));
			
			if ($include_route!='TRUE'){
				$out_city_route='';
				$out_country_route='';
			}
			$out_city_cost = $ar['city_cost'];
		}
		
		//Стоимость межгород за КМ
		$out_country_cost = $ar['country_cost']*round($out_country_route_distance/1000);
		
		$m = new Model(array('id'=>'calc_deliv_cost'));
		$m->addField(new Field('city_route',DT_STRING,array('value'=>$out_city_route)));
		$m->addField(new Field('city_route_distance',DT_INT,array('value'=>$out_city_route_distance)));
		$m->addField(new Field('city_cost',DT_FLOAT,array('value'=>$out_city_cost)));
		$m->addField(new Field('country_route',DT_STRING,array('value'=>$out_country_route)));
		$m->addField(new Field('country_route_distance',DT_INT,array('value'=>$out_country_route_distance)));
		$m->addField(new Field('country_cost',DT_FLOAT,array('value'=>$out_country_cost)));
		$m->addField(new Field('total_cost',DT_FLOAT,array('value'=>$out_country_cost+$out_city_cost)));
		$m->insert();
		$this->addModel($m);
	}
	public function get_object($pm){
		$link = $this->getDbLink();
		$par = new ParamsSQL($pm,$link);
		$par->setValidated('id');
	
		$this->addNewModel(sprintf(
		"SELECT
			h.field,			
			CASE
				WHEN h.field='client_id' THEN cl.name::text
				WHEN h.field='client_user_id' THEN cl_u.name::text
				WHEN h.field='user_id' THEN u.name::text
				WHEN h.field='firm_id' THEN f.name::text
				WHEN h.field='warehouse_id' THEN w.name::text
				WHEN h.field='deliv_period_id' THEN dvp.name::text
				WHEN h.field='deliv_type' THEN get_delivery_types_descr(h.old_val::delivery_types)::text
				WHEN h.field='deliv_destination_id' THEN dest.address::text
				WHEN h.field='deliv_vehicle_id' THEN v.plate::text
				WHEN h.field='delivery_plan_date' THEN date8_descr(h.old_val::date)
				ELSE h.old_val
			END AS old_val
			
		FROM doc_orders_head_history AS h
		LEFT JOIN clients AS cl ON cl.id=text_to_int(h.old_val,0) AND h.field='client_id'
		LEFT JOIN users AS cl_u ON cl_u.id=text_to_int(h.old_val,0) AND h.field='client_user_id'
		LEFT JOIN users AS u ON u.id=text_to_int(h.old_val,0) AND h.field='user_id'
		LEFT JOIN firms AS f ON f.id=text_to_int(h.old_val,0) AND h.field='firm_id'
		LEFT JOIN warehouses AS w ON w.id=text_to_int(h.old_val,0) AND h.field='warehouse_id'
		LEFT JOIN delivery_periods AS dvp ON dvp.id=text_to_int(h.old_val,0) AND h.field='deliv_period_id'
		LEFT JOIN client_destinations_list AS dest ON dest.id=text_to_int(h.old_val,0) AND h.field='deliv_destination_id'
		LEFT JOIN vehicles AS v ON v.id=text_to_int(h.old_val,0) AND h.field='deliv_vehicle_id'		
		WHERE h.doc_orders_states_id=
				(SELECT st.id
				FROM doc_orders_states st
				WHERE st.doc_orders_id=%d
				ORDER BY st.date_time DESC
				LIMIT 1)",
		$par->getParamById('id')
		),'head_history');
		/*
		$this->addNewModel(sprintf("
		SELECT
			product_id,
			oper,
			string_to_array(fields,',','') AS fileds,
			string_to_array(old_vals,',','') AS old_vals
		FROM doc_orders_products_history ph WHERE ph.doc_orders_states_id=(SELECT st.id
						FROM doc_orders_states st
						WHERE st.doc_orders_id=%d
						ORDER BY st.date_time DESC
						LIMIT 1)		
		",$par->getParamById('id')),'prod_history');
		*/
		parent::get_object($pm);	
	}
	
	public function recalc_product_prices($pm){
		if ($_SESSION['role_id']=='client'){
			//Установим клиента
			$pm->setParamValue('client_id',$_SESSION['global_client_id']);
		}	
		$params = new ParamsSQL($pm,$this->getDbLink());
		$params->addAll();
		
		$lmast = $this->getDbLinkMaster();
		$lmast->query(sprintf(
		"UPDATE doc_orders_t_tmp_products tmp
		SET
			quant_base_measure_unit = data.base_quant,
			volume = data.volume_m,
			weight = data.weight_t,
			price = data.price,
			total = data.total,
			total_pack = data.total_pack
		FROM 
			(SELECT *
			FROM doc_order_totals_all(%d,%d,%d,%s)
			) AS data		
		WHERE tmp.login_id=%d AND tmp.line_number = data.line_number",
		$params->getParamById('warehouse_id'),
		$params->getParamById('client_id'),
		$_SESSION['LOGIN_ID'],
		$params->getParamById('deliv_to_third_party'),
		$_SESSION['LOGIN_ID']
		));
		if ($pm->getParamValue('deliv_add_cost_to_product')=='true'){
			//Распределить пропорционально
			$deliv_cost = floatval($pm->getParamValue('deliv_cost'));
			if ($deliv_cost &gt; 0){
				$l = $this->getDbLink();
				$id = $l->query(sprintf(
				"SELECT
					line_number,
					quant,
					price,
					total,
					(SELECT
						MAX(line_number)
					FROM doc_orders_t_tmp_products
					WHERE login_id=%d) AS last_line,
					(SELECT
						SUM(total)
					FROM doc_orders_t_tmp_products
					WHERE login_id=%d) AS total_total
					
				FROM doc_orders_t_tmp_products
				WHERE login_id=%d",
				$_SESSION['LOGIN_ID'],
				$_SESSION['LOGIN_ID'],
				$_SESSION['LOGIN_ID']
				));
				$lmast->query("BEGIN");
				try{
					$deliv_cost_tot = 0;
					while ($ar = $l->fetch_array($id)){
						$line_cost = round($ar['total']/$ar['total_total'] * $deliv_cost,2);
						$deliv_cost_tot+=$line_cost;
						$total = $ar['total']+$line_cost;
						if ($ar['line_number']==$ar['last_line']
						&amp;&amp; $deliv_cost_tot!=$deliv_cost){
							//последняя строка
							$total = $total - $deliv_cost_tot + $deliv_cost;
						}						
						$price = round($total/$ar['quant'],2);
						$lmast->query(sprintf(
						"UPDATE doc_orders_t_tmp_products
						SET price=%f,total=%f
						WHERE login_id=%d AND line_number=%d
						",
						$price,$total,
						$_SESSION['LOGIN_ID'],$ar['line_number']
						));
					}
					$lmast->query("COMMIT");
				}
				catch (Exception $e){
					$lmast->query("ROLLBACK");
					throw $e;
				}			
			}			
		}
	}
	public function before_open($pm){
		$_SESSION['doc_order_id'] = $pm->getParamValue('doc_id');
		parent::before_open($pm);
	}
	
	public static function docDataForExt($link,$docId,&amp;$head,&amp;$items){
		$q_id = $link->query(sprintf(
		"SELECT
			t.*,
			(SELECT u.ext_id FROM users u
			WHERE u.id=%d
			) AS user_ref
		FROM doc_orders_data_for_ext t
		WHERE doc_id=%d",
		$_SESSION['user_id'],$docId));
		
		$head = NULL;
		$items = array();
		while ($ar = $link->fetch_array($q_id)){
			if (is_null($head)){
				$head = array(
					'date'=>date('YmdHis'),
					'firm_ref'=>$ar['firm_ref'],
					'user_ref'=>$ar['user_ref'],
					'client_ref'=>$ar['client_ref'],
					'warehouse_ref'=>$ar['warehouse_ref'],
					'deliv_total'=>$ar['deliv_total'],
					'pack_total'=>$ar['pack_total'],
					'deliv_address'=>$ar['deliv_address'],
					'driver_ref'=>$ar['driver_ref'],
					'vh_plate'=>$ar['vh_plate'],
					'vh_trailer_plate'=>$ar['vh_trailer_plate'],
					'vh_trailer_model'=>$ar['vh_trailer_model'],
					'ext_order_id'=>$ar['ext_order_id'],
					'client_comment'=>$ar['client_comment'],
					'sales_manager_comment'=>$ar['sales_manager_comment'],
					'pay_cash'=>$ar['pay_cash'],
					'deliv_vehicle_count'=>$ar['deliv_vehicle_count']
					);
			}
			array_push($items,array(
				'product_name'=>$ar['product_name'],
				'group_name'=>$ar['group_name'],
				'product_group_ref'=>$ar['product_group_ref'],
				'mes_length'=>$ar['mes_length'],
				'mes_width'=>$ar['mes_width'],
				'mes_height'=>$ar['mes_height'],
				'measure_unit_ref'=>$ar['measure_unit_ref'],
				'measure_unit_k'=>$ar['measure_unit_k'],
				'base_measure_unit_ref'=>$ar['base_measure_unit_ref'],					
				'quant'=>$ar['quant'],
				'price'=>$ar['price'],
				'total'=>$ar['total']
				));
		}
		$link->free_result($q_id);
	}
	public function set_closed($pm){
		$l = $this->getDbLink();//read-only
		$params = new ParamsSQL($pm,$l);
		$params->addAll();
		
		$this->add_state(
			$params->getParamById('doc_id'),
			'closed'
		);
	}
	public function update_paid($pm,$paid){
		$params = new ParamsSQL($pm,$this->getDbLink());
		$params->addAll();
		
		$ar = $this->getDbLink()->query_first(sprintf(
		"SELECT
			cl.pay_type,
			get_payment_types_descr(cl.pay_type) AS pay_type_descr
		FROM clients cl
		WHERE cl.id=(SELECT o.client_id
				FROM doc_orders o
				WHERE o.id=%d)",
		$params->getParamById('doc_id')
		));
		if (!is_array($ar)||!count($ar)){
			throw new Exception("Не нашли клиента!");
		}
		if ($ar['pay_type']!='cash'){
			throw new Exception(sprintf('Вид оплаты клиента: "%s"!',
				$ar['pay_type_descr']));
		}
		
		$this->getDbLinkMaster()->query(sprintf(
		"UPDATE doc_orders SET paid=%s
		WHERE id=%d",
		$paid,
		$params->getParamById('doc_id')
		));
	}
	public function set_paid($pm){
		$this->update_paid($pm,'TRUE');
	}
	public function set_not_paid($pm){
		$this->update_paid($pm,'FALSE');
	}
	
	public function set_shipped($pm){
		$l = $this->getDbLink();//read-only
		$params = new ParamsSQL($pm,$l);
		$params->addAll();
		
		$doc_id = $params->getParamById('doc_id');
		
		$this->check_state($doc_id,"'produced'");
		
		//проверка на запрет
		if ($_SESSION['client_ship_not_allowed']){
			throw new Exception("Отгрузка клиенту запрещена!");
		}
		
		$link = $this->getDbLinkMaster();
		$link->query('BEGIN');		
		try{
			//Отгрузка в БД
			$link->query(sprintf(
				"SELECT doc_orders_set_shipped(%d,%d)",
				$doc_id,
				$_SESSION['LOGIN_ID']
			));
			
			//ДАННЫЕ ДЛЯ 1С
			$head=NULL;
			$items=NULL;
			DOCOrder_Controller::docDataForExt(
				$link,$doc_id,$head,$items);				
			
			//Паспорт качества
			$sert_tmp_file = NULL;
			$ar = $link->query_first(sprintf(
			"SELECT
				cl.email_sert,
				cl.pay_type,
				h.deliv_type,
				u.email
			FROM doc_orders AS h
			LEFT JOIN clients cl ON cl.id=h.client_id
			LEFT JOIN users u ON u.id=h.client_user_id
			WHERE h.id=%d",$doc_id)
			);		
			$this->makePassport($link,$doc_id);
			if ($ar['email_sert']=='t'){
				$sert_tmp_file = $this->dump_passport_to_file($doc_id);
			}
			
			//по самовывозу статус меняем на закрыт!!!
			$this->add_state($doc_id,
				($ar['deliv_type']=='by_client')? 'shipped':'closed'
				);
			
			//SMS снабженцу
			$link->query(sprintf(
			"INSERT INTO sms_for_sending
			(tel,body,sms_type)
				(SELECT
					t.cel_phone,
					t.message,
					'client_on_deliv'::sms_types
				FROM sms_client_on_deliv t
				WHERE t.doc_order_id=%d
				)",
			$doc_id
			));
			
			//Выписка документов в 1с			
			$res = array();
			ExtProg::sale($head,$items,$res);
			$link->query(sprintf(
			"UPDATE doc_orders
			SET
				delivery_fact_date = now()::timestamp,
				ext_ship_id='%s',
				ext_ship_num='%s',
				ext_invoice_id='%s',
				ext_invoice_num='%s',
				ext_invoice_date_time='%s'
			WHERE id=%d",
			$res['naklRef'],
			$res['naklNum'],
			$res['invRef'],
			$res['invNum'],
			date('Y-m-d H:i:s'),
			$doc_id
			));
			
			if ($ar['pay_type']!='cash'){
				//документа на email с печатями
				$ttn_attrs = $l->query_first(sprintf(
					"SELECT * FROM doc_orders_ttn
					WHERE doc_id=%d",
				$doc_id
				));		
			
				$tmp_file = ExtProg::print_shipment(
						$ttn_attrs['ext_ship_id'],
						$ttn_attrs,
						$_SESSION['user_ext_id'],
						0
				);
				
				$_SESSION['ship_doc_'.$doc_id] = $tmp_file;
				
				$attch = array($tmp_file);
				if (!is_null($sert_tmp_file)){
					array_push($attch,$sert_tmp_file);
				}
				$mail_id = PPEmailSender::addEMail(
					$link,
					sprintf("email_text_shipment(%d)",$doc_id),
					$attch,
					'shipment'
				);
			}
			
			$link->query('COMMIT');
		}
		catch(Exception $e){
			$link->query('ROLLBACK');
			throw $e;
		}		
	}
	
	public function get_ship_docs($pm){
		$l = $this->getDbLink();//read-only
		$params = new ParamsSQL($pm,$l);
		$params->addAll();
		
		$doc_id = $params->getParamById('doc_id');
		if (isset($_SESSION['ship_doc_'.$doc_id])){
			$tmp_file = $_SESSION['ship_doc_'.$doc_id];
			ob_clean();
			downloadFile($tmp_file);
			unlink($tmp_file);
			unset($_SESSION['ship_doc_'.$doc_id]);
		}
	}
	public function print_ship_docs($pm){
		$l = $this->getDbLink();
		$params = new ParamsSQL($pm,$l);
		$params->setValidated('doc_id',DT_INT);
		$doc_id = $params->getParamById('doc_id');
		
		$ar = $l->query_first(sprintf(
			"SELECT * FROM doc_orders_ttn
			WHERE doc_id=%d",
		$doc_id
		));		
		
		if (!is_array($ar)||!count($ar)){
			throw new Exception("Накладная не найдена!");
		}
		if (!$ar['ext_ship_id']){
			throw new Exception("Накладная не выписана!");
		}
		$tmp_file = ExtProg::print_shipment($ar['ext_ship_id'],
				$ar,
				$_SESSION['user_ext_id'],
				0);
		ob_clean();
		downloadFile($tmp_file);
		unlink($tmp_file);
	}
	
	public static function getExtRef($link,$docId,$field){
		$ar = $link->query_first(sprintf(
		"SELECT %s FROM doc_orders WHERE id=%d",
		$field,$docId
		));
		if (!is_array($ar)||!count($ar)){
			throw new Exception("Документ не найден!");
		}
		return $ar[$field];
	}
	
	public function print_order($pm){
		$l = $this->getDbLink();
		$params = new ParamsSQL($pm,$l);
		$params->setValidated("doc_id",DT_INT);
		$ref = self::getExtRef($l,$params->getParamById('doc_id'),'ext_order_id');
		if (is_null($ref)){
			throw new Exception("Счет не выписан!");
		}
		$tmp_file = ExtProg::print_order($ref,$_SESSION['user_ext_id']);
		ob_clean();
		downloadFile($tmp_file,'application/pdf','inline;');
		unlink($tmp_file);
	}
	public function print_torg12($pm){
		$l = $this->getDbLink();
		$params = new ParamsSQL($pm,$l);
		$params->setValidated("doc_id",DT_INT);		
		$ref = self::getExtRef($l,$params->getParamById('doc_id'),'ext_ship_id');
		if (is_null($ref)){
			throw new Exception("Накладная не выписана!");
		}
		$tmp_file = ExtProg::print_torg12($ref,$_SESSION['user_ext_id']);
		ob_clean();
		downloadFile($tmp_file,'application/pdf','inline;');
		unlink($f);
	}
	public function print_invoice($pm){
		$l = $this->getDbLink();
		$params = new ParamsSQL($pm,$l);
		$params->setValidated("doc_id",DT_INT);
		$ref = self::getExtRef($l,$params->getParamById('doc_id'),'ext_invoice_id');
		if (is_null($ref)){
			throw new Exception("Счет-фактура не выписан!");
		}
		$tmp_file = ExtProg::print_invoice($ref,$_SESSION['user_ext_id']);
		ob_clean();
		downloadFile($tmp_file,'application/pdf','inline;');
		unlink($tmp_file);
	}
	public function print_upd($pm){
		$l = $this->getDbLink();
		$params = new ParamsSQL($pm,$l);
		$params->setValidated("doc_id",DT_INT);
		$ref = self::getExtRef($l,$params->getParamById('doc_id'),'ext_ship_id');
		if (is_null($ref)){
			throw new Exception("Накладная не выписана!");
		}
		$tmp_file = ExtProg::print_upd($ref,$_SESSION['user_ext_id']);
		ob_clean();
		downloadFile($tmp_file,'application/pdf','inline;');
		unlink($tmp_file);
	}
	public function print_ttn($pm){
		$l = $this->getDbLink();
		$params = new ParamsSQL($pm,$l);
		$params->setValidated('doc_id',DT_INT);
		$doc_id = $params->getParamById('doc_id');
		
		$ar = $l->query_first(sprintf(
			"SELECT * FROM doc_orders_ttn
			WHERE doc_id=%d",
		$doc_id
		));		
		
		if (!is_array($ar)||!count($ar)){
			throw new Exception("Накладная не найдена!");
		}
		if (!$ar['ext_ship_id']){
			throw new Exception("Накладная не выписана!");
		}
		$tmp_file = ExtProg::print_ttn($ar['ext_ship_id'],
				$ar,
				$_SESSION['user_ext_id'],
				0);
		ob_clean();
		downloadFile($tmp_file,'application/pdf','inline;');
		unlink($tmp_file);
	}
	
	private function dump_passport_to_file($docId){
		$ar = $this->getDbLink()->query_first(sprintf(
			"SELECT content
			FROM doc_orders_products_passports
			WHERE doc_order_id=%d",
			$docId
		));
		if (is_array($ar)&amp;&amp;count($ar)){
			$tmp_file = OUTPUT_PATH.uniqid().".pdf";
			file_put_contents(ABSOLUTE_PATH.$tmp_file,pg_unescape_bytea($ar['content']));
			return $tmp_file;		
		}
	}
	
	public function dowloadPassport($docId){
		ob_clean();
		$tmp_file = $this->dump_passport_to_file($docId);
		downloadFile($tmp_file);
		unlink($tmp_file);
	}
	
	public function print_passport($pm){
		$params = new ParamsSQL($pm,$this->getDbLink());
		$params->addAll();
		$docId = $params->getParamById('doc_id');
		
		$ar = $this->getDbLink()->query_first(sprintf(
			"SELECT 1
			FROM doc_orders_products_passports
			WHERE doc_order_id=%d",
		$docId));
		
		if (!is_array($ar)||!count($ar)){
			$this->makePassport($this->getDbLinkMaster(),
				$docId
			);
		}
		$this->dowloadPassport($params->getParamById('doc_id'));
	}
	
	/*
	Либо файл складывается в кэш и удаляется из temp
	либо возвращает имя файла
	и файл не удаляется из temp
	*/
	public function makePassport($link,$docId,$doCache=TRUE){		
		$ar_head = $link->query_first(sprintf(
		"SELECT
			f.id AS firm_id,
			f.name AS firm_descr,
			f.sert_header AS firm_sert_header,
			f.ext_id AS firm_ext_id,
			p.id AS product_id,
			p.name AS product_descr,
			p.sert_type_id,
			stp.xslt_pattern
		FROM doc_orders_t_products t
		LEFT JOIN doc_orders h ON h.id=t.doc_id
		LEFT JOIN products p ON p.id=t.product_id
		LEFT JOIN firms f ON f.id=h.firm_id
		LEFT JOIN sert_types stp ON stp.id=p.sert_type_id
		WHERE h.id=%d",
		$docId
		));
		if (!is_array($ar_head)||!count($ar_head)){
			throw new Exception("makePassport Не найден документ!");
		}
		
		$firm_data = $ar_head['firm_sert_header']; 		
		if (!strlen($firm_data)){
			$firm_data = ExtProg::firm_data($ar_head['firm_ext_id']);
			$link->query(sprintf(
			"UPDATE firms SET sert_header='%s'
			WHERE id=%d",
			$firm_data,$ar_head['firm_id']));
		}
		
		$q_attrs_id = $link->query(sprintf(
			"SELECT *
			FROM sert_types_attrs
			WHERE sert_type_id=%d",
		$ar_head['sert_type_id']
		));
		
		//header
		$xml = '&lt;?xml version="1.0" encoding="UTF-8"?>';
		
		//root node
		$xml.= '&lt;document>';
			//head data
			$xml.= '&lt;firm_data>'.$firm_data.'&lt;/firm_data>';
			$xml.= '&lt;product_descr>'.$ar_head['product_descr'].'&lt;/product_descr>';
			$xml.= '&lt;firm_descr>'.$ar_head['firm_descr'].'&lt;/firm_descr>';
			$xml.= '&lt;date_descr>'.date('d/m/y').'&lt;/date_descr>';
			
			//attr data
			$attrs = '';
			while ($ar = $link->fetch_array($q_attrs_id)){
				$attrs.=
					'&lt;attr>'.
						'&lt;attr_text>'.htmlspecialchars($ar['attr_text']).'&lt;/attr_text>'.
						'&lt;attr_val_norm>'.htmlspecialchars($ar['attr_val_norm']).'&lt;/attr_val_norm>'.
						'&lt;attr_val>'.$ar['attr_val'].'&lt;/attr_val>'.
					'&lt;/attr>';
			}
			$xml.= '&lt;attrs>'.$attrs.'&lt;/attrs>';
		$xml.= '&lt;/document>';
		
		$link->free_result($q_attrs_id);
		
		$xml_file = ABSOLUTE_PATH.OUTPUT_PATH.uniqid().".xml";
		file_put_contents($xml_file,$xml);
		
		$xslt_file = ABSOLUTE_PATH.'views/'.$ar_head['xslt_pattern'];
		if (!file_exists($xslt_file)){
			//throw new Exception('Шаблон не найден!');
			return;
		}
		
		$out_file = ABSOLUTE_PATH.OUTPUT_PATH.uniqid().".pdf";
		$stored_exc = NULL;
		try{
			PDFReport::createFromFile($xml_file,
							$xslt_file,$out_file
				);
			
			if ($doCache&amp;&amp;file_exists($out_file)){
				$link->query(sprintf(
				"DELETE FROM doc_orders_products_passports
				WHERE doc_order_id=%d",$docId));
				
				$link->query(sprintf(
				"INSERT INTO doc_orders_products_passports
				(doc_order_id,product_id,content)
				VALUES (%d,%d,'%s')",
				$docId,$ar_head['product_id'],pg_escape_bytea(file_get_contents($out_file))
				));
			}
		}
		catch (Exception $exc) {
			$stored_exc = $exc;
		}
		
		if (file_exists($xml_file)){
			unlink($xml_file);
		}
		if ($doCache&amp;&amp;file_exists($out_file)){
			unlink($out_file);
		}
		if ($stored_exc) {
			throw($stored_exc);
		}		
		if (!$doCache){
			return $out_file;
		}
	}
	public function get_pop_warehouse($pm){
		$params = new ParamsSQL($pm,$this->getDbLink());
		$params->addAll();
		$this->addNewModel(sprintf(
			"SELECT
				o.warehouse_id,
				wh.name AS warehouse_descr,
				COUNT(*) AS cnt	
			FROM doc_orders AS o
			LEFT JOIN warehouses As wh ON wh.id=o.warehouse_id
			WHERE o.firm_id=%d
			GROUP BY o.warehouse_id,wh.name
			ORDER BY cnt DESC LIMIT 1",
		$params->getParamById('firm_id')
		),'get_pop_warehouse');
	}
	
	public function get_children($pm){
		$params = new ParamsSQL($pm,$this->getDbLink());
		$params->addAll();
		$this->addNewModel(sprintf(
			"SELECT
				d.child_doc_id AS id,
				o.number AS number
			FROM doc_orders_links AS d
			LEFT JOIN doc_orders AS o ON d.child_doc_id=o.id
			WHERE main_doc_id=%d",
		$params->getParamById('doc_id')
		),'get_children');		
	}
	public function get_cancel_cause($pm){
		$params = new ParamsSQL($pm,$this->getDbLink());
		$params->addAll();
		$this->addNewModel(sprintf(
			"SELECT cause
			FROM doc_orders_cancel_causes
			WHERE doc_id=%d",
		$params->getParamById('doc_id')
		),'get_cancel_cause');		
	}
	public function paid_to_acc($pm){
		$lmast = $this->getDbLinkMaster();
		$lmast->query("BEGIN");
		try{
			$q_id = $lmast->query(
			"WITH u AS (SELECT users.ext_id
				FROM users
				WHERE users.id=".$_SESSION['user_id']."
				)
			SELECT 
				string_agg(o.id::text,',') AS order_ids,
				string_agg(o.number::text,',') AS order_numbers,
				f.id AS firm_id,
				f.ext_id AS firm_ref,
				cl.id AS client_id,
				cl.ext_id AS client_ref,
				cl.name AS client_descr,
				
				SUM(
					COALESCE(o.total,0)+
					CASE
					WHEN o.deliv_type='by_supplier'::delivery_types THEN
						COALESCE(o.deliv_total,0)
					ELSE 0
					END
				) AS total,
				
				(SELECT u.ext_id FROM u) AS user_ref
				
			FROM doc_orders AS o
			LEFT JOIN firms AS f ON f.id=o.firm_id
			LEFT JOIN clients AS cl ON cl.id=o.client_id
			WHERE o.paid=TRUE AND o.acc_pko=FALSE
			GROUP BY f.id,f.ext_id,cl.id,cl.ext_id,cl.name,user_ref"
			);
			
			$firm_client_ar = array();
			$ids = '';
			$numbers = '';
			
			while ($ar = $lmast->fetch_array($q_id)){
				$ids.=(($ids=='')? '':',').$ar['order_ids'];
				$numbers.=(($numbers=='')? '':',').$ar['order_numbers'];
				
				array_push($firm_client_ar,
					array(
						'total'=>$ar['total'],
						'numbers'=>$ar['order_numbers'],
						'user_ref'=>$ar['user_ref'],
						'firm_ref'=>$ar['firm_ref'],
						'client_ref'=>$ar['client_ref'],
						'client_descr'=>$ar['client_descr']
					)
				);				
			}
			
			if (strlen($ids)){
				//1c
				ExtProg::paid_to_acc($firm_client_ar);
				
				$lmast->query(sprintf("UPDATE doc_orders
				SET acc_pko=TRUE
				WHERE id IN (%s)",$ids));
				
				$res_to_client = 'Сформирован ПКО по следующим заявкам: '.$numbers;
			}
			else{
				$res_to_client = 'Нет заявок для формирования ПКО!';
			}
			$lmast->query("COMMIT");
		}
		catch (Exception $e){
			$lmast->query("ROLLBACK");
			throw $e;
		}			
		//возврат
		$this->addNewModel(
			sprintf("SELECT '%s' AS mes",$res_to_client),
			'paid_to_acc'
		);		
	}
	public function divide($pm){
		$params = new ParamsSQL($pm,$this->getDbLink());
		$params->addAll();
		
		$this->getDbLinkMaster()->query(sprintf(
		"SELECT doc_orders_divide(%s,%d,%s,%s,%d,%d,%d,%f,%s)",
		$_SESSION['LOGIN_ID'],
		$params->getParamById('main_doc_id'),
		$params->getParamById('delivery_plan_date'),
		$params->getParamById('sales_manager_comment'),
		$params->getParamById('deliv_period_id'),
		$params->getParamById('deliv_vehicle_count'),
		$params->getParamById('deliv_cost_opt_id'),
		$params->getParamById('deliv_total'),
		$params->getParamById('deliv_total_edit')
		));		
	}	
	private function ext_doc_exists($docId,$field){
		$ar = $this->getDbLink()->query_first(sprintf(
		"SELECT %s IS NOT NULL AS exists
		FROM doc_orders
		WHERE id=%d",
		$field,
		$docId
		));
		return (is_array($ar)&amp;&amp;count($ar)&amp;&amp;$ar['exists']=='t');
	}

	public function ext_ship_exists($pm){
		$p = new ParamsSQL($pm,$this->getDbLink());
		$p->addAll();
		if (!$this->ext_doc_exists($p->getParamById('doc_id'),'ext_ship_id')){
			throw new Exception('Документ реализации не выписан!');
		}
	}
	public function ext_invoice_exists($pm){
		$p = new ParamsSQL($pm,$this->getDbLink());
		$p->addAll();
		if (!$this->ext_doc_exists($p->getParamById('doc_id'),'ext_invoice_id')){
			throw new Exception('Документ счет-фактура не выписан!');
		}
	}
	public function ext_order_exists($pm){
		$p = new ParamsSQL($pm,$this->getDbLink());
		$p->addAll();
		if (!$this->ext_doc_exists($p->getParamById('doc_id'),'ext_order_id')){
			throw new Exception('Документ счет не выписан!');
		}
	}
	
</xsl:template>

</xsl:stylesheet>
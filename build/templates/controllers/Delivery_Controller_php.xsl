<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'Delivery'"/>
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
require_once(FRAME_WORK_PATH.'basic_classes/CondParamsSQL.php');

class <xsl:value-of select="@id"/>_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL){
		parent::__construct($dbLinkMaster);<xsl:apply-templates/>
	}	
	<xsl:call-template name="extra_methods"/>
}
<![CDATA[?>]]>
</xsl:template>

<xsl:template name="extra_methods">
	public function unassigned_orders_list($pm){
		if ($_SESSION['role_id']=='client'){
			throw new Exception("Forbidden!");
		}
		
		$q_cond = '';
		if ($pm->getParamValue('all_orders')=='0'){
			$cond = new CondParamsSQL($pm,$this->getDbLink());
			$d_from = $cond->getValForDb('date','ge',DT_DATETIME);
			$d_to = $cond->getValForDb('date','le',DT_DATETIME);
			$q_cond = sprintf(
			"WHERE delivery_plan_date BETWEEN %s AND %s",
				$d_from,$d_to);
		}
				
		$this->addNewModel(
		"SELECT * FROM deliv_unassigned_orders_list ".$q_cond,
		'unassigned_orders_list');
	}
	public function assigned_orders_list($pm){
		if ($_SESSION['role_id']=='client'){
			$client_id = $_SESSION['client_id'];
		}
		else{
			$client_id = 0;
		}
	
		//periods
		$this->addNewModel(
		"SELECT
			id,
			h_from,h_to,
			h_from::text||'-'||h_to::text AS name
		FROM delivery_hours
		ORDER BY h_from",
		'periods'
		);
		//orders
		$cond = new CondParamsSQL($pm,$this->getDbLink());
		$this->addNewModel(sprintf(
		"SELECT * FROM deliv_assigned_orders_list(%s,%d)",
		$cond->getValForDb('date','le',DT_DATE),$client_id),
		'assigned_orders_list'
		);
	}	
	private function veh_employed($vehId){
		$ar = $this->getDbLink()->query_first(sprintf(
		"SELECT employed FROM vehicles
		WHERE id=%d",$vehId));
		if (!is_array($ar)||!count($ar)){
			throw new Exception("ТС не найдено!");
		}
		return ($ar['employed']=='t');
	}
	public function add_extra_vehicle($pm){
		$p = new ParamsSQL($pm,$this->getDbLink());
		$p->addAll();
		$vehicle_id = $p->getParamById('vehicle_id');
		
		if ($this->veh_employed($vehicle_id)){
			$this->getDbLinkMaster()->query(sprintf(
			"DELETE FROM delivery_deleted_vehicles
			WHERE vehicle_id=%d AND date=%s",
				$vehicle_id,
				$p->getParamById('date')
				)
			);		
		}
		else{
			$this->getDbLinkMaster()->query(sprintf(
			"INSERT INTO delivery_extra_vehicles
			(vehicle_id,date) VALUES(%d,%s)",
				$vehicle_id,
				$p->getParamById('date')
				)
			);
		}
	}	
	public function delete_extra_vehicle($pm){
		$p = new ParamsSQL($pm,$this->getDbLink());
		$p->addAll();
		
		$vehicle_id = $p->getParamById('vehicle_id');
		
		if ($this->veh_employed($vehicle_id)){
			$ar = $this->getDbLink()->query_first(sprintf(
			"SELECT 1 FROM delivery_deleted_vehicles
			WHERE vehicle_id=%d AND date=%s",
				$vehicle_id,
				$p->getParamById('date')
				));
			if (!is_array($ar)||!count($ar)){
				$this->getDbLinkMaster()->query(sprintf(
				"INSERT INTO delivery_deleted_vehicles
				(vehicle_id,date) VALUES(%d,%s)",
					$vehicle_id,
					$p->getParamById('date')
					)
				);					
			}
		}
		else{
			$this->getDbLinkMaster()->query(sprintf(
			"DELETE FROM delivery_extra_vehicles
			WHERE vehicle_id=%d AND date=%s",
				$vehicle_id,
				$p->getParamById('date')
				)
			);	
		}
	}	
	public function current_position_client($pm){
		$p = new ParamsSQL($pm,$this->getDbLink());
		$p->addAll();
	
		$this->addNewModel(sprintf(
		"SELECT
			id,
			plate,
			model,
			vol,
			load_weight_t,
			tr_data[1] AS period,
			tr_data[2] AS period_str,
			tr_data[3] AS lon_str,
			tr_data[4] AS lat_str,
			tr_data[5] AS speed,
			tr_data[6] ns,
			tr_data[7] ew,
			tr_data[8] recieved_dt,
			tr_data[9] AS recieved_dt_str,
			tr_data[10] odometer,
			tr_data[11] AS engine_on_str,
			tr_data[12] voltage,
			tr_data[13] AS heading_str,
			tr_data[14] heading,
			tr_data[15] lon,
			tr_data[16] lat
		FROM deliv_current_pos_client(%d,now()::date)",
			$_SESSION['client_id']			
		),'current_position_all');			
		//$p->getParamById('date')
	}			
	public function current_position_all($pm){
		$this->addNewModel(
		"SELECT
			id,
			plate,
			model,
			vol,
			load_weight_t,
			tr_data[1] AS period,
			tr_data[2] AS period_str,
			tr_data[3] AS lon_str,
			tr_data[4] AS lat_str,
			tr_data[5] AS speed,
			tr_data[6] ns,
			tr_data[7] ew,
			tr_data[8] recieved_dt,
			tr_data[9] AS recieved_dt_str,
			tr_data[10] odometer,
			tr_data[11] AS engine_on_str,
			tr_data[12] voltage,
			tr_data[13] AS heading_str,
			tr_data[14] heading,
			tr_data[15] lon,
			tr_data[16] lat
		FROM deliv_current_pos_all",
		'current_position_all');			
	}			
	
	public function extra_veh_select_list($pm){
		/* все НЕ постоянные и не добавленные на сегодня + 
		все постоянные удаленные на сегодня
		*/
		$p = new ParamsSQL($pm,$this->getDbLink());
		$p->addAll();
		$this->addNewModel(sprintf(
		"(SELECT *
		FROM vehicles_list AS v
		WHERE 
			(v.employed IS NULL OR v.employed=FALSE)
			AND
			v.id NOT IN (
			SELECT ext.vehicle_id FROM delivery_extra_vehicles AS ext
			WHERE ext.date=%s
			))
		UNION ALL

		(SELECT *
		FROM vehicles_list AS v
		WHERE 
			v.employed
			AND
			v.id IN (
			SELECT ext.vehicle_id FROM delivery_deleted_vehicles AS ext
			WHERE ext.date=%s
			))		
		",
			$p->getParamById('date'),
			$p->getParamById('date')
			),
			'extra_veh_select_list'
		);		
	}
	
	public function get_order_descr($pm){
		$p = new ParamsSQL($pm,$this->getDbLink());
		$p->addAll();
	
		$this->addNewModel(sprintf(
		"SELECT
			o.id,
			o.number,
			cl.name AS client_descr,
			pct.name||', '||w.name AS warehouse_descr,
			d.address AS client_dest_descr,
			o.product_str,
			o.total_volume,
			o.total_weight
		FROM doc_orders AS o
		LEFT JOIN clients AS cl ON cl.id=o.client_id
		LEFT JOIN warehouses AS w ON w.id=o.warehouse_id
		LEFT JOIN production_cities AS pct ON pct.id=w.production_city_id
		LEFT JOIN client_destinations_list AS d ON d.id=o.deliv_destination_id
		WHERE o.id=%d",
		$p->getParamById('doc_id')
		),'get_order_descr');
	}
	public function assign_order_to_vehicle($pm){
		$p = new ParamsSQL($pm,$this->getDbLink());
		$p->addAll();
	
		/*SMS принимающему об изменении времени
		создадим список с существующими интервалами
		doc_ordr_id
		period_id
		если что то поменяется - отправить SMS
		*/
		$link = $this->getDbLink();
		$q_id = $link->query(sprintf(
		"SELECT
			t.doc_order_id,
			t.delivery_hour_id
		FROM deliveries t
		WHERE t.deliv_date=%s",
		$p->getParamById('date')
		));
		
		//SQL для проверки
		$q_ch = '';
		$i = 0;
		$docs = array();
		while ($ar=$link->fetch_array($q_id)){
			$i++;
			$q_ch.= ($q_ch=='')? '':',';
			$q_ch.= sprintf("(SELECT TRUE
			FROM deliveries tmp
			WHERE tmp.doc_order_id=%d
				AND tmp.delivery_hour_id=%d
				AND tmp.deliv_date=%s) AS doc_%d",
			$ar['doc_order_id'],
			$ar['delivery_hour_id'],
			$p->getParamById('date'),
			$ar['doc_order_id']
			);
			$docs[$ar['doc_order_id']] = $ar['delivery_hour_id'];
		}
		
		
		$this->getDbLinkMaster()->query(sprintf(
		"SELECT deliv_assign_order_to_vehicle(%d,%d,%d,%s::date)",
		$p->getParamById('order_id'),
		$p->getParamById('vehicle_id'),
		$p->getParamById('hour_id'),
		$p->getParamById('date')
		));
		
		//проверка изменений
		$docs_s = '';
		if (strlen($q_ch)){
			$ar = $link->query_first("SELECT ".$q_ch);
			foreach($docs as $doc_id=>$h_id){
				if ($ar['doc_'.$doc_id]!='t'){
					//время поменялось
					$docs_s.=($docs_s=='')? '':',';
					$docs_s.=$doc_id;
				}
			}
		}
		if (strlen($docs_s)){
			$q_id = $link->query(
			"INSERT INTO sms_for_sending
			(tel,body,sms_type)
				(SELECT
					t.cel_phone,
					t.message,
					'client_change_time'::sms_types
				FROM sms_client_change_time t
				WHERE t.doc_order_id IN (".$docs_s.")
				)"
			);
		}
	}
	public function remove_order($pm){
		$p = new ParamsSQL($pm,$this->getDbLink());
		$p->addAll();
	
		$this->getDbLinkMaster()->query(sprintf(
		"DELETE FROM deliveries
		WHERE doc_order_id=%d",
		$p->getParamById('order_id')
		));
	}
	public function assigned_orders_for_client($pm){
		$client_id = $_SESSION['client_id'];
	
		//orders
		$cond = new CondParamsSQL($pm,$this->getDbLink());
		$this->addNewModel(sprintf(
		"SELECT * FROM deliv_assigned_orders_for_client t
		WHERE t.deliv_date BETWEEN %s AND %s
		AND t.client_id=%d",
		$cond->getValForDb('date','ge',DT_DATE),
		$cond->getValForDb('date','le',DT_DATE),
		$client_id),
		'assigned_orders_for_client'
		);
	}	
	
</xsl:template>

</xsl:stylesheet>
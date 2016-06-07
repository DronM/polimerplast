<?php

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLFloat.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTime.php');

class DOCOrderNewList_Model extends ModelSQL{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		$this->setDbName("public");
		
		$this->setTableName("doc_orders_new_list");
		
		$f_id=new FieldSQlInt($this->getDbLink(),$this->getDbName(),$this->getTableName()
		,"id"
		,array(
		
			'primaryKey'=>TRUE,
			'id'=>"id"
				
		
		));
		$this->addField($f_id);

		$f_number=new FieldSQlString($this->getDbLink(),$this->getDbName(),$this->getTableName()
		,"number"
		,array(
		
			'id'=>"number"
				
		
		));
		$this->addField($f_number);

		$f_date_time=new FieldSQlDateTime($this->getDbLink(),$this->getDbName(),$this->getTableName()
		,"date_time"
		,array(
		
			'id'=>"date_time"
				
		
		));
		$this->addField($f_date_time);

		$f_date_time_descr=new FieldSQlString($this->getDbLink(),$this->getDbName(),$this->getTableName()
		,"date_time_descr"
		,array(
		
			'id'=>"date_time_descr"
				
		
		));
		$this->addField($f_date_time_descr);

		$f_client_id=new FieldSQlInt($this->getDbLink(),$this->getDbName(),$this->getTableName()
		,"client_id"
		,array(
		
			'id'=>"client_id"
				
		
		));
		$this->addField($f_client_id);

		$f_client_descr=new FieldSQlString($this->getDbLink(),$this->getDbName(),$this->getTableName()
		,"client_descr"
		,array(
		
			'id'=>"client_descr"
				
		
		));
		$this->addField($f_client_descr);

		$f_product_plan_date=new FieldSQlDateTime($this->getDbLink(),$this->getDbName(),$this->getTableName()
		,"product_plan_date"
		,array(
		
			'id'=>"product_plan_date"
				
		
		));
		$this->addField($f_product_plan_date);

		$f_product_plan_date_descr=new FieldSQlString($this->getDbLink(),$this->getDbName(),$this->getTableName()
		,"product_plan_date_descr"
		,array(
		
			'id'=>"product_plan_date_descr"
				
		
		));
		$this->addField($f_product_plan_date_descr);

		$f_address_descr=new FieldSQlString($this->getDbLink(),$this->getDbName(),$this->getTableName()
		,"address_descr"
		,array(
		
			'id'=>"address_descr"
				
		
		));
		$this->addField($f_address_descr);

		$f_warehouse_id=new FieldSQlInt($this->getDbLink(),$this->getDbName(),$this->getTableName()
		,"warehouse_id"
		,array(
		
			'id'=>"warehouse_id"
				
		
		));
		$this->addField($f_warehouse_id);

		$f_warehouse_descr=new FieldSQlString($this->getDbLink(),$this->getDbName(),$this->getTableName()
		,"warehouse_descr"
		,array(
		
			'id'=>"warehouse_descr"
				
		
		));
		$this->addField($f_warehouse_descr);

		$f_products_descr=new FieldSQlString($this->getDbLink(),$this->getDbName(),$this->getTableName()
		,"products_descr"
		,array(
		
			'id'=>"products_descr"
				
		
		));
		$this->addField($f_products_descr);

		$f_product_ids=new FieldSQlString($this->getDbLink(),$this->getDbName(),$this->getTableName()
		,"product_ids"
		,array(
		
			'id'=>"product_ids"
				
		
		));
		$this->addField($f_product_ids);

		$f_total=new FieldSQlFloat($this->getDbLink(),$this->getDbName(),$this->getTableName()
		,"total"
		,array(
		
			'id'=>"total"
				
		
		));
		$this->addField($f_total);

		$f_total_descr=new FieldSQlString($this->getDbLink(),$this->getDbName(),$this->getTableName()
		,"total_descr"
		,array(
		
			'id'=>"total_descr"
				
		
		));
		$this->addField($f_total_descr);

		$f_total_quant=new FieldSQlFloat($this->getDbLink(),$this->getDbName(),$this->getTableName()
		,"total_quant"
		,array(
		
			'id'=>"total_quant"
				
		
		));
		$this->addField($f_total_quant);

		$f_state=new FieldSQlString($this->getDbLink(),$this->getDbName(),$this->getTableName()
		,"state"
		,array(
		
			'id'=>"state"
				
		
		));
		$this->addField($f_state);

		$f_state_descr=new FieldSQlString($this->getDbLink(),$this->getDbName(),$this->getTableName()
		,"state_descr"
		,array(
		
			'id'=>"state_descr"
				
		
		));
		$this->addField($f_state_descr);

		
		
		
	}

}
?>

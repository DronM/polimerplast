<?php

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');

class ClientActivityList_Model extends ModelSQL{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		$this->setDbName("public");
		
		$this->setTableName("client_activities_list");
		
		$f_id=new FieldSQlInt($this->getDbLink(),$this->getDbName(),$this->getTableName()
		,"id"
		,array(
		
			'primaryKey'=>TRUE,
			'alias'=>"Код"
		,
			'id'=>"id"
				
		
		));
		$this->addField($f_id);

		$f_name=new FieldSQlString($this->getDbLink(),$this->getDbName(),$this->getTableName()
		,"name"
		,array(
		
			'alias'=>"Наименование"
		,
			'length'=>50,
			'id'=>"name"
				
		
		));
		$this->addField($f_name);

		$f_match_1c=new FieldSQlString($this->getDbLink(),$this->getDbName(),$this->getTableName()
		,"match_1c"
		,array(
		
			'alias'=>"Соответствие 1с"
		,
			'id'=>"match_1c"
				
		
		));
		$this->addField($f_match_1c);

		
		
		
	}

}
?>
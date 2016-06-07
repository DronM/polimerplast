<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'Constant'"/>
<!-- -->

<xsl:output method="text" indent="yes"
			doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
			doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
			
<xsl:template match="/">
	<xsl:apply-templates select="metadata/controllers/controller[@id=$CONTROLLER_ID]"/>
</xsl:template>

<xsl:template match="controller"><![CDATA[<?php]]>
<xsl:call-template name="add_requirements"/>
require_once(FRAME_WORK_PATH.'basic_classes/ModelSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQL.php');
class <xsl:value-of select="@id"/>_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL){
		parent::__construct($dbLinkMaster);<xsl:apply-templates/>
	}
	public function get_values(){
		$link = $this->getDbLink();
		$model = new ModelSQL($link,array('id'=>'ConstantList_Model'));
		$model->addField(new FieldSQL($link,null,null,'id',DT_STRING));
		$model->addField(new FieldSQL($link,null,null,'val',DT_STRING));	
		
		$pm = $this->getPublicMethod('get_values');
		$id_list = $pm->getParamValue('id_list');
		$q = '';
		if (isset($id_list)){
			$ids = explode(',',$id_list);
			foreach($ids as $id) {
				if ($q!=''){
					$q.=' UNION ALL ';
				}			
				$q.=sprintf("SELECT
				'%s' AS id,val::text
				FROM const_%s",
				$id,$id);
			}
		}
		$model->setSelectQueryText($q);
		$model->select(false,null,null,
			null,null,null,null,null,TRUE);
		//
		$this->addModel($model);					
	}
	public function set_value($pm){
		$link = $this->getDbLinkMaster();
		$link->query(sprintf(
		"SELECT const_%s_set_val('%s')",
		$pm->getParamValue('id'),$pm->getParamValue('val')));
	}
}
<![CDATA[?>]]>
</xsl:template>

</xsl:stylesheet>
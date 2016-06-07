/* Copyright (c) 2012 
	Andrey Mikhalevich, Katren ltd.
*/
/*	
	Description
*/
/** Requirements
 * @requires common/functions.js
 * @requires core/ControllerDb.js
*/
//ф
/* constructor */

function Report_Controller(servConnector){
	options = {};
	Report_Controller.superclass.constructor.call(this,"Report_Controller",servConnector,options);	
	
	//methods
	this.add_production_load();
	this.add_client_balance();
	this.add_sales();
	
}
extend(Report_Controller,ControllerDb);

			Report_Controller.prototype.add_production_load = function(){
	var pm = this.addMethodById('production_load');
	
				
		pm.addParam(new FieldString("cond_fields"));
	
				
		pm.addParam(new FieldString("cond_vals"));
	
				
		pm.addParam(new FieldString("cond_sgns"));
	
				
		pm.addParam(new FieldString("cond_ic"));
	
				
		pm.addParam(new FieldString("templ"));
	
				
		pm.addParam(new FieldString("field_sep"));
	
			
}

			Report_Controller.prototype.add_client_balance = function(){
	var pm = this.addMethodById('client_balance');
	
				
		pm.addParam(new FieldDate("date_from"));
	
				
		pm.addParam(new FieldDate("date_to"));
	
				
		pm.addParam(new FieldInt("firm_id"));
	
			
}
			
			Report_Controller.prototype.add_sales = function(){
	var pm = this.addMethodById('sales');
	
				
		pm.addParam(new FieldString("cond_fields"));
	
				
		pm.addParam(new FieldString("cond_vals"));
	
				
		pm.addParam(new FieldString("cond_sgns"));
	
				
		pm.addParam(new FieldString("cond_ic"));
	
				
		pm.addParam(new FieldString("templ"));
	
				
		pm.addParam(new FieldString("groups"));
	
				
		pm.addParam(new FieldString("agg_fields"));
	
				
		pm.addParam(new FieldString("agg_types"));
	
				
		pm.addParam(new FieldString("field_sep"));
	
			
}
									
		
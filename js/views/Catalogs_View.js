/* Copyright (c) 2012 
	Andrey Mikhalevich, Katren ltd.
*/
/*	
	Description
*/
//ф
/** Requirements
 * @requires controls/ViewList.js
*/

/* constructor */
function Catalogs_View(id,options){
	options = options || {};
	//options.title = "Справочники";
	Catalogs_View.superclass.constructor.call(this,
		id,options);
	
	this.m_winObj = options.winObj;
	this.addItem({"caption":"Фирмы","viewClassId":FirmList_View,"id":"FirmList_View"});	
	this.addItem({"caption":"Города отгрузки","viewClassId":ProductionCityList_View,"id":"ProductionCityList_View"});
	this.addItem({"caption":"Склады","viewClassId":WarehouseList_View,"id":"WarehouseList_View"});	
	
	this.addItem({"caption":"Прайсы","viewClassId":ClientPriceListList_View,"id":"ClientPriceListList_View"});
	
	this.addItem({"caption":"Опрос клиентов","viewClassId":CustomerSurveyQuestionList_View,"id":"CustomerSurveyQuestionList_View"});
	this.addItem({"caption":"Виды деятельности","viewClassId":ClientActivity_View,"id":"ClientActivity_View"});
			
	this.addItem({"caption":"Единицы измерения","viewClassId":MeasureUnitList_View,"id":"MeasureUnitList_View"});
	this.addItem({"caption":"Производственные стадии","viewClassId":ProductionStateList_View,"id":"ProductionStateList_View"});
	this.addItem({"caption":"Продукция","viewClassId":ProductList_View,"id":"ProductList_View"});
	this.addItem({"caption":"Номенкл.группы","viewClassId":ProductGroupList_View,"id":"ProductGroupList_View"});
	this.addItem({"caption":"Сертификаты","viewClassId":SertType_View,"id":"SertType_View"});
	
	this.addItem({"caption":"Сроки задолженности","viewClassId":ClientDebtPeriodList_View,"id":"DebtPeriodList_View"});
	
	this.addItem({"caption":"Периоды отгрузки","viewClassId":DeliveryPeriodList_View,"id":"DeliveryPeriodList_View"});
	this.addItem({"caption":"Часы доставки","viewClassId":DeliveryHour_View,"id":"DeliveryHour_View"});
	this.addItem({"caption":"Перевозчики","viewClassId":CarrierList_View,"id":"CarrierList_View"});	
	this.addItem({"caption":"Водители","viewClassId":DriverList_View,"id":"DriverList_View"});
	this.addItem({"caption":"Автомобили","viewClassId":VehicleList_View,"id":"VehicleList_View"});
	this.addItem({"caption":"Ценовые категории","viewClassId":DelivCostOptList_View,"id":"DelivCostOptList_View"});
	this.addItem({"caption":"Тарифы по доставке","viewClassId":DelivCostList_View,"id":"DelivCostList_View"});
	
	this.addItem({"caption":"Серверы трекеров","viewClassId":TrackerServerList_View,"id":"TrackerServerList_View"});
	this.addItem({"caption":"Трекеры","viewClassId":TrackerList_View,"id":"TrackerList_View"});
	
	this.addItem({"caption":"Шаблоны SMS","viewClassId":SMSTemplateList_View,"id":"SMSTemplateList_View"});
	this.addItem({"caption":"Шаблоны Email","viewClassId":EmailTemplateList_View,"id":"EmailTemplateList_View"});
	this.addItem({"caption":"SMS сообщения","viewClassId":SMSForSendingList_View,"id":"SMSForSendingList_View"});
	this.addItem({"caption":"EMail сообщения","viewClassId":MailForSendingList_View,"id":"MailForSendingList_View"});
	
	this.addItem({"caption":"Праздники","viewClassId":Holiday_View,"id":"Holiday_View"});
	
	this.addItem({"caption":"Константы","viewClassId":ConstantList_View,"id":"ConstantList_View"});
	
	this.addItem({"caption":"Долги клиентов","viewClassId":ClientDebt_View,"id":"ClientDebt_View"});
}
extend(Catalogs_View,ViewMenu);
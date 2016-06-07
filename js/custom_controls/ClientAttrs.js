/* Copyright (c) 2012 
	Andrey Mikhalevich, Katren ltd.
*/
/*	
	Description
*/
//ф
/** Requirements 
 * @requires common/DOMHandler.js
*/
/* constructor */
function ClientAttrs(attrs){
	attrs["name"] = new EditString("Client_name",
		{"labelCaption":"Наименование:","name":"name",
		"buttonClear":false,
		"tableLayout":false,
		"attrs":{"maxlength":150,"size":70,"required":"required"}}
	);
	attrs["inn"] = new EditNum("Client_inn",
		{"labelCaption":"ИНН:","name":"inn","buttonSelect":false,
		"buttonClear":false,
		"tableLayout":false,
		"minLength":10,
		"attrs":{"maxlength":12,"size":20,"required":"required"}}
	);
	attrs["kpp"] = new EditNum("Client_kpp",
		{"labelCaption":"КПП:","name":"kpp","buttonSelect":false,
		"buttonClear":false,
		"tableLayout":false,
		"attrs":{"maxlength":10,"size":20}}
	);	
	attrs["addr_reg"] = new EditString("Client_addr_reg",
		{"labelCaption":"Адрес юридический:","name":"addr_reg",
		"buttonClear":false,
		"tableLayout":false,
		"attrs":{"size":70,"required":"required"}}),
		
	attrs["addr_mail_same_as_reg"] = new EditCheckBox("Client_addr_mail_same_as_reg",
		{"labelCaption":"Фактический адрес совпадает с юридическим",
		"name":"addr_mail_same_as_reg",
		"labelAlign":"left",
		"tableLayout":false,
		"attrs":{"checked":"checked"}});
		
	attrs["addr_mail"] = new EditString("Client_addr_mail",
		{"labelCaption":"Адрес фактический:","name":"addr_mail",
		"buttonClear":false,
		"tableLayout":false,
		"attrs":{"size":70,"disabled":"disabled"}});
		
	attrs["telephones"] = new EditString("Client_telephones",
		{"labelCaption":"Телефоны:","name":"telephones",
		"buttonClear":false,
		"tableLayout":false,
		"attrs":{"size":20,"required":"required"}});
		
	attrs["acc"] = new EditNum("Client_acc",
		{"labelCaption":"Расчетный счет:","name":"acc",
		"buttonClear":false,
		"tableLayout":false,
		"fixedLength":true,
		"attrs":{"maxlength":20,"size":20,"required":"required"}});
		
	attrs["bank_name"] = new EditString("Client_bank_name",
		{"labelCaption":"Банк:","name":"bank_name",
		"buttonClear":false,
		"tableLayout":false,
		"attrs":{"size":70,"required":"required"}}
	);
	attrs["bank_code"] = new EditNum("Client_bank_code",
		{"labelCaption":"БИК:","name":"bank_code",
		"buttonClear":false,
		"tableLayout":false,
		"fixedLength":true,
		"attrs":{"maxlength":9,"size":20,"required":"required"}}
	);
	
	attrs["bank_acc"] = new EditNum("Client_bank_acc",
		{"labelCaption":"Корр. счет:","name":"bank_acc",
		"buttonClear":false,
		"tableLayout":false,
		"fixedLength":true,
		"attrs":{"maxlength":20,"size":20,"required":"required"}});
		
	attrs["okpo"] = new EditNum("Client_okpo",
		{"labelCaption":"ОКПО:","name":"okpo","buttonSelect":false,
		"buttonClear":false,
		"tableLayout":false,
		"attrs":{"maxlength":20,"size":20}});
		
	attrs["ogrn"] = new EditNum("Client_ogrn",
		{"labelCaption":"ОГРН:","name":"ogrn","buttonSelect":false,
		"buttonClear":false,
		"tableLayout":false,
		"attrs":{"maxlength":15,"size":20}});
}
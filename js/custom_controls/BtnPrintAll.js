/* Copyright (c) 2014	Andrey Mikhalevich, Katren ltd.*//*		Description*///ф/** Requirements*//* constructor */function BtnPrintAll(options){		var id = uuid();	options.caption = "Печать всех нерасп.";	options.attrs={"title":"распечатать все нераспечатанные заявки"};	options.onClick = function(){		var keys = options.grid.getSelectedNodeKeys();		if (keys){			var contr = new DOCOrder_Controller(new ServConnector(HOST_NAME));			contr.run("get_print_cnt",{				"async":true,				"func":function(resp){										var m = resp.getModelById("get_print_cnt",true);					if (m.getNextRow()&&m.getFieldValue("cnt")=="0"){						WindowMessage.show({							type:WindowMessage.TP_NOTE,							text:"Все документы распечатаны!"						});					}					else{						contr.run("get_print_all",{							"async":true,							"xml":false,							"params":{"v":"DOCOrder"},							"func":function(resp){													WindowPrint.show({"content":resp,"print":true});							},							"cont":this,							"errControl":options.grid.getErrorControl()						});											}				},				"cont":this,				"errControl":options.grid.getErrorControl()			});					}	};			BtnPrintAll.superclass.constructor.call(this,		id,options);}extend(BtnPrintAll,Button);
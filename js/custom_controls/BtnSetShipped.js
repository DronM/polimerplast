/* Copyright (c) 2014	Andrey Mikhalevich, Katren ltd.*//*		Description*///ф/** Requirements*//* constructor */function BtnSetShipped(options){		var id = uuid();	options.caption = "Отгружена";	options.attrs={"title":"перевести заявку в статус 'отгружена'"};		this.m_grid = options.grid;	this.m_keys = options.keys;		var self = this;	options.onClick=function(){		if (self.m_grid){						self.m_keys = self.m_grid.getSelectedNodeKeys();			console.log("key from grid ="+self.m_keys['id'])		}		else{			console.log("key NOT from grid ="+self.m_keys['id'])		}				if (self.m_keys){			//Только из статуса готова			self.m_extForm = new WIN_CLASS({				"title":"Отгрузка",				"width":"900",				"height":"500"			});			self.m_extForm.open();			self.m_extCtrl=new DOCOrderShipmentDialog_View("DOCOrderShipmentDialog_View",				{"winObj":self.m_extForm,				"readController":new DOCOrder_Controller(new ServConnector(HOST_NAME)),				"onClose":function(){					self.m_extForm.close();					delete self.m_extForm;					if (options.grid)options.grid.onRefresh();				}				});							for (var key_id in self.m_keys){				self.m_extCtrl.setReadIdValue(key_id,self.m_keys[key_id]);					}										self.m_extCtrl.readData(true);			self.m_extCtrl.m_beforeOpen(new DOCOrder_Controller(new ServConnector(HOST_NAME)),false);						self.m_extCtrl.toDOM(self.m_extForm.getContentParent());			self.m_extForm.setFocus();		}	};		BtnSetShipped.superclass.constructor.call(this,		id,options);}extend(BtnSetShipped,Button);
/* Copyright (c) 2012 	Andrey Mikhalevich, Katren ltd.*//*		Description*///ф/** Requirements * @requires controls/ViewDialog.js*//* constructor */function ClientDestinationDialog_View(id,options){	options = options || {};	options.readMethodId = options.readMethodId || this.DEF_READ_METH_ID;	options.writeController = options.writeController || options.readController;		options.mapHeight = "500";	options.mapWidth = getViewportWidth()-10;		options.noOk = true;	options.noCancel = true;		ClientDestinationDialog_View.superclass.constructor.call(this,		id,options);			var model_r="ClientDestinationDialog_Model";	var model_w = "ClientDestination_Model";	var self = this;		//ID	this.addDataControl(new Edit(id+"_id",		{"visible":false,"name":"id"}),		{"modelId":model_r,		"valueFieldId":"id",		"keyFieldIds":null},		{"valueFieldId":"id","keyFieldIds":null,		"modelId":model_w}	);	//ClientId	this.addDataControl(new Edit(id+"_client_id",		{"visible":false,"name":"client_id",			"value":options.clientId}),		{"modelId":model_r,		"valueFieldId":"client_id",		"keyFieldIds":null},		{"valueFieldId":"client_id","keyFieldIds":null,		"modelId":model_w}	);		this.m_ctrlZoneCenterStr = new Edit(id+"_zone_center_str",	{"visible":false,"name":"zone_center_str"});	this.addDataControl(this.m_ctrlZoneCenterStr,		{"modelId":model_r,		"valueFieldId":"zone_center_str",		"keyFieldIds":null},		{"valueFieldId":"zone_center","keyFieldIds":null}	);			var cont = new ControlContainer(this.m_id+"_addr_panel","div",{"className":"form-group"});	this.m_kladrView = new Kladr2_View(this.m_id+"_Kladr_View",		{"winObj":this.m_winObj});	cont.addElement(this.m_kladrView);		//найти по адресу	this.m_btnFind = new ButtonCtrl(id+"btnFind",		{"caption":"Найти объект на карте",		"onClick":function(){			self.getAddressGPS();		},		"attrs":{			"title":"Найти объект на карте по адресу"}	});	cont.addElement(this.m_btnFind);		this.addControl(cont);		this.bindControl(this.m_kladrView.m_ctrlRegion,		{"modelId":model_r,		"valueFieldId":"region",		"keyFieldIds":["region_code"]},		{"modelId":model_w,		"valueFieldId":"region",		"keyFieldIds":["region_code"]});		this.bindControl(this.m_kladrView.m_ctrlRaion,		{"modelId":model_r,		"valueFieldId":"raion",		"keyFieldIds":["raion_code"]},		{"modelId":model_w,		"valueFieldId":"raion",		"keyFieldIds":["raion_code"]});		this.bindControl(this.m_kladrView.m_ctrlNasPunkt,		{"modelId":model_r,		"valueFieldId":"naspunkt",		"keyFieldIds":["naspunkt_code"]},		{"modelId":model_w,		"valueFieldId":"naspunkt",		"keyFieldIds":["naspunkt_code"]});		this.bindControl(this.m_kladrView.m_ctrlGorod,		{"modelId":model_r,		"valueFieldId":"gorod",		"keyFieldIds":["gorod_code"]},		{"modelId":model_w,		"valueFieldId":"gorod",		"keyFieldIds":["gorod_code"]});		this.bindControl(this.m_kladrView.m_ctrlUlitza,		{"modelId":model_r,		"valueFieldId":"ulitza",		"keyFieldIds":["ulitza_code"]},		{"modelId":model_w,		"valueFieldId":"ulitza",		"keyFieldIds":["ulitza_code"]});				this.bindControl(this.m_kladrView.m_ctrlDom,		{"modelId":model_r,"valueFieldId":"dom"},		{"modelId":model_w,"valueFieldId":"dom"});		this.bindControl(this.m_kladrView.m_ctrlKorpus,		{"modelId":model_r,"valueFieldId":"korpus"},		{"modelId":model_w,"valueFieldId":"korpus"});		this.bindControl(this.m_kladrView.m_ctrlKvartira,		{"modelId":model_r,"valueFieldId":"kvartira"},		{"modelId":model_w,"valueFieldId":"kvartira"});	this.addControl(new ButtonCmd(uuid(),{		"caption":"Записать",		"onClick":function(){			self.onClickOk();		},		"attrs":{			"title":"записать,закрыть"}		})	);		this.addControl(new ButtonCmd(uuid(),		{"caption":"Закрыть",		"onClick":function(){			self.onCancel();		},		"attrs":{			"title":"закрыть без сохранения"}		})	);				this.addFeatureControl();	this.addMapControl();		}extend(ClientDestinationDialog_View,Map_View);ClientDestinationDialog_View.prototype.setMethodParams = function(pm,checkRes){	ClientDestinationDialog_View.superclass.setMethodParams.call(this,pm,checkRes);	//extra fields	pm.setParamValue("region",this.m_kladrView.m_ctrlRegion.getValue());	pm.setParamValue("raion",this.m_kladrView.m_ctrlRaion.getValue());	pm.setParamValue("naspunkt",this.m_kladrView.m_ctrlNasPunkt.getValue());	pm.setParamValue("gorod",this.m_kladrView.m_ctrlGorod.getValue());	pm.setParamValue("ulitza",this.m_kladrView.m_ctrlUlitza.getValue());	console.log("ClientDestinationDialog_View.prototype.setMethodParams PublicMethod.id="+pm.getId());	if (pm.getId()=="insert"){		pm.setParamValue("ret_id","1");	}}ClientDestinationDialog_View.prototype.onWriteOk = function(resp){	ClientDestinationDialog_View.superclass.onWriteOk.call(this,resp);	var contr = this.getWriteController();	var meth_id = this.getWriteMethodId();	if (meth_id=="insert"){		var pm = contr.getPublicMethodById("get_object");		this.m_lastInsertedId = pm.getParamValue("id");	}}ClientDestinationDialog_View.prototype.addFeatureControl = function(){	var self = this;	this.m_markerSet = new MarkerSetControl("map_drawing",		{"className":"form-group",	"onNavigate":function(){		self.m_markerLayer.activateNavigation();		},	"onDrag":function(){		self.m_markerLayer.activateDragging();		},	"onDraw":function(){		self.m_markerLayer.activateDrawing();		},			"onDelete":function(){		self.m_markerLayer.deleteZone();		}	});	this.addControl(this.m_markerSet);	}ClientDestinationDialog_View.prototype.addFeatures = function(){	var point = this.m_ctrlZoneCenterStr.getValue().split(" ");		var self = this;	this.m_markerLayer = new MarkerLayer({		"map":this.m_map,		"objDescr":"Объект для доставки",		"points":null,		"doDraw":true,		"drawComplete":function(coordsStr){			self.m_ctrlZoneCenterStr.setValue(coordsStr);		},		"featureType":OpenLayers.Handler.Point				});	var lon,lat,zoom;	if (point.length>=2){		lon = point[0];		lat = point[1];		zoom = TRACK_CONSTANTS.FOUND_ZOOM;					this.m_markerLayer.drawZoneOnCoords(point);	}	else{		lon = NMEAStrToDegree(CONSTANT_VALS.map_default_lon);		lat = NMEAStrToDegree(CONSTANT_VALS.map_default_lat);		zoom = TRACK_CONSTANTS.INI_ZOOM;	}		this.m_markerLayer.moveMapToCoords(lon,lat,zoom);	}ClientDestinationDialog_View.prototype.getAddressGPS = function(){	var self = this;	this.setEnabled(false);	this.setGlobalWait(true);	var contr = new ClientDestination_Controller(new ServConnector(HOST_NAME));	contr.run("get_address_gps",{		"async":true,		"params":{			"region":this.m_kladrView.m_ctrlRegion.getValue(),			"region_code":this.m_kladrView.m_ctrlRegion.getAttr("fkey_region_code"),			"raion":this.m_kladrView.m_ctrlRaion.getValue(),			"raion_code":this.m_kladrView.m_ctrlRaion.getAttr("fkey_raion_code"),			"naspunkt":this.m_kladrView.m_ctrlNasPunkt.getValue(),			"naspunkt_code":this.m_kladrView.m_ctrlNasPunkt.getAttr("fkey_naspunkt_code"),			"gorod":this.m_kladrView.m_ctrlGorod.getValue(),			"gorod_code":this.m_kladrView.m_ctrlGorod.getAttr("fkey_gorod_code"),			"ulitza":this.m_kladrView.m_ctrlUlitza.getValue(),			"ulitza_code":this.m_kladrView.m_ctrlUlitza.getAttr("fkey_ulitza_code"),			"dom":this.m_kladrView.m_ctrlDom.getValue()		},		"func":function(resp){			var model=resp.getModelById("gps");			model.setActive(true);			if (model.getNextRow()){				var lon = model.getFieldValue("lon");				var lat = model.getFieldValue("lat");				var point = [lon,lat];				self.m_markerLayer.deleteZone();				self.m_markerLayer.drawZoneOnCoords(point);				self.m_markerLayer.moveMapToCoords(lon,lat,TRACK_CONSTANTS.FOUND_ZOOM);				}			self.setEnabled(true);			self.setGlobalWait(false);		},		"err":function(resp,errCode,errStr){			self.setEnabled(true);			self.setGlobalWait(false);			//alert(errStr);			//self.getErrorControl().setValue(errStr);			WindowMessage.show({"text":errStr});		}	});}ClientDestinationDialog_View.prototype.toDOM = function(parent){	ClientDestinationDialog_View.superclass.toDOM.call(this,parent);		this.m_kladrView.m_ctrlGorod.getNode().focus();}
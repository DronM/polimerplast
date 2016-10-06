/* Copyright (c) 2012 	Andrey Mikhalevich, Katren ltd.*//*		Description*///ф/** Requirements * @requires controls/ViewList.js*//* constructor */function DOCOrderCurrentList_View(id,options){	options = options || {};	options.title = "Текущие заявки";		options.state = true;		var cmd_opts = {};		if (SERV_VARS.ROLE_ID=="client"){		options.readModelId = "DOCOrderCurrentForClientList_Model";		options.readMethodId = "get_current_for_client_list";						cmd_opts.noDelete = true;	}	else if (SERV_VARS.ROLE_ID=="production"){		options.readModelId = "DOCOrderCurrentForProductionList_Model";		options.readMethodId = "get_current_for_production_list";			}	else{		options.readModelId = "DOCOrderCurrentList_Model";		options.readMethodId = "get_current_list";					}			options.pagination = new GridPagination(id+"_cont_all_orders_grid_pag",{			"countPerPage":CONSTANT_VALS.grid_rows_per_page_count,			"showPageCount":5	}),		options.commands = new GridCommands(id+"_grid_cmd",cmd_opts);				DOCOrderCurrentList_View.superclass.constructor.call(this,		id,options);		var popup_menu = new PopUpMenu();	if (SERV_VARS.ROLE_ID=="sales_manager"||	SERV_VARS.ROLE_ID=="admin"){		var btn;				//doc devision		btn = new BtnOrderDivis({"grid":this.m_grid});		options.commands.addElement(btn);		popup_menu.addButton(btn);				//doc cancel state		btn = new BtnCancelLastState({"grid":this.m_grid});		options.commands.addElement(btn);		popup_menu.addButton(btn);		//to production		btn = new BtnPassToProduction({"grid":this.m_grid});		options.commands.addElement(btn);		popup_menu.addButton(btn);				popup_menu.addSeparator();				//print		btn = new BtnPrint({"grid":this.m_grid});		options.commands.addElement(btn);		popup_menu.addButton(btn);		//check		btn = new BtnPrintCheck({"grid":this.m_grid});		options.commands.addElement(btn);		popup_menu.addButton(btn);				popup_menu.addSeparator();				//set paid		btn = new BtnSetPaid({"grid":this.m_grid});		options.commands.addElement(btn);		popup_menu.addButton(btn);				//unset paid		if (SERV_VARS.ROLE_ID=="admin"){			btn = new BtnSetNotPaid({"grid":this.m_grid});			options.commands.addElement(btn);			popup_menu.addButton(btn);		}				//в бухгалтерию		btn = new BtnPaidToAcc({"grid":this.m_grid});		options.commands.addElement(btn);		popup_menu.addButton(btn);						popup_menu.addSeparator();				//Закрыть		btn = new BtnSetClosed({"grid":this.m_grid});		options.commands.addElement(btn);		popup_menu.addButton(btn);						//опрос		if (SERV_VARS.ROLE_ID=="marketing"||SERV_VARS.ROLE_ID=="admin"){			btn = new BtnCustomSurvey({"grid":this.m_grid});			options.commands.addElement(btn);			popup_menu.addButton(btn);		}				popup_menu.addSeparator();				//счет		btn = new BtnPrintOrder({"grid":this.m_grid});		options.commands.addElement(btn);		popup_menu.addButton(btn);				//торг12		btn = new BtnPrintTorg12({"grid":this.m_grid});		options.commands.addElement(btn);		popup_menu.addButton(btn);				//счет фактура		btn = new BtnPrintInvoice({"grid":this.m_grid});		options.commands.addElement(btn);		popup_menu.addButton(btn);				//УПД		btn = new BtnPrintUPD({"grid":this.m_grid});		options.commands.addElement(btn);		popup_menu.addButton(btn);				//ТТН		btn = new BtnPrintTTN({"grid":this.m_grid});		options.commands.addElement(btn);		popup_menu.addButton(btn);				//ТТН+УПД		btn = new BtnPrintShipDocs({"grid":this.m_grid});		options.commands.addElement(btn);		popup_menu.addButton(btn);					}	else if (SERV_VARS.ROLE_ID=="production"){		//Печать		btn = new BtnPrint({"grid":this.m_grid});		options.commands.addElement(btn);		popup_menu.addButton(btn);				//Печать всех		btn = new BtnPrintAll({"grid":this.m_grid});		options.commands.addElement(btn);		popup_menu.addButton(btn);						//check		btn = new BtnPrintCheck({"grid":this.m_grid});		options.commands.addElement(btn);		popup_menu.addButton(btn);				popup_menu.addSeparator();		//Готова		btn = new BtnSetReady({"grid":this.m_grid});		options.commands.addElement(btn);		popup_menu.addButton(btn);				//отгрузка		btn = new BtnSetShipped({"grid":this.m_grid});		options.commands.addElement(btn);		popup_menu.addButton(btn);						popup_menu.addSeparator();				//Отменить посл. статус		btn = new BtnCancelLastState({"grid":this.m_grid});		options.commands.addElement(btn);		popup_menu.addButton(btn);			}	else if (SERV_VARS.ROLE_ID=="marketing"){		btn = new BtnCustomSurvey({"grid":this.m_grid});		options.commands.addElement(btn);		popup_menu.addButton(btn);	}		//паспорт качества	/*	btn = new BtnPrintPassport({"grid":this.m_grid});	this.m_customCommands.addElement(btn);	popup_menu.addButton(btn);			*/		popup_menu.addSeparator();	options.commands.commandsToPopUp(popup_menu);		this.m_grid.setPopUpMenu(popup_menu);}extend(DOCOrderCurrentList_View,DOCOrderBaseList_View);
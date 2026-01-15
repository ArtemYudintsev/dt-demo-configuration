

////////////////////////////////////////////////////////////////////////////////
Var BarcodeScannerDriver Export; 
Var BackgroundJobIdentifier Export;

Procedure AfterExchangeDataWithMainServer(NotificationOfSynchrorizationEnabled, StandardProcessing)
	Notify("");
EndProcedure

////////////////////////////////////////////////////////////////////////////////

Procedure OnGlobalSearchResultActionChoice(ResultItem, Action)
	
	If Action = "OrderDocument" Then
		
		FillingValues = New Structure("Customer", ResultItem.Value);
		Parameters = New Structure("FillingValues", FillingValues);

		OpenForm("Document.OrderDocument.ObjectForm", Parameters);
		
	EndIf;
	
EndProcedure

Procedure OnStart()

#If Not MobileClient Then 
	Parameters = ServiceMechanisms.GetParameters();
	SetShortApplicationCaption(Parameters.ShortCaption);
	
	TaskbarOperations.ДобавитьКнопки(Parameters.OSTaskbarSettings);
	
	BotClient.OnStart();
#EndIf

#If MobileClient Then 
	
	// идентификатор подписчика надо получать регулярно, он может измениться
	УведомленияКлиент.ОбновитьИдентификаторПодписчикаУведомлений();
	
	// Подключение обработчика push-уведомлений
	CallbackDescription = New CallbackDescription("ОбработкаУведомлений", УведомленияКлиент);
	DeliverableNotifications.AttachNotificationHandler(CallbackDescription);
	
	// Подключение обработчика геозон
	CallbackDescription = New CallbackDescription("ОбработкаУведомлений", LocationClient);
	LocationTools.AttachMonitoredGeofencesBordersCrossingDetectionHandler(CallbackDescription);
	
#EndIf

	GlobalSearchClient.УстановитьОписаниеГлобальногоПоиска();
	
EndProcedure

////////////////////////////////////////////////////////////////////////////////


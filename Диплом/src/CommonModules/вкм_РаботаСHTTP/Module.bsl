
#Область ПрограммныйИнтерфейс

Функция СтрокаJSON(ОбъектJSON) Экспорт
	ПараметрыЗаписи	= Новый ПараметрыЗаписиJSON(, Символы.Таб);
	Запись = Новый ЗаписьJSON;
	Запись.УстановитьСтроку(ПараметрыЗаписи);
	ЗаписатьJSON(Запись,ОбъектJSON);
	
	Возврат Запись.Закрыть();
	
КонецФункции  

Функция ОбъектJSON(СтрокаJSON) Экспорт
	Чтение = Новый ЧтениеJSON;
	Чтение.УстановитьСтроку(СтрокаJSON); 
	ОбъектJSON = ПрочитатьJSON(Чтение);
	Чтение.Закрыть();
	
	Возврат ОбъектJSON;
	
КонецФункции   

Функция ОтветJSON(Объект, КодСостояния = 200) Экспорт
	
	ОтветJSON = Новый HTTPСервисОтвет(КодСостояния);
	ОтветJSON.УстановитьТелоИзСтроки(СтрокаJSON(Объект));
	ОтветJSON.Заголовки.Вставить("Content-Type", ТипКонтентаJSON());
	
	Возврат ОтветJSON;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТипКонтентаJSON() Экспорт
    Возврат "application/json";
КонецФункции                   

Функция ПростойУспешныйОтвет() Экспорт
	
	Result = Новый Структура;
	Result.Вставить("Result", "OK"); 
	
	Возврат ОтветJSON(Result);
	
КонецФункции   

Функция ОтветОбОшибке(ИнформацияОбОшибке) Экспорт
	
	//@skip-check object-deprecated
	ЗаписьЖурналаРегистрации("HTTPСервисы.Ошибка", УровеньЖурналаРегистрации.Ошибка,,,ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	
	Result = Новый Структура;
	Result.Вставить("Result", "Error"); 
	//@skip-check object-deprecated
	Result.Вставить("Info", КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		
	Возврат ОтветJSON(Result, 500);
	
КонецФункции   

Процедура ЗаписьЛога(ИмяМетода, Запрос, Ответ) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	докВходящийНТТРЗапрос = Документы.ВКМ__ВходящийНТТРЗапрос.СоздатьДокумент();  
	докВходящийНТТРЗапрос.ИмяМетода = ИмяМетода;        
	ТелоЗапроса = Запрос.ПолучитьТелоКакСтроку();
	ТелоЗапроса = СтрокаJSON(ОбъектJSON(ТелоЗапроса));
	докВходящийНТТРЗапрос.ТелоЗапроса = ТелоЗапроса;
	докВходящийНТТРЗапрос.КодСостояния = Ответ.КодСостояния;
	докВходящийНТТРЗапрос.Дата = ТекущаяДатаСеанса();
	докВходящийНТТРЗапрос.Записать();
КонецПроцедуры

#КонецОбласти

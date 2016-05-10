package events 
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author ф
	 */
	public class GlobalDispatcher
	{
		
		private static var _dispatcher:EventDispatcher = new EventDispatcher();
		private static var _listenerList:Dictionary = new Dictionary();
		public static var countOfListeners:uint = 0;
		
		public static function dispatch($event:GameEvent):void 
		{
			_dispatcher.dispatchEvent($event);//event gain from function dispatch()
		}
		
		public static function listen($type:String,$handler:Function):void 
		{
			countOfListeners = countDictionary(_listenerList);
			_listenerList[$type] = $handler;
			_dispatcher.addEventListener($type, $handler);//gain from function listen
		}
		
		public static function removeListener($type:String):void
		{
			
			if (_listenerList[$type]==null) //_listenerList[eventconstants.ON_READY="OnReady"]
			{
				return;
			}
			_dispatcher.removeEventListener($type, _listenerList[$type]);//("OnReady",_listenerList["OnReady"]=OnReadyHandler)
			_listenerList[$type] = null;
		
		}
		
		public static function removeAllListeners():void 
		{
			for (var item:String in _listenerList) 
			{
				if (_listenerList[item]!=null) 
				{
					_dispatcher.removeEventListener(item, _listenerList[item]);
					_listenerList[item] == null;
					
					trace (_listenerList[item]+"listener removed");
				}
			}
		}
		public static function countDictionary($dict:Dictionary):int 
		{
			var n:int = 0;
            for (var key:* in $dict) {
            n++;
              }
            return n;
		}
	}

}
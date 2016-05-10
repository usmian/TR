package superClasses 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author ф
	 */
	public class BaseClass 
	{
		private var _timer:Timer;
		private var _callBack:Function;
		private var _args:Object;
		public function BaseClass() 
		{
			//call in constructor main function
			onRegister();
			//this is abstraction class
		}
		protected function onRegister():void 
		{
			//for override
		}
		protected function onDispose():void 
		{
			//for override
		}
		
		protected function delay($time:Number,$callBack:Function,$args:Object=null):void 
		{
			_callBack = $callBack;
			_args = $args;
			_timer = new Timer($time);
			_timer.addEventListener(TimerEvent.TIMER, onTimerHandler );
			_timer.start();
		}
		
		private function onTimerHandler(e:TimerEvent):void 
		{
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, onTimerHandler );
	                _timer = null;
			//callback function with arguments
			_callBack(_args);
	
		}
		
		
	}

}

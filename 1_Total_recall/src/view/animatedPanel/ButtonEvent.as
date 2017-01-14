package view.animatedPanel 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ф
	 */
	public class ButtonEvent extends Event 
	{
		
		public var params:Object;
		public var index:uint;
		public function ButtonEvent(type:String,$params:Object=null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			params = $params;
		}
		
	}

}
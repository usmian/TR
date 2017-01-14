package vkConnection.vkEvents 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ф
	 */
	
	public class EventVk extends Event 
	{
	    public static const ADD_FRIENDS:String = "AddFriends";
		public static const ADD_PLAYER:String = "AddPlayer";
		public var params:Object;
		public function EventVk(type:String,$params:Object = null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			params = $params;
			
		}
		
	}

}
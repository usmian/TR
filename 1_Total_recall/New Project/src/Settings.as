package 
{
	/**
	 * ...
	 * @author ф
	 */
	public class Settings 
	{
		public static const FRAMERATE:int = 24;
		
		public static const OPEN_ITEMS_LIMIT:uint = 2;
		public static const ITEMS_L1:uint = 5;
		public static const MAX_DELETE_ITEMSL1:uint = 4;
		public static const DELAY:uint = 500;
		public static const DELAY_START:uint = 1500;
		public static const DELAY_POPUP:uint = 1800;
		public static const DELAY_HIT:uint = 500;
		
		public static const LIFE:int = 200;
		public static const MAX_LIFE:int = 200;
		public static const DAMAGE:uint = 25;
		public static const SCORE_DEC:uint = 35;
		
		
		//состояния которые ловятся при изменении приложения
		public static const IDLE_STATE:String = "IdleState";//nothing opened
		public static const OPENING_STATE:String = "OpeningState";//opened
		public static const RESULT_STATE:String = "ResultState";//all elements opened
		
		
		
	}

}
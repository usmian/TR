package
{
	import controller.MainController;
	import flash.display.Sprite;
	import flash.events.Event;
	import model.MainModel;
	import view.MainView;
	import flash.display.StageScaleMode;
	import view.PopUpView;
	import vkConnection.vkView.VkClass;
	import vkConnection.vkView.AvatarView;
	
	/**
	 * ...
	 * @author ф
	 */
	
	public class MyApp extends Sprite 
	{
		
		public function MyApp() 
		{
			if (stage) initApp();
			else addEventListener(Event.ADDED_TO_STAGE, initApp);
		}
		
		private function initApp(e:Event=null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			trace("My App is going");
			
			Facade.gameStage = stage;
			
			Facade.gameStage.scaleMode = StageScaleMode.NO_SCALE;
			
			Facade.gameModel = new MainModel();
			Facade.gameController = new MainController();
			Facade.gameView = new MainView();
			Facade.popUp = new PopUpView();
		}
		
		public static function getVk():void 
		{
			Facade.vkConnect = new VkClass();
			Facade.vkView = new AvatarView();			
		}
		
		
	}
	
}
package view 
{
	import superClasses.BaseClass;
	import events.GlobalDispatcher;
	import events.GameEvent;
	
	import flash.display.MovieClip;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import events.*;
	/**
	 * ...
	 * @author ф
	 */
	public class PopUpView extends BaseClass 
	{
			
	private var _popups:MovieClip;
	
	override protected function onRegister():void 
	{
		trace('popupRegister');
	}
		
	public function onEndOfLevelView(e:GameEvent):void 
	
	{
		
		delay(Settings.DELAY_POPUP, endOfLevel, e);
	}
	
	private function endOfLevel(e:GameEvent):void 
	{
		trace('level end');
		showPopup('end_level');
		(_popups.getChildByName("turnsTxt") as TextField).text = String(e.params);
		(_popups.getChildByName("scoreTxt") as TextField).text = String(e.counterForScore);
	}
	
	private function showPopup($type:String):void 
	{
		_popups = new popup();
		 Facade.gameStage.addChild(_popups);//popup show after all items removed
		 _popups.x = _popups.y = Facade.gameStage.stageHeight / 4 - 50;
		 Facade.gameView.turnButtonsOff(true);
		_popups.addEventListener(MouseEvent.CLICK, popups_click);
		_popups.gotoAndStop($type);
	}
	
	private function popups_click(e:MouseEvent):void 
	{
		if (e.target.name=="butNext") 
		{
			_popups.removeEventListener(MouseEvent.CLICK, popups_click);
			hidePopup('end_level');
			GlobalDispatcher.dispatch(new GameEvent(EventConstants.HIDE_POPUP));
		}
	}
	
	internal function hidePopup($type:String):void 
	
	   {
		if (!_popups) 
		{
			return;
		}
		Facade.gameView.turnButtonsOff(false); 
		Facade.gameStage.removeChild(_popups);//popup hide
		_popups = null;
		
	   }
	
	}

}
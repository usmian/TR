package controller 
{
	import flash.display.MovieClip;
	import superClasses.BaseClass;
	import events.*;
	import vkConnection.vkView.VkClass;
	import vkConnection.vkView.AvatarView;
	/**
	 * ...
	 * @author ф
	 */
	public class MainController extends BaseClass
	{
		

		override protected function onRegister():void 
		{
			trace('onRegisterController');
			GlobalDispatcher.listen(EventConstants.READY_TO_START, onReadyToStart);
			GlobalDispatcher.listen(EventConstants.START_GAME, onStartGameHandler);
			GlobalDispatcher.listen(EventConstants.BACK_TO_MENU, onBackGameHandler);
			GlobalDispatcher.listen(EventConstants.READY_TO_DRAW, onReadyToDraw);
			//create game overed. Gameplay started
			GlobalDispatcher.listen(EventConstants.CLICK_TO_CARD, onClickToCard);
			GlobalDispatcher.listen(EventConstants.PERMITT_TO_ADD, onPermittToAddViewHandler);
			GlobalDispatcher.listen(EventConstants.MOVES_COUNTER_UPDATED, onMovesCounterUpdated);
			GlobalDispatcher.listen(EventConstants.ON_LIFE_UPDATE, onLifeUpdate);
			GlobalDispatcher.listen(EventConstants.RESULT_TURN, onResultTurn);
			GlobalDispatcher.listen(EventConstants.END_TURN, onEndTurnHandler);
			GlobalDispatcher.listen(EventConstants.END_OF_LEVEL, onEndOfLevelHandler);
			GlobalDispatcher.listen(EventConstants.GAME_OVER, onGameOverHandler);
			GlobalDispatcher.listen(EventConstants.HIDE_POPUP, onHidePopupHandler);
			
		}
		
		private function onGameOverHandler(e:GameEvent):void 
		{
			Facade.gameView.gameOverView();
			Facade.gameView.turnButtonsOff(true);
		}
		
		private function onLifeUpdate(e:GameEvent):void 
		{
			Facade.gameView.lifeUpdateView(e.params as Object);
		}
		
		private function onHidePopupHandler(e:GameEvent):void 
		{
			Facade.gameView.nextLevel();	
		}
		
		private function onReadyToStart(e:GameEvent):void 
		{
		   
			Facade.gameView.onReadyRasterization();
		    GlobalDispatcher.removeListener(EventConstants.READY_TO_START);	 
		}
		
		private function onEndOfLevelHandler(e:GameEvent):void 
		{//trow to popup count of turns as e.params and count of score as e.counterForScore
			
			Facade.popUp.onEndOfLevelView(e);
		}
		
		private function onReadyToDraw(e:GameEvent):void 
		{
			Facade.gameView.onReadyToDrawView(e);
		}
				
		private function onPermittToAddViewHandler(e:GameEvent):void 
		{
			Facade.gameView.onPermittToAdd(e.params as MovieClip);//turn 1
		}
		
		private function onMovesCounterUpdated(e:GameEvent):void 
		{
			Facade.gameView.onCounterView(e.params as uint);
		}
		
		
		private function onEndTurnHandler(e:GameEvent):void 
		{
			Facade.gameModel.endTurn();
		}
				
		private function onStartGameHandler(e:GameEvent):void 
		
		{
			trace("GameStart");
			Facade.gameModel.init();
		}
		
		private function onBackGameHandler(e:GameEvent):void 
		
		{
			trace("BackToMenu");
			Facade.vkConnect.destroyVkConnection();
			Facade.vkView = null;
			Facade.vkConnect = null;
		}
			
		private function onClickToCard(e:GameEvent):void //listen to view
		
		{
			Facade.gameModel.openItems(e.params as MovieClip);//click to CARD
			trace("click to card");
		}	
		
		private function onResultTurn(e:GameEvent):void //listen to model 
		
		{
			Facade.gameView.onResultTurnView(e.params as Boolean);
		}
			
		public function removeListenersController():void//for remove all listeners
		{
			
			GlobalDispatcher.removeAllListeners();
		}
	}

}
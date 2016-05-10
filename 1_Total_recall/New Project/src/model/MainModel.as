package model //в модели крутится логика
{
	import superClasses.BaseClass;
	import events.*;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author ф
	 */
	public class MainModel extends BaseClass
	{
		private var _symblolList:Vector.<uint>;
		private var _arr_number:Array;
		private var _ItemsOpenlList:Vector.<String>;
		private var _state:String;
		private var _movesCounter:uint;
		private var _deleteItemsCounter:uint;
		private var _scoreCounter:int;
		private var _lifeCounter:int;
		private var _lifeFrame:int;
	
		override protected function onRegister():void 
		{
			trace("modelOnRegister");
		}
		
		public function init():void 
		{
			 
			 state = Settings.IDLE_STATE;//set to state when all of items are closed
			_lifeCounter = Settings.LIFE;
			_lifeFrame = Settings.FRAMERATE;
			_scoreCounter = 0;
			_movesCounter = 0;
			_deleteItemsCounter = 0;
	 		 
	 	  	_lifeFrame = Settings.FRAMERATE;
	         	 _arr_number = new Array();//additional massive
			
			_symblolList = new Vector.<uint>;//massive with random numbers
		        _ItemsOpenlList = new Vector.<String>;//massive with opened color items
			
			fillSymbolList();//first-random filling _symbolList, then dipatch ready to draw and kick _symbolList to view
			fillSymbolList();//2 different random massive 
			GlobalDispatcher.dispatch(new GameEvent(EventConstants.READY_TO_DRAW, _symblolList));//set _symbol list to param in event
			
		}
		
	
		private function fillSymbolList():void
		
		{
			massiv_num();//create simple massive for enum
			
			for (var i:uint = 1; i < Settings.ITEMS_L1; i++) 
			{
				var random_num:uint= Math.floor(Math.random()*(Settings.ITEMS_L1-i))//рандомное чищло
	         		    _symblolList.push(_arr_number[random_num]);//пихаем в 0 индекс окончательного массива рандомное число
	         			_arr_number.splice(random_num, 1);//убираем из массива по порядку рандомное число 
			}
			
		}
		
		private function massiv_num():void
		
		{
			
			for (var i:uint = 1; i < Settings.ITEMS_L1; i++) 
			{
				_arr_number.push(i);
			}
		}
		
		public function openItems($item:MovieClip):void //in controller receive click for item
		
		{		
		    if (state==Settings.RESULT_STATE) //if result state than items no reaction for click
				{
					return;
				}
			
			_ItemsOpenlList.push($item.currentLabel);//currentLabel is color
			
			GlobalDispatcher.dispatch(new GameEvent(EventConstants.PERMITT_TO_ADD, $item));//if click once then permitt to add 2 item
			
			if (_ItemsOpenlList.length==Settings.OPEN_ITEMS_LIMIT) //if lenght bigger than 2
			{
						_movesCounter++;
						GlobalDispatcher.dispatch(new GameEvent(EventConstants.MOVES_COUNTER_UPDATED, _movesCounter));
			         	        GlobalDispatcher.dispatch(new GameEvent(EventConstants.RESULT_TURN,checkItems()));//засылаем результат вызова функции вместе с событием
						state = Settings.RESULT_STATE;//if click twice then return
						//checkItems() call in dispatch			
			}
			else
			{
				state = Settings.OPENING_STATE;
			}//opening state isnt use

		}
		
		private function checkItems():Boolean
		
		{
			var item:String = _ItemsOpenlList[0];//string label of color
			
			for (var i:uint = 1; i < _ItemsOpenlList.length; i++) 
			{
				
				if (item != _ItemsOpenlList[i]) 
				{
					_ItemsOpenlList.length = 0;//anyway clean massive IOL 
					_scoreCounter -= Settings.SCORE_DEC;
					_lifeCounter -= Settings.DAMAGE;
				   	 GlobalDispatcher.dispatch(new GameEvent(EventConstants.ON_LIFE_UPDATE,lifeUpdate()));
					 if (_lifeCounter <= 0)
				    {
			        	delay(2000, overGame);
				    }
				
				        	 return false;
				}
			}
			_ItemsOpenlList.length = 0;//anyway clean massive IOL 
			_deleteItemsCounter++;
			_scoreCounter += 100;
			 return true;
		}
		private function overGame($for_args:Object=null):void
		{
			 trace("GameOver");
			 GlobalDispatcher.dispatch(new GameEvent(EventConstants.GAME_OVER));
		}
		private function lifeUpdate():Object
		{
			
			_lifeFrame=Settings.FRAMERATE;
			var percent:int;
			percent = (_lifeCounter / Settings.MAX_LIFE) * 100;
			_lifeFrame-=Math.floor((percent * Settings.FRAMERATE) / 100);
	                var obj:Object = {frame:_lifeFrame, txt:_lifeCounter};//sell 2 parameters
			return obj;	
			
			
		}
		
		public function getScoreTxt():int
		{
			var _score:int = _scoreCounter;
			return _score;
		}
		
		public function endTurn():void 
		{
			if (_deleteItemsCounter==Settings.MAX_DELETE_ITEMSL1)//if count of deleted items match to this level max
			{
				var event:GameEvent = new GameEvent(EventConstants.END_OF_LEVEL, _movesCounter);
				event.counterForScore = getScoreTxt();
				GlobalDispatcher.dispatch(event);//end level		
			}
			state = Settings.IDLE_STATE;
		}
		
		public function get state():String 
		{
			return _state;
		}
		
		public function set state(value:String):void 
		{
			_state = value;
		}
	}
 
}
